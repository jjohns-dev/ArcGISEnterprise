function Find-ServerGeocodeAddress {
    <#
    .SYNOPSIS
        GeoCode a list of locations
    .DESCRIPTION
        Geocode an entire list of addresses in one request. Geocoding many addresses at once is also known as batch or bulk geocoding.
    .PARAMETER ServiceName
        Geocode Server Service Name
    .PARAMETER SingleLine
        Location to be geocoded
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Porta token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Find-ServerGeocodeAddress @cmnParams -SingleLine '380 New York St, Redlands, CA 92373', '1600 Amphitheatre Pkwy, Mountain View, CA 94043'
        Returns geocoded addresses with accuracy and location information
    .NOTES
        Name:     Find-ServerGeocodeAddress
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-01-23
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/geocode/geocode-addresses/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Geocode Server Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $true, HelpMessage = 'Location to be geocoded')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $SingleLine,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Server context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(Mandatory = $false, HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # CREATE WRAPPER
        $addressList = @{ records = @() }

        # EVALUATE EACH ADDRESS
        for ($i = 0; $i -lt $SingleLine.Count; $i++) {
            # CREATE CUSTOM RECORD OBJECT AND ADD IT TO THE WRAPPER
            $addressList.records += @{ attributes = @{ OBJECTID = ($i + 1); SingleLine = $SingleLine[$i] } }
        }

        # CONVERT WRAPPER TO JSON
        $addressList = $addressList | ConvertTo-Json -Depth 3

        # OUTPUT VERBOSE WRAPPER
        Write-Verbose -Message $addressList
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/rest/services/{1}/GeocodeServer/geocodeAddresses' -f $Context, $ServiceName
            Method  = 'POST'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority}
            Body    = @{
                f         = 'json'
                token     = $Token
                addresses = $addressList
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
function Find-ServerAddressCandidate {
    <#
    .SYNOPSIS
        GeoCode a location
    .DESCRIPTION
        Geocodes one location per request. The input address can be combined into a single input field or divided among multiple parameters.
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
        PS C:\> Find-ServerAddressCandidate @cmnParams -SingleLine '380 New York St, Redlands, CA 92373'
        Returns geocoded address candidates
    .NOTES
        Name:     Find-ServerAddressCandidate
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-01-23
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/geocode/find-address-candidates/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Geocode Server Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $true, HelpMessage = 'Location to be geocoded')]
        [ValidateNotNullOrEmpty()]
        [System.String] $SingleLine,

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
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/rest/services/{1}/GeocodeServer/findAddressCandidates' -f $Context, $ServiceName
            Method  = 'POST'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority}
            Body    = @{
                f          = 'json'
                token      = $Token
                SingleLine = $SingleLine
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
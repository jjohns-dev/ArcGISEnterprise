function Find-ServerReverseGeocode {
    <#
    .SYNOPSIS
        Reverse geocode a coordinate to an address.
    .DESCRIPTION
        The reverseGeocode operation determines the address at a particular x,y location.
    .PARAMETER ServiceName
        Geocode Server Service Name
    .PARAMETER Location
        The point from which to search for the closest address
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
        PS C:\> Find-ServerReverseGeocode @cmnParams -ServiceName 'MyGeoCoder' -Location ([pscustomobject] @{ x = -117.187592395203; y = 34.062863813743 })
        Returns physical address for provided location coordinates
    .NOTES
        Name:     Find-ServerReverseGeocode
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

        [Parameter(Mandatory = $true, HelpMessage = 'The point from which to search for the closest address')]
        [ValidateScript({ $_.psobject.Properties.Name -contains 'x' -and $_.psobject.Properties.Name -contains 'y' })]
        [ValidateScript({ $_.x -is [System.Double] -and $_.y -is [System.Double] })]
        [System.Object] $Location,

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
            Uri    = '{0}/rest/services/{1}/GeocodeServer/reverseGeocode' -f $Context, $ServiceName
            Method  = 'POST'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority}
            Body    = @{
                f        = 'json'
                token    = $Token
                location = '{0}, {1}' -f $Location.x, $Location.y
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
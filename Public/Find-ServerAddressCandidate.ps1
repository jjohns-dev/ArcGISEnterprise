function Find-ServerAddressCandidate {
    <#
    .SYNOPSIS
        GeoCode a location
    .DESCRIPTION
        Geocodes one location per request. The input address can be combined into a single input field or divided among multiple parameters.
    .PARAMETER ServiceName
        Geocode Server Service Name
    .PARAMETER FolderName
        Folder name in ArcGIS Server
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
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/geocode/find-address-candidates/
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Geocode Server Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $false, HelpMessage = 'Folder name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $FolderName,

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
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)

        # SET URI
        $uri = if ($PSBoundParameters.ContainsKey('FolderName')) {
            # SET URI WITH FOLDER
            '{0}/rest/services/{1}/{2}/GeocodeServer/findAddressCandidates' -f $Context, $FolderName, $ServiceName
        }
        else {
            # SET URI WITHOUT FOLDER
            '{0}/rest/services/{1}/GeocodeServer/findAddressCandidates' -f $Context, $ServiceName
        }
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = $uri
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
function Get-ServerAdminService {
    <#
    .SYNOPSIS
        Get ArcGIS Server service
    .DESCRIPTION
        Get ArcGIS Service service
    .PARAMETER ServiceName
        Name of service
    .PARAMETER ServiceType
        Type of service (e.g., FeatureServer or MapServer)
    .PARAMETER Folder
        Folder in ArcGIS Server
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServerAdminService -Context 'https://arcgis.com/arcgis' -Token $token -ServiceName SampleWorldCities -ServiceType MapServer
        Returns the service object for the SampleWorldCities service
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    [Alias('Get-ServerService')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        #[ValidateSet('FeatureServer', 'MapServer')]
        [System.String] $ServiceType,

        [Parameter(HelpMessage = 'Folder')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Folder,

        [Parameter(Mandatory, Position = 0, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        # SET URI PATH
        if ($PSBoundParameters.ContainsKey('Folder')) {
            $uri = '{0}/admin/services/{1}/{2}.{3}' -f $Context, $Folder, $ServiceName, $ServiceType
        }
        else {
            $uri = '{0}/admin/services/{1}.{2}' -f $Context, $ServiceName, $ServiceType
        }

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = $uri
            Method = 'GET'
            Body   = @{ f = 'json' }
        }

        # ADD TOKEN IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams.Body['token'] = $Token }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
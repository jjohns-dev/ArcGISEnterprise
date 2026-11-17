function Get-ServerServiceLifecycleInfo {
    <#
    .SYNOPSIS
        Get ArcGIS Server service lifecycle information
    .DESCRIPTION
        Get ArcGIS Service service lifecycle information
    .PARAMETER ServiceName
        Name of service
    .PARAMETER ServiceType
        Type of service (e.g., FeatureServer or MapServer)
    .PARAMETER FolderName
        Folder name in ArcGIS Server
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServerServiceLifecycleInfo -Context 'https://arcgis.com/arcgis' -Token $token -ServiceName SampleWorldCities -ServiceType MapServer
        Returns the service object lifecycle information for the SampleWorldCities service
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/serivce-lifecycle-info/
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $true, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        #[ValidateSet('FeatureServer', 'MapServer')]
        [System.String] $ServiceType,

        [Parameter(Mandatory = $false, HelpMessage = 'Folder name')]
        [ValidateNotNullOrEmpty()]
        [Alias('Folder')]
        [System.String] $FolderName,

        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        # SET URI PATH
        if ($PSBoundParameters.ContainsKey('FolderName')) {
            $uri = '{0}/admin/services/{1}/{2}.{3}/lifecycleinfos' -f $Context, $FolderName, $ServiceName, $ServiceType
        }
        else {
            $uri = '{0}/admin/services/{1}.{2}/lifecycleinfos' -f $Context, $ServiceName, $ServiceType
        }

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = $uri
            Method = 'GET'
            Body    = @{ f = 'json' }
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
        }

        # ADD TOKEN IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams['Headers']['X-Esri-Authorization'] = 'Bearer {0}' -f $Token }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
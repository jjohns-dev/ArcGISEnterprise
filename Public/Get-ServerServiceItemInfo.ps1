function Get-ServerServiceItemInfo {
    <#
    .SYNOPSIS
        Get ArcGIS Server service item information
    .DESCRIPTION
        Get ArcGIS Server service item information/details
    .PARAMETER Service
        ArcGIS Server service object (use Get-ServerAdminServiceList to retrieve object)
    .PARAMETER FolderName
        ArcGIS Server folder name
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
        PS C:\> Get-ServerServiceItemInfo -Context 'https://arcgis.com/arcgis' -Token $token -Service $s
        Returns the service item info for service $s
    .NOTES
        General notes:
        Used to require passing in a "Service" object from Get-ServerAdminServiceList
        https://developers.arcgis.com/rest/enterprise-administration/server/services.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'ArcGIS Server service object (use Get-ServerAdminServiceList)')]
        [ValidateScript({ $_.serviceName -and $_.type })]
        [System.Object] $Service,

        <# [Parameter(Mandatory = $true, HelpMessage = 'ArcGIS Server service name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $true, HelpMessage = 'ArcGIS Server service type')]
        [ValidateSet('MapServer', 'GeoDataServer', 'ImagerServer', 'GeoProcessingServer', 'GeocodeServer')]
        [System.String] $ServiceType, #>

        [Parameter(Mandatory = $false, HelpMessage = 'ArcGIS Server folder name')]
        [ValidateNotNullOrEmpty()]
        [Alias('Folder')]
        [System.String] $FolderName,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
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
            $uri = '{0}/admin/services/{1}/{2}.{3}/iteminfo' -f $Context, $FolderName, $Service.serviceName, $Service.type
        }
        else {
            $uri = '{0}/admin/services/{1}.{2}/iteminfo' -f $Context, $ServiceName, $ServiceType
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
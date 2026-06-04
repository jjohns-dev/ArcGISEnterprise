function Get-ServerServiceItemInfo {
    <#
    .SYNOPSIS
        Get ArcGIS Server service item information
    .DESCRIPTION
        Get ArcGIS Server service item information/details
    .PARAMETER ServiceName
        ArcGIS Server service name
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
        https://developers.arcgis.com/rest/enterprise-administration/server/services.htm
    #>
    [CmdletBinding()]
    Param(
        <# [Parameter(Mandatory = $true, HelpMessage = 'ArcGIS Server service object (use Get-ServerServiceList -Admin)')]
        [ValidateScript({ $_.serviceName -and $_.type })]
        [System.Object] $Service,

        [Parameter(Mandatory = $true, HelpMessage = 'ArcGIS Server service type')]
        [ValidateSet('MapServer', 'GeoDataServer', 'ImagerServer', 'GeoProcessingServer', 'GeocodeServer')]
        [System.String] $ServiceType, #>

        [Parameter(Mandatory = $true, HelpMessage = 'ArcGIS Server service name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

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
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET PARAMETERS
        $svcParams = $PSBoundParameters; $svcParams.Remove('ServiceName') | Out-Null

        # GET SERVICE LIST - $ServiceName WILL BE THE PARAMETERS, NO $ServiceType NEEDED
        $svcList = Get-ServerServiceList -Admin @svcParams

        # GET SERVICE
        $service = $svcList.services | Where-Object serviceName -EQ $ServiceName

        # VALIDATE SERVICE
        if (-Not $service) { Write-Error -Message ('Error 404: Service [{0}] not found.' -f $ServiceName) -ErrorAction Stop }
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/admin/services/{1}.{2}/iteminfo' -f $Context, $service.serviceName, $service.type
            Method = 'GET'
            Body   = @{ f = 'json' }
        }

        # SET URI PATH
        if ($PSBoundParameters.ContainsKey('FolderName')) {
            $restParams['Uri'] = '{0}/admin/services/{1}/{2}.{3}/iteminfo' -f $Context, $FolderName, $service.serviceName, $service.type
        }

        # ADD TOKEN IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams.Body['token'] = $Token }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
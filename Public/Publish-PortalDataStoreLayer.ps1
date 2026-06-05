function Publish-PortalDataStoreLayer {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .PARAMETER DataStoreId
        Id of the DataStore registered with Server
    .PARAMETER PortalId
        Portal application ID
    .PARAMETER PortalFolderId
        Portal folder ID
    .PARAMETER ServerId
        ID of the Server to which the DataStore is registered
    .PARAMETER ServerFolderName
        ArcGIS Server folder name
    .PARAMETER SyncItemInfo
        Updates layer item properties using using source dataset's metadata
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
        PS C:\> $itemList = Get-PortalUserItemList -Type 'Data Store' @commonParams
        PS C:\> $item = $itemList | Where-Object title -EQ 'DataStore_data_owner'
        PS C:\> $server = Get-PortalDataStoreServer -ItemId $item.id @commonParams
        PS C:\> $ptlFldList = Get-PortalUserFolderList @commonParams
        PS C:\> $portalFolder = $ptlFldList | Where-Object title -eq 'EGDB_Data_Owner'
        PS C:\> $serverInfo = Get-ServerServiceInfo -Context $target.Server -Token $token.token
        PS C:\> $serverFolder = $serverInfo.folders | Where-Object { $_ -EQ 'EGDB_Data_Owner' }
        PS C:\> $params = @{
            DataStoreId      = $item.id
            PortalFolderId   = $portalFolder.id
            ServerId         = $server.servers[0].id
            ServerFolderName = $serverFolder
        }
        PS C:\> $pub = Publish-PortalDataStoreLayer @params @commonParams
        PS C:\> Get-PortalJobStatus -JobId $pub.jobId -DataStoreId $pub.datastoreId -ServerId $pub.serverId @commonParams
        Publishes as ... layers all datasets in the 'DataStore_data_owner' DataStore item in Portal. Then check the job status.
    .EXAMPLE
        PS C:\> $sync = Publish-PortalDataStoreLayer -DataStoreId -SyncItemInfo $item.id @commonParams
        PS C:\> Get-PortalJobStatus -JobId $sync.jobId -DataStoreId $sync.datastoreId -ServerId $sync.serverId @commonParams
        Syncs and update all layer item properties using using source dataset's metadata. Then check the job status.
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/publish-layers.htm
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', DefaultParameterSetName = '_init')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = '_init', HelpMessage = 'DataStore Portal item ID')]
        [Parameter(Mandatory = $true, ParameterSetName = '_sync', HelpMessage = 'DataStore Portal item ID')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $DataStoreId,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal application ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF',

        [Parameter(Mandatory = $true, ParameterSetName = '_init', HelpMessage = 'Portal folder ID')]
        [ValidatePattern('([a-f0-9]{32}|/)')]
        [System.String] $PortalFolderId,

        [Parameter(Mandatory = $true, ParameterSetName = '_init', HelpMessage = 'ID of the Server where the DataStore is registered')]
        [ValidatePattern('[a-z0-9]{16}')]
        [System.String] $ServerId,

        [Parameter(Mandatory = $true, ParameterSetName = '_init', HelpMessage = 'ArcGIS Server folder name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServerFolderName,

        [Parameter(Mandatory = $false, ParameterSetName = '_sync', HelpMessage = 'Updates layer item properties using using source dataset''s metadata')]
        [System.Management.Automation.SwitchParameter] $SyncItemInfo,

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
    }
    Process {
        # CHECK PARAMETER SET NAME
        switch ($PSCmdlet.ParameterSetName) {
            '_init' {
                # SET BODY APPROPRIATELY
                $body = @{
                    f                 = 'json'
                    token             = $Token
                    datastoreId       = $DataStoreId
                    portalFolderId    = $PortalFolderId
                    serverId          = $ServerId
                    templateSvcConfig = '{"serviceName":null,"type":"MapServer","capabilities":"Map","extensions":[{"typeName":"FeatureServer","capabilities":"Query","enabled":"true","properties":{"maxRecordCount":"3500"}}]}'
                    serverFolder      = $ServerFolderName
                }
            }
            '_sync' {
                # SET BODY APPROPRIATELY
                $body = @{ f = 'json'; token = $Token; datastoreId = $DataStoreId }

                # CHECK FOR SYNC ITEM INFO
                if ($PSBoundParameters.ContainsKey('SyncItemInfo')) { $restParams['Body'].Add('syncItemInfo', $true) }
            }
        }

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/portals/{1}/datastores/allDatasets/publishLayers' -f $Context, $PortalId
            Method = 'POST'
            Body   = $body
        }

        # OUTPUT VERBOSE
        Write-Verbose -Message ($restParams['Body'] | Out-String)

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        if ($PSCmdlet.ShouldProcess($DataStoreId, 'Publish DataStore layers')) {
            Invoke-RestMethod @restParams
        }
    }
}
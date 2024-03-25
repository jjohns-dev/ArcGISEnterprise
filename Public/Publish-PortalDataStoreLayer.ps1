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
        PS C:\> Publish-PortalDataStoreLayer
        Explanation of what the example does
    .NOTES
        Name:     Publish-PortalDataStoreLayer
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-25
        - 0.1.0 - Initial version
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/publish-layers.htm
    #>
    [CmdletBinding()]
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
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
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
        Invoke-RestMethod @restParams
    }
}
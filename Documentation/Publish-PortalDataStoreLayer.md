# Publish-PortalDataStoreLayer

## SYNOPSIS
Short description

## SYNTAX

### _init (Default)
```
Publish-PortalDataStoreLayer -DataStoreId <String> [-PortalId <String>] -PortalFolderId <String>
 -ServerId <String> -ServerFolderName <String> -Context <Uri> -Token <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

### _sync
```
Publish-PortalDataStoreLayer -DataStoreId <String> [-PortalId <String>] [-SyncItemInfo] -Context <Uri>
 -Token <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Long description

## EXAMPLES

### EXAMPLE 1
```
$itemList = Get-PortalUserItemList -Type 'Data Store' @commonParams
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
```

### EXAMPLE 2
```
$sync = Publish-PortalDataStoreLayer -DataStoreId -SyncItemInfo $item.id @commonParams
PS C:\> Get-PortalJobStatus -JobId $sync.jobId -DataStoreId $sync.datastoreId -ServerId $sync.serverId @commonParams
Syncs and update all layer item properties using using source dataset's metadata. Then check the job status.
```

## PARAMETERS

### -DataStoreId
Id of the DataStore registered with Server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PortalId
Portal application ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0123456789ABCDEF
Accept pipeline input: False
Accept wildcard characters: False
```

### -PortalFolderId
Portal folder ID

```yaml
Type: String
Parameter Sets: _init
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerId
ID of the Server to which the DataStore is registered

```yaml
Type: String
Parameter Sets: _init
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerFolderName
ArcGIS Server folder name

```yaml
Type: String
Parameter Sets: _init
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SyncItemInfo
Updates layer item properties using using source dataset's metadata

```yaml
Type: SwitchParameter
Parameter Sets: _sync
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Context
Server context (e.g., https://arcgis.com/arcgis)

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token
Porta token

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
Ignore missing or invalid certificate

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.Object.
## NOTES
Name:     Publish-PortalDataStoreLayer
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-03-25
- 0.1.0 - Initial version
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/publish-layers.htm

## RELATED LINKS

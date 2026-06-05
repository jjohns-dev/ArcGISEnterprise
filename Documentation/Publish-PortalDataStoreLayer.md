---
document type: cmdlet
external help file: ArcGISEnterprise-Help.xml
HelpUri: ''
Locale: en-US
Module Name: ArcGISEnterprise
ms.date: 06/05/2026
PlatyPS schema version: 2024-05-01
title: Publish-PortalDataStoreLayer
---

# Publish-PortalDataStoreLayer

## SYNOPSIS

Short description

## SYNTAX

### _init (Default)

```
Publish-PortalDataStoreLayer -DataStoreId <string> -PortalFolderId <string> -ServerId <string>
 -ServerFolderName <string> -Context <uri> -Token <string> [-PortalId <string>]
 [-SkipCertificateCheck] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### _sync

```
Publish-PortalDataStoreLayer -DataStoreId <string> -Context <uri> -Token <string>
 [-PortalId <string>] [-SyncItemInfo] [-SkipCertificateCheck] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Long description

## EXAMPLES

### EXAMPLE 1

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

### EXAMPLE 2

$sync = Publish-PortalDataStoreLayer -DataStoreId -SyncItemInfo $item.id @commonParams
PS C:\> Get-PortalJobStatus -JobId $sync.jobId -DataStoreId $sync.datastoreId -ServerId $sync.serverId @commonParams
Syncs and update all layer item properties using using source dataset's metadata. Then check the job status.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Context

Server context (e.g., https://arcgis.com/arcgis)

```yaml
Type: System.Uri
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DataStoreId

Id of the DataStore registered with Server

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: _sync
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: _init
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PortalFolderId

Portal folder ID

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: _init
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PortalId

Portal application ID

```yaml
Type: System.String
DefaultValue: 0123456789ABCDEF
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ServerFolderName

ArcGIS Server folder name

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: _init
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ServerId

ID of the Server to which the DataStore is registered

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: _init
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SkipCertificateCheck

Ignore missing or invalid certificate

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SyncItemInfo

Updates layer item properties using using source dataset's metadata

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: _sync
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Token

Porta token

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.

{{ Fill in the Description }}

## OUTPUTS

### System.Object.

{{ Fill in the Description }}

### System.Management.Automation.PSCustomObject

{{ Fill in the Description }}

## NOTES

Status: Stable
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/publish-layers.htm


## RELATED LINKS

{{ Fill in the related links here }}


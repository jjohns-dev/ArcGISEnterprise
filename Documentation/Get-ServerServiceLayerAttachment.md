---
document type: cmdlet
external help file: ArcGISEnterprise-Help.xml
HelpUri: ''
Locale: en-US
Module Name: ArcGISEnterprise
ms.date: 06/05/2026
PlatyPS schema version: 2024-05-01
title: Get-ServerServiceLayerAttachment
---

# Get-ServerServiceLayerAttachment

## SYNOPSIS

Get ArcGIS service layer attachment(s)

## SYNTAX

### __gid (Default)

```
Get-ServerServiceLayerAttachment -GlobalId <string[]> -LayerId <int> -ServiceName <string>
 -Context <uri> [-FolderName <string>] [-Token <string>] [-SkipCertificateCheck]
 [<CommonParameters>]
```

### __oid

```
Get-ServerServiceLayerAttachment -ObjectId <long[]> -LayerId <int> -ServiceName <string>
 -Context <uri> [-FolderName <string>] [-Token <string>] [-SkipCertificateCheck]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The result of this operation are attachments grouped by the source feature object Ids and global ids (if exist)

## EXAMPLES

### EXAMPLE 1

Get-ServerServiceLayerAttachment @cmnParams -GlobalId '96B099D7-C4FD-4B73-99E6-C7D6552F4E22' -LayerId 0 -ServiceName 'dashboard'
Returns the attachment(s) for the feature with the global ID '96B099D7-C4FD-4B73-99E6-C7D6552F4E22' in the 'dashboard' service

## PARAMETERS

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

### -FolderName

Folder name in ArcGIS Server

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Folder
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

### -GlobalId

Global ID

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: __gid
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -LayerId

Service Layer ID

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
- Layer
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

### -ObjectId

Object ID

```yaml
Type: System.Int64[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: __oid
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ServiceName

Name of service

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
https://developers.arcgis.com/rest/services-reference/enterprise/query-attachments-feature-service-layer/

## RELATED LINKS

{{ Fill in the related links here }}


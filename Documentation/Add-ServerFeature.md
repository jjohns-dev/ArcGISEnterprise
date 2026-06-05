---
document type: cmdlet
external help file: ArcGISEnterprise-Help.xml
HelpUri: ''
Locale: en-US
Module Name: ArcGISEnterprise
ms.date: 06/05/2026
PlatyPS schema version: 2024-05-01
title: Add-ServerFeature
---

# Add-ServerFeature

## SYNOPSIS

Add feature to Feature Service

## SYNTAX

### __rcd

```
Add-ServerFeature -Record <Object[]> -ServiceName <string> -Context <uri> -Token <string>
 [-LayerId <int>] [-FolderName <string>] [-SkipCertificateCheck] [<CommonParameters>]
```

### __ftr

```
Add-ServerFeature -Feature <Object[]> -ServiceName <string> -Context <uri> -Token <string>
 [-LayerId <int>] [-FolderName <string>] [-SkipCertificateCheck] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Add feature to a Feature Service

## EXAMPLES

### EXAMPLE 1

Add-ServerFeature @commonParams -Record $rec -ServiceName "dashboard"
Add records to a Hosted Feature Service named "dashboard"

## PARAMETERS

### -Context

Portal context (e.g., https://arcgis.com/arcgis)

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

### -Feature

Feature to add to the Feature Service

```yaml
Type: System.Object[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: __ftr
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

Server Service Folder Name

```yaml
Type: System.String
DefaultValue: Hosted
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
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Record

Feature record or attributes to add

```yaml
Type: System.Object[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: __rcd
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

Portal Hosted Feature Service Name

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

Portal token

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
- See commit history for version changes
Comments:
https://developers.arcgis.com/rest/services-reference/enterprise/add-features.htm

## RELATED LINKS

{{ Fill in the related links here }}


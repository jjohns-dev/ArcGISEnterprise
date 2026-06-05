---
document type: cmdlet
external help file: ArcGISEnterprise-Help.xml
HelpUri: ''
Locale: en-US
Module Name: ArcGISEnterprise
ms.date: 06/05/2026
PlatyPS schema version: 2024-05-01
title: Edit-ServerFeature
---

# Edit-ServerFeature

## SYNOPSIS

Edit Feature Service

## SYNTAX

### _add (Default)

```
Edit-ServerFeature -Add <Object[]> -ServiceName <string> -Context <uri> -Token <string>
 [-LayerId <int>] [-FolderName <string>] [-SkipCertificateCheck] [<CommonParameters>]
```

### _upd

```
Edit-ServerFeature -Update <Object[]> -ServiceName <string> -Context <uri> -Token <string>
 [-LayerId <int>] [-FolderName <string>] [-SkipCertificateCheck] [<CommonParameters>]
```

### _doi

```
Edit-ServerFeature -DeleteObjectId <int[]> -ServiceName <string> -Context <uri> -Token <string>
 [-LayerId <int>] [-FolderName <string>] [-SkipCertificateCheck] [<CommonParameters>]
```

### _dgi

```
Edit-ServerFeature -DeleteGlobalId <string[]> -ServiceName <string> -Context <uri> -Token <string>
 [-LayerId <int>] [-FolderName <string>] [-SkipCertificateCheck] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Edit Feature Service using the /applyEdits endpoint.
This allows for adding, updating, or deleting features.

## EXAMPLES

### EXAMPLE 1

$feature = @{ attributes = @{ countyname = 'Fairfax'; countyid = 596; us_county_fips = 59; stateid = 39; us_state_fips = 51; us_full_fips = 51059 } }
PS C:\> Edit-ServerFeature @cmnParams -Add $feature
Adds a new feature to the Feature Service

### EXAMPLE 2

$feature = @{ attributes = @{ PointName = 'test'; Field2 = 'test2' }; geometry = @{ x = -77.306373; y = 38.855747; spatialReference = @{ wkid = 4326 } } }
PS C:\> Edit-ServerFeature @cmnParams -Add $feature
Adds a new feature with geometry to the Feature Service

### EXAMPLE 3

Edit-ServerFeature @cmnParams -DeleteObjectId @(1, 2, 3)
Deletes features with IDs 1, 2, and 3

## PARAMETERS

### -Add

Feature to add to the Feature Service

```yaml
Type: System.Object[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: _add
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

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

### -DeleteGlobalId

GlobalId of feature to delete

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: _dgi
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DeleteObjectId

ObjectId of feature to delete

```yaml
Type: System.Int32[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Delete
ParameterSets:
- Name: _doi
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

### -Update

Feature to update

```yaml
Type: System.Object[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: _upd
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
https://developers.arcgis.com/rest/services-reference/enterprise/apply-edits-feature-service-layer-.htm

## RELATED LINKS

{{ Fill in the related links here }}


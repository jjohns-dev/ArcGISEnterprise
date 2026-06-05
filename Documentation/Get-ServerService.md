---
document type: cmdlet
external help file: ArcGISEnterprise-Help.xml
HelpUri: ''
Locale: en-US
Module Name: ArcGISEnterprise
ms.date: 06/05/2026
PlatyPS schema version: 2024-05-01
title: Get-ServerService
---

# Get-ServerService

## SYNOPSIS

Get ArcGIS Server service metadata

## SYNTAX

### __AllParameterSets

```
Get-ServerService [-ServiceName] <string> [-ServiceType] <string> [[-FolderName] <string>]
 [-Context] <uri> [[-Token] <string>] [-Admin] [-SkipCertificateCheck] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Get ArcGIS Server service metadata

## EXAMPLES

### EXAMPLE 1

Get-ServerService @cmnParams -Folder 'Energy' -ServiceName 'Geology' -ServiceType 'FeatureServer'
Returns service metadata for the 'Geology' FeatureServer in the 'Energy' folder

## PARAMETERS

### -Admin

Use admin endpoint

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

### -Context

Server context (e.g., https://arcgis.com/arcgis)

```yaml
Type: System.Uri
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
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
  Position: 2
  IsRequired: false
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
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ServiceType

Type of service (e.g., FeatureServer or MapServer)

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
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
  Position: 4
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
https://developers.arcgis.com/rest/enterprise-administration/server/service/
https://developers.arcgis.com/rest/services-reference/enterprise/get-started-with-the-services-directory/
Performance Testing:
Using custom properties instead of custom objects for output appears to be slightly faster, but only slightly.
Below is the code used to test performance.
The cmdlet "Test-Performance" requires the SecurityTools modules.
Test-Performance -Runs 100 -ScriptBlock {
    $params = @{
        Context     = 'https://sampleserver6.arcgisonline.com/arcgis'
        ServiceName = 'DamageAssessment'
        ServiceType = 'FeatureServer'
    }
    Get-ServerService @params | Out-Null
}


## RELATED LINKS

{{ Fill in the related links here }}


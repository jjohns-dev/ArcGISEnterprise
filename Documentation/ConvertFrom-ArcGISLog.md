---
document type: cmdlet
external help file: ArcGISEnterprise-Help.xml
HelpUri: ''
Locale: en-US
Module Name: ArcGISEnterprise
ms.date: 06/05/2026
PlatyPS schema version: 2024-05-01
title: ConvertFrom-ArcGISLog
---

# ConvertFrom-ArcGISLog

## SYNOPSIS

Convert from ArcGIS log

## SYNTAX

### __AllParameterSets

```
ConvertFrom-ArcGISLog [-Path] <string> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Convert from ArcGIS Server or Portal log to array of objects

## EXAMPLES

### EXAMPLE 1

ConvertFrom-ArcGISLog -Path "C:\logs\myLog.log"
Converts all entries in the log to objects

## PARAMETERS

### -Path

Path to log file

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
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

### System.String.

{{ Fill in the Description }}

### System.String

{{ Fill in the Description }}

## OUTPUTS

### System.Management.Automation.PSCustomObject.

{{ Fill in the Description }}

### System.Management.Automation.PSCustomObject

{{ Fill in the Description }}

## NOTES

Status: Stable
Comments: No external API reference - utility function.

## RELATED LINKS

{{ Fill in the related links here }}


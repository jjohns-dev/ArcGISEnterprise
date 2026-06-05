---
document type: cmdlet
external help file: ArcGISEnterprise-Help.xml
HelpUri: ''
Locale: en-US
Module Name: ArcGISEnterprise
ms.date: 06/05/2026
PlatyPS schema version: 2024-05-01
title: ConvertFrom-Epoch
---

# ConvertFrom-Epoch

## SYNOPSIS

Convert from Epoch to DateTime

## SYNTAX

### __AllParameterSets

```
ConvertFrom-Epoch [-Milliseconds] <long[]> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Convert from Epoch in milliseconds to DateTime

## EXAMPLES

### EXAMPLE 1

1618614176000 | ConvertFrom-Epoch
Convert Epoch time of 1618614176000 to a DateTime object

## PARAMETERS

### -Milliseconds

Epoch Time in milliseconds

```yaml
Type: System.Int64[]
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

### System.Int64.

{{ Fill in the Description }}

### System.Int64

{{ Fill in the Description }}

### System.Int64[]

{{ Fill in the Description }}

## OUTPUTS

### System.DateTime.

{{ Fill in the Description }}

### System.DateTime

{{ Fill in the Description }}

## NOTES

Status: Stable
Comments: No external API reference — utility function.

## RELATED LINKS

{{ Fill in the related links here }}


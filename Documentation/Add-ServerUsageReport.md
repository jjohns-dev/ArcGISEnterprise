---
document type: cmdlet
external help file: ArcGISEnterprise-Help.xml
HelpUri: ''
Locale: en-US
Module Name: ArcGISEnterprise
ms.date: 06/05/2026
PlatyPS schema version: 2024-05-01
title: Add-ServerUsageReport
---

# Add-ServerUsageReport

## SYNOPSIS

Creates a new usage report

## SYNTAX

### __cnnd (Default)

```
Add-ServerUsageReport -ReportName <string> -Since <string> -ResourceURI <string[]>
 -Metric <string[]> -Context <uri> -Token <string> [-Metadata <string>] [-AggregationInterval <int>]
 [-SkipCertificateCheck] [<CommonParameters>]
```

### __cstm

```
Add-ServerUsageReport -ReportName <string> -From <datetime> -To <datetime> -ResourceURI <string[]>
 -Metric <string[]> -Context <uri> -Token <string> [-Metadata <string>] [-AggregationInterval <int>]
 [-SkipCertificateCheck] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Add a new report to the usage reports in ArcGIS Server.

## EXAMPLES

### EXAMPLE 1

$reportParams = @{
    ReportName  = 'Make_Me_Cry'
    Since       = 'LAST_DAY'
    ResourceURI = 'services/Hosted/make_me_cry.FeatureServer'
    Metric      = @('RequestCount', 'RequestsFailed', 'RequestsTimedOut', 'RequestAvgResponseTime', 'RequestMaxResponseTime')
    Metadata    = 'Usage report for "Make_Me_Cry" service'
}
PS C:\> Add-ServerUsageReport @commonParams @reportParams
Creates a new usage report for the 'Make_Me_Cry' service.

### EXAMPLE 2

$reportParams = @{
    ReportName          = 'Make_Me_Cry'
    From                = Get-Date -Date '2024-12-11'
    To                  = Get-Date -Date '2025-02-04'
    AggregationInterval = 60
    ResourceURI         = 'services/Hosted/make_me_cry.FeatureServer'
    Metric              = @('RequestCount', 'RequestsFailed', 'RequestsTimedOut', 'RequestAvgResponseTime', 'RequestMaxResponseTime')
    Metadata            = 'Usage report for "Make_Me_Cry" service'
}
PS C:\> Add-ServerUsageReport @cmnParams @reportParams
Creates a new usage report for the 'Make_Me_Cry' service with 1 hour aggregation interval from Dec 11 to Feb 4.

## PARAMETERS

### -AggregationInterval

Aggregation interval in minutes

```yaml
Type: System.Int32
DefaultValue: 0
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
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -From

Start time

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: __cstm
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Metadata

Report metadata

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

### -Metric

Desired metric(s)

```yaml
Type: System.String[]
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

### -ReportName

Report name

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

### -ResourceURI

Resource URI(s)

```yaml
Type: System.String[]
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

### -Since

Report time frame

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: __cnnd
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

### -To

End time

```yaml
Type: System.DateTime
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: __cstm
  Position: Named
  IsRequired: true
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
https://developers.arcgis.com/rest/enterprise-administration/server/createusagereport/

## RELATED LINKS

{{ Fill in the related links here }}


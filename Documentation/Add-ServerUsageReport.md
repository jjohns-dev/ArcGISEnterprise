# Add-ServerUsageReport

## SYNOPSIS
Creates a new usage report

## SYNTAX

### __cnnd (Default)
```
Add-ServerUsageReport -ReportName <String> -Since <String> -ResourceURI <String[]> -Metric <String[]>
 [-Metadata <String>] [-AggregationInterval <Int32>] -Context <Uri> -Token <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

### __cstm
```
Add-ServerUsageReport -ReportName <String> -From <DateTime> -To <DateTime> -ResourceURI <String[]>
 -Metric <String[]> [-Metadata <String>] [-AggregationInterval <Int32>] -Context <Uri> -Token <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Add a new report to the usage reports in ArcGIS Server.

## EXAMPLES

### EXAMPLE 1
```
$reportParams = @{
    ReportName  = 'Make_Me_Cry'
    Since       = 'LAST_DAY'
    ResourceURI = 'services/Hosted/make_me_cry.FeatureServer'
    Metric      = @('RequestCount', 'RequestsFailed', 'RequestsTimedOut', 'RequestAvgResponseTime', 'RequestMaxResponseTime')
    Metadata    = 'Usage report for "Make_Me_Cry" service'
}
PS C:\> Add-ServerUsageReport @commonParams @reportParams
Creates a new usage report for the 'Make_Me_Cry' service.
```

### EXAMPLE 2
```
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
```

## PARAMETERS

### -ReportName
Report name

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

### -Since
Report time frame

```yaml
Type: String
Parameter Sets: __cnnd
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -From
Start time

```yaml
Type: DateTime
Parameter Sets: __cstm
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -To
End time

```yaml
Type: DateTime
Parameter Sets: __cstm
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceURI
Resource URI(s)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Metric
Desired metric(s)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Metadata
Report metadata

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AggregationInterval
Aggregation interval in minutes

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
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
Name:     Add-ServerUsageReport
Author:   Justin Johns
Version:  0.1.2 | Last Edit: 2025-02-06
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/server/createusagereport/

## RELATED LINKS

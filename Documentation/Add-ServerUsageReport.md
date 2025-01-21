# Add-ServerUsageReport

## SYNOPSIS
Creates a new usage report

## SYNTAX

```
Add-ServerUsageReport [-ReportName] <String> [-Since] <String> [-Dimension] <Object> [[-Metadata] <String>]
 [[-AggregationInterval] <Int32>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Add a new report to the usage reports in ArcGIS Server.

## EXAMPLES

### EXAMPLE 1
```
$dim = [PSCustomObject] @{
    resourceURIs = @('services/Hosted/make_me_cry.FeatureServer')
    metrics      = @('RequestCount', 'RequestsFailed', 'RequestsTimedOut', 'RequestAvgResponseTime', 'RequestMaxResponseTime')
}
PS C:\> Add-ServerUsageReport -ReportName 'Make_Me_Cry' -Since 'LAST_DAY' -Dimension $dim -Metadata 'Usage report for "Make_Me_Cry" service' @commonParams
The first command creates a dimension object for the report. The second command creates a new usage report for the 'Make_Me_Cry' service.
```

## PARAMETERS

### -ReportName
Report name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Since
Report time frame

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Dimension
Report dimension

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AggregationInterval
Aggregation interval

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 6
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
Position: 7
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
Version:  0.1.0 | Last Edit: 2025-01-17
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/server/createusagereport/

## RELATED LINKS

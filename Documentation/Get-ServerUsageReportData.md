# Get-ServerUsageReportData

## SYNOPSIS
Retrieves server usage data for the report.

## SYNTAX

```
Get-ServerUsageReportData [-ReportName] <String> [[-ReportFormat] <String>] [[-MachineName] <String[]>]
 [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
This operation aggregates and filters server usage statistics for the entire ArcGIS Server site.

## EXAMPLES

### EXAMPLE 1
```
Get-ServerUsageReportData -ReportName 'Make_Me_Cry' -ReportFormat CSV @commonParams
Retrieves the usage data for the 'Make_Me_Cry' report and returns it as CSV.
```

## PARAMETERS

### -ReportName
Name of the report to retrieve

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

### -ReportFormat
Report format

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Json
Accept pipeline input: False
Accept wildcard characters: False
```

### -MachineName
Machine name

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: *
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
Position: 4
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
Position: 5
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
Name:     Get-ServerUsageReportData
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2025-07-22
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/server/queryreportdata/

## RELATED LINKS

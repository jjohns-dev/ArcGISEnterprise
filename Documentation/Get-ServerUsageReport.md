# Get-ServerUsageReport

## SYNOPSIS
Get Server usage report

## SYNTAX

```
Get-ServerUsageReport [[-ReportName] <String>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Returns a Server usage report

## EXAMPLES

### EXAMPLE 1
```
Get-ServerUsageReport @cmnParams -ReportName 'Test'
Returns the 'Test' usage report.
```

### EXAMPLE 2
```
Get-ServerUsageReport @cmnParams
Returns all usage reports.
```

## PARAMETERS

### -ReportName
Name of the report to retrieve

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
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
Position: 2
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
Position: 3
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
Name:     Get-ServerUsageReport
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2025-07-22
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/server/usagereports/
https://developers.arcgis.com/rest/enterprise-administration/server/usagereport/

## RELATED LINKS

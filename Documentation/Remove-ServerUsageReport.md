# Remove-ServerUsageReport

## SYNOPSIS
Delete usage report

## SYNTAX

```
Remove-ServerUsageReport [-ReportName] <String> [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Permanently deletes the usage report.

## EXAMPLES

### EXAMPLE 1
```
Remove-ServerUsageReport @cmnParams -ReportName 'Test'
Deletes the 'Test' usage report.
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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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
Name:     Remove-ServerUsageReport
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-01-17
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/server/deleteusagereport/

## RELATED LINKS

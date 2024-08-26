# Get-PortalLog

## SYNOPSIS
Get Portal for ArcGIS logs

## SYNTAX

```
Get-PortalLog [[-Level] <String>] [[-StartTime] <DateTime>] [[-EndTime] <DateTime>] [[-Code] <String[]>]
 [[-UserName] <String[]>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get Portal for ArcGIS logs by using the logs query endpoint

## EXAMPLES

### EXAMPLE 1
```
Get-PortalLog @commonParams -EndTime (Get-Date).AddDays(-7)
Get all portal logs from the last 7 days
```

## PARAMETERS

### -Level
Returns only records with a log level at or more severe than the level specified

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: WARNING
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartTime
The most recent time to query

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndTime
The oldest time to include in the result set

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Code
Log code

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
Organization member usernames

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Name:     Get-PortalLog
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-08-23
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/portal/query-logs.htm

## RELATED LINKS

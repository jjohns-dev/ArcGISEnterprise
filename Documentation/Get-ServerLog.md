# Get-ServerLog

## SYNOPSIS
Get ArcGIS Server logs

## SYNTAX

```
Get-ServerLog [[-Level] <String>] [[-StartTime] <DateTime>] [[-EndTime] <DateTime>] [[-Code] <Int32[]>]
 [[-PageSize] <Int32>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get ArcGIS Server logs by using the logs query endpoint

## EXAMPLES

### EXAMPLE 1
```
Get-ServerLog @commonParams -Level 'SEVERE'
Get all server logs with a level of SEVERE
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
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Number of log entries in response

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 1000
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
Name:     Get-ServerLog @commonParams
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2025-01-22
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/server/logsquery.htm

## RELATED LINKS

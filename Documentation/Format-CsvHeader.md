# Format-CsvHeader

## SYNOPSIS
Clean CSV data headers

## SYNTAX

```
Format-CsvHeader [-Path] <String> [-KeepHeaders] [<CommonParameters>]
```

## DESCRIPTION
Cleans or sanitizes CSV data headers by converting to lowercase and replacing spaces with underscores

## EXAMPLES

### EXAMPLE 1
```
Format-CsvHeader -Path C:\temp\file.csv
Sanitizes headers and returns data as array of objects
```

## PARAMETERS

### -Path
CSV file path

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

### -KeepHeaders
Keep original headers

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
Name:     Format-CsvHeader
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-05-15
Comments: \<Comment(s)\>

## RELATED LINKS

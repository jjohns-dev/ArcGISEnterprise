# Set-GeoEventConnection

## SYNOPSIS
Set default GeoEvent connection parameters

## SYNTAX

```
Set-GeoEventConnection [-Context] <Uri> [-Token] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set default GeoEvent connection parameters for subsequent cmdlet calls.

## EXAMPLES

### EXAMPLE 1
```
Set-GeoEventConnection
Sets the default GeoEvent connection parameters for subsequent cmdlet calls.
```

## PARAMETERS

### -Context
GeoEvent context (e.g., https://arcgis.com/arcgis)

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token
Enterprise token

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

### None.
## NOTES
Name:     Set-GeoEventConnection
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-11-25
- Version history is captured in repository commit history
Comments:

## RELATED LINKS

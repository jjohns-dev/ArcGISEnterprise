# Set-ServerSystemProperty

## SYNOPSIS
Set the system properties of the ArcGIS Server.

## SYNTAX

```
Set-ServerSystemProperty [[-WebContextURL] <String>] [[-FeatureServiceXSSFilter] <String>] [-Context] <Uri>
 [-Token] <String> [-SkipCertificateCheck] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function sets the system properties of the server using the ArcGIS REST API.

## EXAMPLES

### EXAMPLE 1
```
Set-ServerSystemProperty @cmnParams -FeatureServiceXSSFilter 'input'
Set the Feature Service XSS filter to 'input'.
```

## PARAMETERS

### -WebContextURL
Web context URL (e.g., https://example.com/arcgis)

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

### -FeatureServiceXSSFilter
Feature service XSS filter (e.g., input, inputOutput)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
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
Position: 4
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
Name:     Set-ServerSystemProperty
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-04-15
- Version history is captured in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/server/updateserverproperties/

## RELATED LINKS

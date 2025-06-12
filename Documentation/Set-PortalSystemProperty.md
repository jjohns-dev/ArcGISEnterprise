# Set-PortalSystemProperty

## SYNOPSIS
Sets the system properties for Portal for ArcGIS.

## SYNTAX

```
Set-PortalSystemProperty [[-EnableRSS] <Boolean>] [[-EnableKML] <Boolean>] [[-EnablePrintService] <Boolean>]
 [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The update operation updates one or more system properties.
All previously modified system
properties must be included in the request.
Only the properties that have been updated or
added to the JSON object will be effected.

## EXAMPLES

### EXAMPLE 1
```
Set-PortalSystemProperty @cmnParams -EnablePrintService $false
Set the Enable Print Service property to false.
```

## PARAMETERS

### -EnableRSS
Enable/disable Enterprise to communicate with GeoRSS feeds

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableKML
Enable/disable Enterprise to communicate with the KML endpoint

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnablePrintService
Enable/disable default print service in ArcGIS Enterprise Portal

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
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
Name:     Set-PortalSystemProperty
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2025-06-12
- Version history is captured in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/portal/update-system-properties/

## RELATED LINKS

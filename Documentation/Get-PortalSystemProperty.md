# Get-PortalSystemProperty

## SYNOPSIS
Get the system properties of the ArcGIS Portal.

## SYNTAX

```
Get-PortalSystemProperty [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
The properties resource lists system properties that have been modified to control the
ArcGIS Enterprise portal environment.

## EXAMPLES

### EXAMPLE 1
```
Get-PortalSystemProperty
Returns the system properties of the ArcGIS Portal.
```

## PARAMETERS

### -Context
Server context (e.g., https://arcgis.com/arcgis)

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
Porta token

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
Name:     Get-PortalSystemProperty
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-04-23
- Version history is captured in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/portal/system-properties/

## RELATED LINKS

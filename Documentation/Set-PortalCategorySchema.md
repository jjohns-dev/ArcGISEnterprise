# Set-PortalCategorySchema

## SYNOPSIS
Write ArcGIS Portal category schema to Enterprise/organization

## SYNTAX

```
Set-PortalCategorySchema [-Schema] <Object> [[-PortalId] <String>] [-Context] <Uri> [-Token] <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Applies the content category schema to an organization

## EXAMPLES

### EXAMPLE 1
```
$schema = Get-PortalCategorySchema @cmnParams
PS C:\> Set-PortalCategorySchema @cmnParams -Schema $schema
Gets the content category schema for the organization and then sets the exact same schema again.
```

## PARAMETERS

### -Schema
Portal category schema

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PortalId
Portal application ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0123456789ABCDEF
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.Object.
## NOTES
Name:     Set-PortalCategorySchema
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-01-08
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/assign-category-schema/

## RELATED LINKS

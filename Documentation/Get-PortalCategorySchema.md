# Get-PortalCategorySchema

## SYNOPSIS
Get ArcGIS Portal category schema

## SYNTAX

```
Get-PortalCategorySchema [[-PortalId] <String>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Returns the content category schema for an organization

## EXAMPLES

### EXAMPLE 1
```
Get-PortalCategorySchema @cmnParams
Returns the content category schema for the organization
```

## PARAMETERS

### -PortalId
Portal application ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Name:     Get-PortalCategorySchema
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2025-07-22
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/category-schema/

## RELATED LINKS

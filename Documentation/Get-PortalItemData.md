# Get-PortalItemData

## SYNOPSIS
Get Portal item data

## SYNTAX

```
Get-PortalItemData [-ItemId] <String> [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get all data for a Portal item including layers and layer data

## EXAMPLES

### EXAMPLE 1
```
Get-PortalItemData -ItemId 'fdc51cd9e3ac4f4aa8444949caf5e816' @cmnParams
Returns all the item data including layers and laery data
```

## PARAMETERS

### -ItemId
Portal item ID

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.Object.
## NOTES
Name:     Get-PortalItemData
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-06-04
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/item-data/

## RELATED LINKS

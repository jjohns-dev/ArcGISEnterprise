# Find-ServerReverseGeocode

## SYNOPSIS
Reverse geocode a coordinate to an address.

## SYNTAX

```
Find-ServerReverseGeocode [-ServiceName] <String> [-Location] <Object> [-Context] <Uri> [-Token] <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
The reverseGeocode operation determines the address at a particular x,y location.

## EXAMPLES

### EXAMPLE 1
```
Find-ServerReverseGeocode @cmnParams -ServiceName 'MyGeoCoder' -Location ([pscustomobject] @{ x = -117.187592395203; y = 34.062863813743 })
Returns physical address for provided location coordinates
```

## PARAMETERS

### -ServiceName
Geocode Server Service Name

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

### -Location
The point from which to search for the closest address

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.Object.
## NOTES
Name:     Find-ServerReverseGeocode
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-01-23
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/geocode/reverse-geocode/

## RELATED LINKS

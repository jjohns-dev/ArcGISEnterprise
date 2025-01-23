# Find-ServerGeocodeAddress

## SYNOPSIS
GeoCode a list of locations

## SYNTAX

### __sl (Default)
```
Find-ServerGeocodeAddress -ServiceName <String> -SingleLine <String[]> -Context <Uri> -Token <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

### __ml
```
Find-ServerGeocodeAddress -ServiceName <String> -Address <Object[]> -Context <Uri> -Token <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Geocode an entire list of addresses in one request.
Geocoding many addresses at once is also known as batch or bulk geocoding.

## EXAMPLES

### EXAMPLE 1
```
Find-ServerGeocodeAddress @cmnParams -SingleLine '380 New York St, Redlands, CA 92373', '1600 Amphitheatre Pkwy, Mountain View, CA 94043'
Returns geocoded addresses with accuracy and location information
```

## PARAMETERS

### -ServiceName
Geocode Server Service Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SingleLine
Single-line location to be geocoded

```yaml
Type: String[]
Parameter Sets: __sl
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Address
Multi-line address object

```yaml
Type: Object[]
Parameter Sets: __ml
Aliases:

Required: True
Position: Named
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
Position: Named
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
Position: Named
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
Name:     Find-ServerGeocodeAddress
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-01-23
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/geocode/geocode-addresses/

## RELATED LINKS

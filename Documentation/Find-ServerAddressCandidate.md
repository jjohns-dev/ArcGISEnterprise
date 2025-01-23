# Find-ServerAddressCandidate

## SYNOPSIS
GeoCode a location

## SYNTAX

```
Find-ServerAddressCandidate [-ServiceName] <String> [[-FolderName] <String>] [-SingleLine] <String>
 [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Geocodes one location per request.
The input address can be combined into a single input field or divided among multiple parameters.

## EXAMPLES

### EXAMPLE 1
```
Find-ServerAddressCandidate @cmnParams -SingleLine '380 New York St, Redlands, CA 92373'
Returns geocoded address candidates
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

### -FolderName
Folder name in ArcGIS Server

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

### -SingleLine
Location to be geocoded

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.Object.
## NOTES
Name:     Find-ServerAddressCandidate
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-01-23
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/geocode/find-address-candidates/

## RELATED LINKS

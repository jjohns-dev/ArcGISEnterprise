# ConvertFrom-GeoJson

## SYNOPSIS
Convert GeoJSON to ArcGIS JSON

## SYNTAX

```
ConvertFrom-GeoJson [-GeoJson] <Object> [[-IDAttribute] <String>] [<CommonParameters>]
```

## DESCRIPTION
Convert GeoJSON to ArcGIS JSON

## EXAMPLES

### EXAMPLE 1
```
ConvertFrom-GeoJson -GeoJson (Get-Content -Path 'C:\temp\geojson.json' | ConvertFrom-Json)
Converts GeoJSON in a flat file to objects and then to ArcGIS JSON
```

### EXAMPLE 2
```
$geoJson = Invoke-RestMethod -Uri 'https://services.arcgis.com/arcgis/rest/services/Counties/FeatureServer/0/query?where=1%3D1&outFields=*&f=geojson'
PS C:\> ConvertFrom-GeoJson -GeoJson $geoJson
Converts GeoJSON from a REST endpoint to objects and then to ArcGIS JSON
```

## PARAMETERS

### -GeoJson
GeoJSON as an object

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

### -IDAttribute
ID attribute

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: OBJECTID
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
Name:     ConvertFrom-GeoJson
Author:   Justin Johns (original author linked below)
Version:  0.1.0 | Last Edit: 2025-02-20
- Version history is capture in repository commit history
Comments:
https://unpkg.com/@esri/arcgis-to-geojson-utils@1.2.0/dist/arcgis-to-geojson.js

## RELATED LINKS

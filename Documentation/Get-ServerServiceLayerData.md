# Get-ServerServiceLayerData

## SYNOPSIS
Find data in an ArcGIS Server service layer

## SYNTAX

```
Get-ServerServiceLayerData [-LayerId] <Int32> [-ServiceName] <String> [[-Where] <String>]
 [[-FolderName] <String>] [-Context] <Uri> [[-Token] <String>] [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Query an ArcGIS Server service layer for data.
This queries all data and returns all fields.

## EXAMPLES

### EXAMPLE 1
```
Get-ServerServiceLayerData @cmnParams -ServiceName 'Geology' -LayerId 0
Returns all data for the first layer of the 'Geology' service
```

## PARAMETERS

### -LayerId
Service Layer ID

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Layer

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceName
Name of service

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

### -Where
Where clause for the query filter

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Objectid >= 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FolderName
Folder name in ArcGIS Server

```yaml
Type: String
Parameter Sets: (All)
Aliases: Folder

Required: False
Position: 4
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
Position: 5
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

Required: False
Position: 6
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
Name:     Get-ServerServiceLayerData
Author:   Justin Johns
Version:  0.1.2 | Last Edit: 2025-03-20
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/services-reference/enterprise/query-feature-service-layer/

## RELATED LINKS

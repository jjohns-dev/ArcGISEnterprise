# Get-ServerServiceFieldReport

## SYNOPSIS
Get ArcGIS Server service field information

## SYNTAX

```
Get-ServerServiceFieldReport [[-FolderName] <String>] [-Context] <Uri> [[-Token] <String>]
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get ArcGIS Server service field information for fields belonging to services and service layers

## EXAMPLES

### EXAMPLE 1
```
Get-ServerServiceFieldReport -Context https://myServer.arcgis.com/arcgis -Folder Gas
Returns an array of fields with accompanying service and layer properties
```

### EXAMPLE 2
```
Get-ServerServiceFieldReport -Context https://myServer.arcgis.com/arcgis -Folder Gas, Traffic
Returns an array of fields with length for "esriFieldTypeString" types
```

## PARAMETERS

### -FolderName
Target folder

```yaml
Type: String
Parameter Sets: (All)
Aliases: Folder

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Context
Portal context (e.g., https://arcgis.com/arcgis)

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
Portal token

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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
Name:     Get-ServerServiceFieldReport
Author:   Justin Johns
Version:  0.1.4 | Last Edit: 2024-09-23
- Version history is capture in repository commit history
Comments: \<Comment(s)\>
- This function does not consider items in the root, meaning itesm that are not in one of the folders in ArcGIS Server.
- The function only supports the following service types: MapServer, ImageServer, FeatureServer

## RELATED LINKS

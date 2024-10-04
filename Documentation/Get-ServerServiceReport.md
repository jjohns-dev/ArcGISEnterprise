# Get-ServerServiceReport

## SYNOPSIS
Get ArcGIS Server service and layer information

## SYNTAX

### __svc (Default)
```
Get-ServerServiceReport [-FolderName <String>] -Context <Uri> [-Token <String>] [-SkipCertificateCheck]
 [<CommonParameters>]
```

### __fdo
```
Get-ServerServiceReport [-FolderName <String>] [-OnlyFieldData] -Context <Uri> [-Token <String>]
 [-SkipCertificateCheck] [<CommonParameters>]
```

### __ifd
```
Get-ServerServiceReport [-FolderName <String>] [-IncludeFieldData] -Context <Uri> [-Token <String>]
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get ArcGIS Server service and layer information and output in report format

## EXAMPLES

### EXAMPLE 1
```
Get-ServerServiceReport -Context https://arcgis.com/arcgis -Folder Gas
Returns an object with arrays for service, layer, and attachment properties for content in the "Gas" folder
```

### EXAMPLE 2
```
Get-ServerServiceReport -Context https://arcgis.com/arcgis -IncludeFieldData
Returns an object with arrays for service, layer, attachment, and field properties
```

### EXAMPLE 3
```
Get-ServerServiceReport -Context https://arcgis.com/arcgis -OnlyFieldData
Returns an object with array for only field properties
```

## PARAMETERS

### -FolderName
Target folder

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeFieldData
Include service and layer field metadata

```yaml
Type: SwitchParameter
Parameter Sets: __ifd
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnlyFieldData
Return only service and layer field metadata

```yaml
Type: SwitchParameter
Parameter Sets: __fdo
Aliases:

Required: False
Position: Named
Default value: False
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
Position: Named
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
Name:     Get-ServerServiceReport
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2024-10-04
- Version history is capture in repository commit history
Comments: \<Comment(s)\>
- This function does not consider items in the root, meaning itesm that are not in one of the folders in ArcGIS Server.
- The function only supports the following service types: MapServer, ImageServer, FeatureServer

## RELATED LINKS

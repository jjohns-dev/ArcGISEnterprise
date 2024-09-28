# Get-ServerServiceReport

## SYNOPSIS
Get ArcGIS Server service and layer information

## SYNTAX

```
Get-ServerServiceReport [[-FolderName] <String>] [-Context] <Uri> [[-Token] <String>] [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get ArcGIS Server service and layer information and output in report format

## EXAMPLES

### EXAMPLE 1
```
Get-ServerServiceReport -Context https://myServer.arcgis.com/arcgis -Folder Gas
Returns an array of fields metadata for service and layer properties
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
Name:     Get-ServerServiceReport
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-09-28
- Version history is capture in repository commit history
Comments: \<Comment(s)\>
- This function does not consider items in the root, meaning itesm that are not in one of the folders in ArcGIS Server.
- The function only supports the following service types: MapServer, ImageServer, FeatureServer

## RELATED LINKS

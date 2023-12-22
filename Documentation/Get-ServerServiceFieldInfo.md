# Get-ServerServiceFieldInfo

## SYNOPSIS
Get ArcGIS Server service filed information

## SYNTAX

```
Get-ServerServiceFieldInfo -Context <Uri> -Folder <String[]> [-FieldTypeStringOnly] [-FieldLength <Int32>]
 [-Token <String>] [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get ArcGIS Server service filed information for "esriFieldTypeString" longer than a given threshold

## EXAMPLES

### EXAMPLE 1
```
Get-ServerServiceFieldInfo -Context https://myServer.arcgis.com/arcgis -Folder Gas
Returns an array of fields with accompanying service and layer properties
```

### EXAMPLE 2
```
Get-ServerServiceFieldInfo -Context https://myServer.arcgis.com/arcgis -Folder Gas, Traffic -FieldTypeStringOnly
Returns an array of "esriFieldTypeString" fields with length larger than 254 characters
```

## PARAMETERS

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

### -Folder
Get folder(s)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FieldTypeStringOnly
Only return "esriFieldTypeString" with a specifid FieldLength

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

### -FieldLength
Field length threshold (default is greater than 254)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 254
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
Name:     Get-ServerServiceFieldInfo
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2023-12-20
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
- This function does not consider items in the root, meaning itesm that are not in one of the folders in ArcGIS Server.
- The function only supports the following service types: MapServer, ImageServer, FeatureServer

## RELATED LINKS

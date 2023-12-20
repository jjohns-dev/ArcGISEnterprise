# Get-ServerServiceFieldInfo

## SYNOPSIS
Get ArcGIS Server service filed information

## SYNTAX

### _fldr (Default)
```
Get-ServerServiceFieldInfo -Context <Uri> -Folder <String[]> [-Token <String>] [-SkipCertificateCheck]
 [<CommonParameters>]
```

### _all
```
Get-ServerServiceFieldInfo -Context <Uri> [-AllFolders] [-Token <String>] [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get ArcGIS Server service filed information for "esriFieldTypeString" longer than a given threshold

## EXAMPLES

### EXAMPLE 1
```
Get-ServerServiceFieldInfo
Explanation of what the example does
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
Parameter Sets: _fldr
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllFolders
Get all folders

```yaml
Type: SwitchParameter
Parameter Sets: _all
Aliases:

Required: True
Position: Named
Default value: False
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
Name:     Get-ServiceFieldInfo
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2023-12-20
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes

## RELATED LINKS

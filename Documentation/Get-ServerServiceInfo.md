# Get-ServerServiceInfo

## SYNOPSIS
Get ArcGIS Server service info

## SYNTAX

```
Get-ServerServiceInfo [-Context] <Uri> [[-Token] <String>] [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get ArcGIS Server service info including folder(s)

## EXAMPLES

### EXAMPLE 1
```
Get-ServerServiceInfo
Returns an service info including folders from ArcGIS Server
```

## PARAMETERS

### -Context
Portal context (e.g., https://arcgis.com/arcgis)

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
Position: 2
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

### System.String.
## NOTES
Name:     Get-ServerServiceInfo
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2023-12-20
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes

## RELATED LINKS

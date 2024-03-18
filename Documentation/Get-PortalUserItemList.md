# Get-PortalUserItemList

## SYNOPSIS
Get Portal for ArcGIS user item list

## SYNTAX

```
Get-PortalUserItemList [[-UserName] <String>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get all items owned by user in Portal for ArcGIS

## EXAMPLES

### EXAMPLE 1
```
Get-PortalUserItemList @commonParams -UserName 'jsmith'
Get all Portal items belonging to 'jsmith'
```

## PARAMETERS

### -UserName
Username

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

Required: True
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
Name:     Get-PortalUserItemList
Author:   Justin Johns
Version:  0.1.2 | Last Edit: 2024-03-15
- 0.1.2 - (2024-03-15) Made UserName parameter optional
- 0.1.1 - (2023-13-20) Added automatic retrieval of paged results
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/users-groups-and-items/search.htm

## RELATED LINKS

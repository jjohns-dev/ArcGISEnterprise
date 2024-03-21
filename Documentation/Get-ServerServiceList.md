# Get-ServerServiceList

## SYNOPSIS
Get ArcGIS Server service information

## SYNTAX

```
Get-ServerServiceList [[-FolderName] <String>] [-Admin] [-Context] <Uri> [[-Token] <String>]
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get ArcGIS Server service information including folder(s)

## EXAMPLES

### EXAMPLE 1
```
Get-ServerServiceList
Returns an service info including folders from ArcGIS Server
```

## PARAMETERS

### -FolderName
Target folder to retrieve service info

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

### -Admin
Use admin API endpoint

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

### System.String.
## NOTES
Name:     Get-ServerServiceList
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2024-03-21
- 0.1.1 - (2024-03-20) Changed name, added ability to get service information for services in specified folder
- 0.1.0 - (2023-12-20) Initial version
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/services-reference/enterprise/get-started-with-the-services-directory.htm (REST endpoint)
https://developers.arcgis.com/rest/enterprise-administration/server/services.htm (Admin endpoint)

## RELATED LINKS

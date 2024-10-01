# Get-ServerServiceLayer

## SYNOPSIS
Get ArcGIS Server service layer metadata

## SYNTAX

```
Get-ServerServiceLayer [-LayerId] <Int32> [-ServiceName] <String> [-ServiceType] <String>
 [[-FolderName] <String>] [-Context] <Uri> [[-Token] <String>] [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get ArcGIS Server service layer metadata

## EXAMPLES

### EXAMPLE 1
```
Get-ServerServiceLayer @cmnParams -Folder 'Energy' -ServiceName 'Geology' -ServiceType 'FeatureServer' -LayerId 0
Returns service layer metadata for the first layer of the 'Geology' FeatureServer in the 'Energy' folder
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

### -ServiceType
Type of service (e.g., FeatureServer or MapServer)

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
Name:     Get-ServerServiceLayer
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-09-30
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/services-reference/enterprise/get-started-with-the-services-directory/

## RELATED LINKS

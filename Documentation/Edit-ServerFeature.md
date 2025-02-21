# Edit-ServerFeature

## SYNOPSIS
Edit Feature Service

## SYNTAX

### _add (Default)
```
Edit-ServerFeature -Add <Object[]> -ServiceName <String> [-LayerId <Int32>] [-FolderName <String>]
 -Context <Uri> -Token <String> [-SkipCertificateCheck] [<CommonParameters>]
```

### _upd
```
Edit-ServerFeature -Update <Object[]> -ServiceName <String> [-LayerId <Int32>] [-FolderName <String>]
 -Context <Uri> -Token <String> [-SkipCertificateCheck] [<CommonParameters>]
```

### _doi
```
Edit-ServerFeature -DeleteObjectId <Int32[]> -ServiceName <String> [-LayerId <Int32>] [-FolderName <String>]
 -Context <Uri> -Token <String> [-SkipCertificateCheck] [<CommonParameters>]
```

### _dgi
```
Edit-ServerFeature -DeleteGlobalId <String[]> -ServiceName <String> [-LayerId <Int32>] [-FolderName <String>]
 -Context <Uri> -Token <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Edit Feature Service using the /applyEdits endpoint.
This allows for adding, updating, or deleting features.

## EXAMPLES

### EXAMPLE 1
```
$feature = @{ attributes = @{ countyname = 'Fairfax'; countyid = 596; us_county_fips = 59; stateid = 39; us_state_fips = 51; us_full_fips = 51059 } }
PS C:\> Edit-ServerFeature @cmnParams -Add $feature
Adds a new feature to the Feature Service
```

### EXAMPLE 2
```
$feature = @{ attributes = @{ PointName = 'test'; Field2 = 'test2' }; geometry = @{ x = -77.306373; y = 38.855747; spatialReference = @{ wkid = 4326 } } }
PS C:\> Edit-ServerFeature @cmnParams -Add $feature
Adds a new feature with geometry to the Feature Service
```

### EXAMPLE 3
```
Edit-ServerFeature @cmnParams -DeleteObjectId @(1, 2, 3)
Deletes features with IDs 1, 2, and 3
```

## PARAMETERS

### -Add
Feature to add to the Feature Service

```yaml
Type: Object[]
Parameter Sets: _add
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Update
Feature to update

```yaml
Type: Object[]
Parameter Sets: _upd
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeleteObjectId
ObjectId of feature to delete

```yaml
Type: Int32[]
Parameter Sets: _doi
Aliases: Delete

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeleteGlobalId
GlobalId of feature to delete

```yaml
Type: String[]
Parameter Sets: _dgi
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceName
Portal Hosted Feature Service Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LayerId
Service Layer ID

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Layer

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FolderName
Server Service Folder Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Hosted
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

Required: True
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
Name:     Edit-ServerFeature
Author:   Justin Johns
Version:  0.2.0 | Last Edit: 2025-02-19
- See commit history for version changes
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/services-reference/enterprise/apply-edits-feature-service-layer-.htm

## RELATED LINKS

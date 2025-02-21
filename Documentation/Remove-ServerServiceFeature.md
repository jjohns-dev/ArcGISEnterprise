# Remove-ServerServiceFeature

## SYNOPSIS
Remove ArcGIS Server Feature Service feature

## SYNTAX

```
Remove-ServerServiceFeature [-ServiceName] <String> [-LayerId] <Int32> [[-ObjectId] <Int32[]>]
 [[-Where] <String>] [[-FolderName] <String>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This operation deletes features in a feature layer or table.
The operation is performed on a feature service layer resource.
If no object IDs or where clause is provided, all features in the layer or table will be deleted.

## EXAMPLES

### EXAMPLE 1
```
Remove-ServerServiceFeature @commonParams -ServiceName dashboard -LayerId 0
Delete all data from the "dashboard" Hosted Feature Service layer ID 0
```

### EXAMPLE 2
```
Remove-ServerServiceFeature @commonParams -ServiceName dashboard -LayerId 0 -ObjectId @(1, 2, 3)
Delete features with IDs 1, 2, and 3 from the "dashboard" Hosted Feature Service layer ID 0
```

## PARAMETERS

### -ServiceName
Portal Hosted Feature Service Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ObjectId
Object IDs of the layer or table to be deleted

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Where
Where clause for the query filter

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Objectid >= 0
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
Position: 5
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
Position: 6
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
Position: 7
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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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
Name:     Remove-ServerServiceFeature
Author:   Justin Johns
Version:  0.2.0 | Last Edit: 2025-02-21
- see commit history for version changes
Comments: \<Comment(s)\>
- https://developers.arcgis.com/rest/services-reference/enterprise/delete-features/

## RELATED LINKS

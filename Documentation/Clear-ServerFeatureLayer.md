# Clear-ServerFeatureLayer

## SYNOPSIS
Truncate Feature Service Layer features and attachments.

## SYNTAX

```
Clear-ServerFeatureLayer [-ServiceName] <String> [-LayerId] <Int32> [[-FolderName] <String>] [-Context] <Uri>
 [-Token] <String> [-SkipCertificateCheck] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The truncate operation supports deleting all features or attachments in a hosted feature service layer.

## EXAMPLES

### EXAMPLE 1
```
Clear-ServerFeatureLayer @cmnParams -ServiceName myCoolService -LayerId 0 -FolderName Hosted
Truncates all features and attachments in the service layer.
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
Aliases:

Required: True
Position: 2
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
Position: 3
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
Position: 4
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

Required: True
Position: 5
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
Name:     Clear-ServerFeatureLayer
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-03-06
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/services-reference/enterprise/fs-truncate/

We have discovered through testing that if the hosted feature service is
renamed, the new name is only updated in Portal, not ArcGIS Server.
Therefore, the "ServiceName" parameter should be the original name of the
service, not the current name.

## RELATED LINKS

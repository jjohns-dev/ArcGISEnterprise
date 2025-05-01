# Remove-PortalUserFolder

## SYNOPSIS
Delete a folder from a Portal user

## SYNTAX

```
Remove-PortalUserFolder [[-UserName] <String>] [-FolderID] <String> [-Context] <Uri> [-Token] <String>
 [-SkipCertificateCheck] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The delete user folder operation is available only on the user's non-root folders.
The user's root folder cannot be deleted.
Deleting a folder also deletes all items
that it contains (both the items and the links).

## EXAMPLES

### EXAMPLE 1
```
Remove-PortalUserFolder @cmnParams -UserName 'jsmith' -FolderID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6'
Deletes the folder with ID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6' from the user 'jsmith'
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

### -FolderID
Folder ID of Portal user folder to be deleted

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

### -Context
Server context (e.g., https://arcgis.com/arcgis)

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
Position: 4
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
Name:     Remove-PortalUserFolder
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-05-01
- Version history is captured in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/delete-folder/

## RELATED LINKS

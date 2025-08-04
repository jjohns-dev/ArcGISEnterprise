# Set-PortalItemOwner

## SYNOPSIS
Change ownership of a portal item

## SYNTAX

```
Set-PortalItemOwner [-ItemId] <String[]> [-UserName] <String> [-TargetUserName] <String>
 [[-TargetFolderName] <String>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The reassignItems operation reassigns items owned by one user to another user in the organization.
Before performing this operation, it is recommended that you first determine whether the user is eligible to receive content.
Item owners must have the portal:user:reassignItems privilege assigned to them to transfer content to another user.
Users assigned the default administrator role, or users assigned a custom administrative role that includes the
portal:user:reassignItems privilege, can also perform this operation on behalf of the item owner.

## EXAMPLES

### EXAMPLE 1
```
Set-PortalItemOwner @cmnParams -ItemId 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6' -UserName 'jsmith' -TargetUserName 'jdoe'
Changes ownership of the item with ID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6' from user 'jsmith' to user 'jdoe'.
```

## PARAMETERS

### -ItemId
Portal item ID

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UserName
Username of current item owner

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

### -TargetUserName
Username of new item owner

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

### -TargetFolderName
Name of the folder to move the item to (default to new folder with date).
Use '/' for root folder.
Creates new folder if it does not exist.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

Required: True
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

### System.String.
## OUTPUTS

### System.Object.
## NOTES
Name:     Set-PortalItemOwner
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-08-01
- Version history is captured in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/reassign-items/
(old) https://developers.arcgis.com/rest/users-groups-and-items/reassign-item/

## RELATED LINKS

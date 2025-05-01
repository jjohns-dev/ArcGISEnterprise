# Set-PortalGroupOwner

## SYNOPSIS
Reassign a Portal group to another user

## SYNTAX

```
Set-PortalGroupOwner [-GroupID] <String> [-UserName] <String> [-Context] <Uri> [-Token] <String>
 [-SkipCertificateCheck] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Reassign Group operation (POST only) allows the administrator of an organization to reassign a
group to another member of the organization.

## EXAMPLES

### EXAMPLE 1
```
Set-PortalGroupOwner @cmnParams -GroupID '12345678901234567890123456789012' -UserName 'jsmith'
Reassign the group with ID '12345678901234567890123456789012' to the user 'jsmith'.
```

## PARAMETERS

### -GroupID
Portal Group ID

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

### -UserName
Portal username of new owner

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
Name:     Set-PortalGroupOwner
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-04-28
- Version history is captured in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/reassign-group/

## RELATED LINKS

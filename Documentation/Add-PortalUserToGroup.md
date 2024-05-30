# Add-PortalUserToGroup

## SYNOPSIS
Add Portal group member

## SYNTAX

```
Add-PortalUserToGroup [-GroupID] <String> [[-UserName] <String[]>] [[-AdminName] <String[]>] [-Context] <Uri>
 [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Add member and/or manager to Portal group

## EXAMPLES

### EXAMPLE 1
```
Add-PortalUserToGroup -GroupId $gid -UserName 'jsmith', 'jdoe' -AdminName 'jdoe' @commonParams
Adds users 'jsmith' and 'jdoe' as members of the group and adds 'jdoe' as a group manager
```

## PARAMETERS

### -GroupID
Group ID

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
Username of group member

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdminName
Username of group manager

```yaml
Type: String[]
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.Object.
## NOTES
Name:     Add-PortalUserToGroup
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-05-28
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/add-users-to-group/

## RELATED LINKS

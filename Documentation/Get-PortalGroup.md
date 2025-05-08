# Get-PortalGroup

## SYNOPSIS
Get Portal for ArcGIS group information.

## SYNTAX

```
Get-PortalGroup [-GroupID] <String> [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
An individual group resource represents a group within the organization.
The group owner is automatically an administrator and is returned in the list
of administrators.
Administrators can invite, add to, or remove members from
a group as well as update or delete the group.
The administrator for an
organization can also reassign the group to another member of the organization.

## EXAMPLES

### EXAMPLE 1
```
Get-PortalGroup @cmnParams -GroupID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6'
Returns the group information for the group with ID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6' from Portal for ArcGIS.
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

### -Context
Server context (e.g., https://arcgis.com/arcgis)

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
Porta token

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
Name:     Get-PortalGroup
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-05-08
- Version history is captured in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/group/

## RELATED LINKS

# Get-PortalGroupContent

## SYNOPSIS
Get group content for Portal for ArcGIS group

## SYNTAX

```
Get-PortalGroupContent [-GroupId] <String> [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
A group's content resource provides access to the group's shared items.
Group items are stored by reference
and are not physically stored in a group.
Rather, they are stored as links to the original item in the Item
resource.
This resource is only available to the group owner and users.

## EXAMPLES

### EXAMPLE 1
```
Get-PortalGroupContent @cmnParams -GroupId 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6'
Gets the content for the group with ID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6' from Portal for ArcGIS
```

## PARAMETERS

### -GroupId
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
Name:     Get-PortalGroupContent
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-05-02
- Version history is captured in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/group-content/
https://developers.arcgis.com/rest/users-groups-and-items/common-parameters/#paging-parameters

## RELATED LINKS

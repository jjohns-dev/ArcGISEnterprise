# New-PortalUserGroup

## SYNOPSIS
Create new Portal user group

## SYNTAX

```
New-PortalUserGroup [-Title] <String> [[-Access] <String>] [[-Description] <String>] [[-Snippet] <String>]
 [[-Tag] <String[]>] [[-SortField] <String>] [[-SortOrder] <String>] [-IsViewOnly]
 [[-IsInvitationOnly] <Boolean>] [[-Capability] <String[]>] [-LeavingDisallowed] [-HiddenMembers]
 [[-MembershipAccess] <String>] [[-TypeKeyword] <String[]>] [[-Phone] <String>] [[-Thumbnail] <String>]
 [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Create new Portal user group

## EXAMPLES

### EXAMPLE 1
```
New-PortalUserGroup
Creates a new folder named 'my_test_folder' in ArcGIS Server
```

## PARAMETERS

### -Title
Group title or name

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

### -Access
Group access level

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Private
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Group description

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

### -Snippet
Group snippet or summary

```yaml
Type: String
Parameter Sets: (All)
Aliases: Summary

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag
Group tag

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortField
Group sort field

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

### -SortOrder
Group sort order

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsViewOnly
Set group to view only

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

### -IsInvitationOnly
Set group to invitation only

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Capability
Group capability

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LeavingDisallowed
Set leaving to disallowed

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

### -HiddenMembers
Set members to hidden (applies only to ArcGIS Online organizations)

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

### -MembershipAccess
Group membership access

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeKeyword
Type keyword

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Phone
Group contact information (limit 50 characters)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Thumbnail
Path to the thumbnail image to be used for the group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
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
Position: 14
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
Position: 15
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
Name:     New-PortalUserGroup
Author:   Justin Johns
Version:  0.1.2 | Last Edit: 2025-05-01
- Version history is captured in repository commit history
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/users-groups-and-items/create-group.htm
https://developers.arcgis.com/rest/users-groups-and-items/common-parameters/#group-parameters

## RELATED LINKS

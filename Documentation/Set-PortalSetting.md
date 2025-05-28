# Update-PortalOrganizationInformation

## SYNOPSIS
Set Portal setting.

## SYNTAX

```
Update-PortalOrganizationInformation [[-DisableEditing] <Boolean>] [[-MaxTokenExpiration] <Int32>] [[-Origin] <String[]>]
 [[-SharePublicly] <Boolean>] [[-PortalId] <String>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set or configure setting in Portal for ArcGIS sharing REST API.

## EXAMPLES

### EXAMPLE 1
```
Update-PortalOrganizationInformation @cmnParams -MaxTokenExpiration 1440
Set the maximum validity in minutes of both OAuth and nonOAuth tokens issued for users of the organization to 1440 minutes (24 hours).
```

### EXAMPLE 2
```
Update-PortalOrganizationInformation @cmnParams -Origin 'https://arcgis.com', 'https://test.com'
Sets the allowed origins property to 'https://arcgis.com,https://test.com'
```

### EXAMPLE 3
```
Update-PortalOrganizationInformation @cmnParams -SharePublicly $false
Disables the public sharing of Portal content
```

### EXAMPLE 4
```
Update-PortalOrganizationInformation @cmnParams -DisableEditing $true
Disables Portal User Profile editing
```

## PARAMETERS

### -DisableEditing
Disable Portal User Profile Editing

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxTokenExpiration
The maximum validity in minutes of both OAuth and nonOAuth tokens issued for users of the organization.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Origin
Origin to be allowed for Portal

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

### -SharePublicly
Share objects publicly

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PortalId
Portal application ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0123456789ABCDEF
Accept pipeline input: False
Accept wildcard characters: False
```

### -Context
Target Portal context

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
Name:     Update-PortalOrganizationInformation
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-05-27
- Version history is captured in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/update.htm
This function replaced functionality from the following old, deprecated functions:
- Set-PortalMaxTokenExpiration
- Set-PortalAllowedOrigins
- Set-PortalPublicSharing
- Set-PortalUserProfileEditing

## RELATED LINKS

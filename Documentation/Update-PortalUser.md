# Update-PortalUser

## SYNOPSIS
Update Portal user

## SYNTAX

```
Update-PortalUser [-UserName] <String> [[-IDPUserName] <String>] [[-Password] <SecureString>]
 [[-FirstName] <String>] [[-LastName] <String>] [[-FullName] <String>] [[-Email] <String>] [-Context] <Uri>
 [-Token] <String> [-SkipCertificateCheck] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Modify properties of Portal user (i.e., IDP type, name, email, etc.)

## EXAMPLES

### EXAMPLE 1
```
Update-PortalUser -UserName joedoe -IDPUserName 'joedoe@esri.com' @commonParams
Add the idpUsername property to enable the user for SAML authentication
```

### EXAMPLE 2
```
Update-PortalUser -Username joedoe -Password (Read-Host -AsSecureString) @commonParams
Set a password for use joedoe. This also switches the user "provier" from enterprise to arcgis removing SAML authentication
```

### EXAMPLE 3
```
Update-PortalUser -UserName joedoe -IDPUserName 'joedoe123@esri.com' @commonParams
PS C:\> Update-PortalUser -UserName joedoe -IDPUserName 'joedoe@esri.com' @commonParams
Once the user's provider value has been set to "enterprise" and then reset to "arcgis," the only way
to change it back to "enterprise" is to change the "idpUsername" value to something
arbitrary and then change it again to the correct value. This resets the "provider" property
to "enterprise."
```

## PARAMETERS

### -UserName
Username

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

### -IDPUserName
IDP Username

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
Password (for built-in users only)

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstName
First name

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

### -LastName
Last name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FullName
Full name

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

### -Email
Email address

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

### -Context
Server context (e.g., https://arcgis.com/arcgis)

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
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
Position: 9
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
Name:     Update-PortalUser
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-05-30
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/update-user/
https://developers.arcgis.com/rest/users-groups-and-items/common-parameters/#user-parameters

## RELATED LINKS

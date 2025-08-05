# New-PortalUser

## SYNOPSIS
Create new user

## SYNTAX

### _bltn (Default)
```
New-PortalUser -UserName <String> [-FirstName <String>] [-LastName <String>] -Email <String> [-Role <String>]
 -UserType <String> -Password <SecureString> [-Description <String>] -Context <Uri> -Token <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

### _oidc
```
New-PortalUser -UserName <String> [-FirstName <String>] [-LastName <String>] -Email <String> [-Role <String>]
 -UserType <String> -IDPUserName <String> -Provider <String> [-Description <String>] -Context <Uri>
 -Token <String> [-SkipCertificateCheck] [<CommonParameters>]
```

### _saml
```
New-PortalUser -UserName <String> [-FirstName <String>] [-LastName <String>] -Email <String> [-Role <String>]
 -UserType <String> -IDPUserName <String> [-Description <String>] -Context <Uri> -Token <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Create new Portal user

## EXAMPLES

### EXAMPLE 1
```
New-PortalUser -UserName joedoe -FirstName Joe -LastName Doe -Email joedoe@domain.com -UserType viewerUT -Password (Read-Host -AsSecureString)
Creates a new user with username joedoe
```

### EXAMPLE 2
```
$oidc = Get-PortalOIDCList @cmnParams
PS C:\> New-PortalUser -UserName joedoe -FirstName Joe -LastName Doe -Email joedoe@domain.com -IDPUserName joedoe -Provider $oidc[0].id @cmnParams
Creates a new user with username joedoe using OIDC authentication from the first OIDC provider in the list
```

## PARAMETERS

### -UserName
Username

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
Email

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Role
User Role

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Org_user
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserType
User type name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
Password

```yaml
Type: SecureString
Parameter Sets: _bltn
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IDPUserName
IDP Username

```yaml
Type: String
Parameter Sets: _oidc, _saml
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Provider
IDP Provider (e.g., oidc-\<provider_id\> for OIDC)

```yaml
Type: String
Parameter Sets: _oidc
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Position: Named
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
Position: Named
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
Name:     New-PortalUser
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2024-06-12
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/portal/create-user/
https://community.esri.com/t5/arcgis-rest-apis-and-services-questions/invalid-token-for-portaladmin-security-users/td-p/303096
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods

## RELATED LINKS

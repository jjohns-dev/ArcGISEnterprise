# Add-PortalOAuthRedirectURI

## SYNOPSIS
Add redirect URI to Portal OAuth app

## SYNTAX

```
Add-PortalOAuthRedirectURI [[-AppID] <String>] [-RedirectURI] <Uri> [-Context] <Uri> [-Token] <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Add redirect URI to Portal OAuth app

## EXAMPLES

### EXAMPLE 1
```
Add-PortalOAuthRedirectURI @commonParams -RedirectURI 'https://mydomain.internal.com'
Addes the new redirect URI to the app 'arcgisonline'
```

## PARAMETERS

### -AppID
AppID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Arcgisonline
Accept pipeline input: False
Accept wildcard characters: False
```

### -RedirectURI
Redirect URI

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

### -Context
Portal context (e.g., https://arcgis.com/arcgis)

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
Portal token

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.Object.
## NOTES
Name:     Add-PortalOAuthRedirectURI
Author:   Phillip Glodowski, Justin Johns
Version:  0.1.0 | Last Edit: 2023-03-14
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes
https://developers.arcgis.com/rest/enterprise-administration/portal/update-app-info.htm

## RELATED LINKS

# Get-PortalOAuthAppInfo

## SYNOPSIS
Get OAuth App Info

## SYNTAX

```
Get-PortalOAuthAppInfo [[-AppID] <String>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get OAuth App Info

## EXAMPLES

### EXAMPLE 1
```
Get-PortalOAuthAppInfo @commonParams
Gets the information associated with the app 'arcgisonline'
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

### -Context
Portal context (e.g., https://arcgis.com/arcgis)

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
Portal token

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
Name:     Get-PortalOAuthAppInfo
Author:   Justin Johns, Phillip Glodowski
Version:  0.1.0 | Last Edit: 2023-03-14
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes
https://developers.arcgis.com/rest/enterprise-administration/portal/get-app-info.htm

## RELATED LINKS

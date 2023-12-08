# Get-PortalDefaultUserSettings

## SYNOPSIS
Get default user settings from Portal

## SYNTAX

```
Get-PortalDefaultUserSettings [[-PortalId] <String>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get default user settings from Portal

## EXAMPLES

### EXAMPLE 1
```
Get-PortalDefaultUserSettings @cParams
Get the default user settings from Portal
```

## PARAMETERS

### -PortalId
Portal ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0123456789ABCDEF
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
Name:     Get-PortalDefaultUserSettings
Author:   Phillip Glodowski, Justin Johns
Version:  0.1.0 | Last Edit: 2023-11-06
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes
https://developers.arcgis.com/rest/users-groups-and-items/user-default-settings.htm

## RELATED LINKS

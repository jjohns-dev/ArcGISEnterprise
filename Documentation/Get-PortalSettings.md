# Get-PortalSettings

## SYNOPSIS
Get Portal configuration or "self"

## SYNTAX

```
Get-PortalSettings [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get Portal configuration or "self." This may also be a good test of
Portal token validity

## EXAMPLES

### EXAMPLE 1
```
Get-PortalSettings -Context 'https://arcgis.com/arcgis' -Token $token
Gets Portal "self" configuration
```

## PARAMETERS

### -Context
Target Portal context

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
Position: 2
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
Name:     Get-PortalSettings
Author:   Phillip Glodowski, Justin Johns
Version:  0.3.0 | Last Edit: 2023-11-07
- 0.3.0 - Renamed to Get-PortalSettings
- 0.2.0 - Renamed to Get-PortalSelf
- 0.1.0 - Initial version (Test-PortalToken)
Comments: \<Comment(s)\>
General notes
https://developers.arcgis.com/rest/users-groups-and-items/portal.htm

## RELATED LINKS

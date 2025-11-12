# Get-PortalLivingAtlasUpdate

## SYNOPSIS
Get Portal Living Atlas Catalog updates

## SYNTAX

```
Get-PortalLivingAtlasUpdate [[-PortalId] <String>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get Portal Living Atlas Catalog updates

## EXAMPLES

### EXAMPLE 1
```
Get-PortalLivingAtlasUpdate @commonParams
Returns a list of previously installed, as well as currently available
for installation, ArcGIS Living Atlas content packages.
```

## PARAMETERS

### -PortalId
Portal application ID

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
Name:     Get-PortalLivingAtlasUpdate
Author:   Brandon Trampf
Version:  0.1.0 | Last Edit: 2025-11-12
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/check-for-updates/

## RELATED LINKS

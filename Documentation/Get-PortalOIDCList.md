# Get-PortalOIDCList

## SYNOPSIS
Get OpenID Connect configurations from Portal for ArcGIS.

## SYNTAX

```
Get-PortalOIDCList [[-PortalId] <String>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves the OpenID Connect configurations from the Portal for ArcGIS sharing REST API.

## EXAMPLES

### EXAMPLE 1
```
Get-PortalOIDCList @cmnParams
Retrieves the OpenID Connect configurations from the Portal for ArcGIS.
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
Name:     Get-PortalOIDCList
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-07-21
- Version history is captured in repository commit history
Comments:
\<Link_To_API_Documentation\>

## RELATED LINKS

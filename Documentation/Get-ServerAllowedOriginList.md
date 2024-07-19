# Get-ServerAllowedOriginList

## SYNOPSIS

## SYNTAX

```
Get-ServerAllowedOriginList [-SOAP] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get the allowed origins for ArcGIS Server

## EXAMPLES

### EXAMPLE 1
```
$params = @{ Context = 'https://arcgis.com/arcgis'; Token = $token }
PS C:\> Get-ServerAllowedOriginList @params
Gets the allowed origins for ArcGIS Server
```

## PARAMETERS

### -SOAP
Get SOAP Allowed Origins

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

### -Context
Portal context (e.g., https://arcgis.com/arcgis)

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

### System.String.
## NOTES
Name:     Get-ServerAllowedOriginList
Author:   Justin Johns
Version:  0.1.3 | Last Edit: 2024-07-18
- Version history is capture in repository commit history
Comments: \<Comment(s)\>
General notes

## RELATED LINKS

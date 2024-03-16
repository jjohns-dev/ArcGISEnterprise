# Get-ServerHostedFeatureService

## SYNOPSIS
Get Hosted Feature Service

## SYNTAX

```
Get-ServerHostedFeatureService [-ServiceName] <String> [-Context] <Uri> [-Token] <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get Hosted Feature Service from ArcGIS Server.
This will include layers and tables as well as schema details.

## EXAMPLES

### EXAMPLE 1
```
Get-ServerHostedFeatureService -Context 'https://arcgis.com/arcgis' -ServiceName myFeatureService
Returns the Feature Service with name 'myFeatureService'
```

## PARAMETERS

### -ServiceName
Portal Hosted Feature Service Name

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
Name:     Get-ServerHostedFeatureService
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-03-06
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/services-reference/enterprise/layer-feature-service-.htm

## RELATED LINKS

# Set-ServerAllowedOrigins

## SYNOPSIS
Set ArcGIS Server allowed origins

## SYNTAX

```
Set-ServerAllowedOrigins [-Context] <Uri> [-Origin] <String[]> [-SOAP] [-Token] <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Set ArcGIS Server allowed origins

## EXAMPLES

### EXAMPLE 1
```
Set-ServerAllowedOrigins -Origin 'https://test.com', 'https://mySite.com'
Sets ArcGIS Server allowed origins to 'https://test.com,https://mySite.com'
```

## PARAMETERS

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

### -Origin
Origin to be allowed for Portal

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SOAP
Set SOAP handler allowed origins

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
Name:     Set-ServerAllowedOrigins
Author:   Justin Johns
Version:  0.1.4 | Last Edit: 2023-05-10
- 0.1.4 - Added switch parameter for SOAP handler
- 0.1.3 - Fixed issue with \[System.Uri\] adding trailing slash to Origin parameter
- 0.1.2 - Add validation to Origin parameter
- 0.1.1 - Updates to account for all server properties
- 0.1.0 - Initial version
General notes
https://developers.arcgis.com/rest/enterprise-administration/server/edit-soap-handler-config.htm

## RELATED LINKS

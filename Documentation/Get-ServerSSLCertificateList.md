# Get-ServerSSLCertificateList

## SYNOPSIS
Get a list of Server SSL certificates

## SYNTAX

```
Get-ServerSSLCertificateList [-Context] <Uri> [-Token] <String> [-Machine] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get a list of Server SSL certificates

## EXAMPLES

### EXAMPLE 1
```
Get-ServerSSLCertificateList -Machine 'myMachine.com' -Context 'https://arcgis.com/arcgis' -Token $token
Get a list of Server SSL certificates for the specified Server system
```

## PARAMETERS

### -Context
Server context (e.g., https://arcgis.com/arcgis)

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
Server token

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

### -Machine
Server system to test

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
General notes
https://developers.arcgis.com/rest/enterprise-administration/server/sslcertificates.htm

## RELATED LINKS

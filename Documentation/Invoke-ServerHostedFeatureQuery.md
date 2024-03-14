# Invoke-ServerHostedFeatureQuery

## SYNOPSIS
Invoke query against a Hosted Feature Service

## SYNTAX

```
Invoke-ServerHostedFeatureQuery [-ServiceName] <String> [[-LayerId] <Int32>] [[-Where] <String>]
 [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Invoke query against a Hosted Feature Service layer

## EXAMPLES

### EXAMPLE 1
```
Invoke-ServerHostedFeatureQuery -Where 'ObjectId=1001' -ServiceName MyService -layerId 0 @commonParams
Query MyServer LayerId 0 for a record with ObjectId 1001
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

### -LayerId
Service Layer ID

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Layer

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Where
Query where clause

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 1=1
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
Position: 4
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
Position: 5
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
Name:     Invoke-ServerHostedFeatureQuery
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-03-14
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/services-reference/enterprise/query-feature-service-layer-.htm

## RELATED LINKS

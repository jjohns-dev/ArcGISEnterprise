# New-ServerHostedFeatureTable

## SYNOPSIS
Create new Hosted Feature Serivce table

## SYNTAX

```
New-ServerHostedFeatureTable [-ServiceName] <String> [[-TableName] <String>] [-Field] <Object[]>
 [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Create new table "layer" in a Hosted Feature Serivce

## EXAMPLES

### EXAMPLE 1
```
New-ServerHostedFeatureTable -ServiceName myNewService -TableName 'DataTable' -Field $schema @commonParams
Creates a new table "layer" in a Hosted Feature Service with the name DataTable
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

### -TableName
Hosted Feature Service Table Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: DataTable
Accept pipeline input: False
Accept wildcard characters: False
```

### -Field
Table field (i.e., schema)

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases: Schema

Required: True
Position: 3
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
Name:     New-ServerHostedFeatureTable
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-03-16
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/services-reference/online/add-to-definition-feature-service-.htm

## RELATED LINKS

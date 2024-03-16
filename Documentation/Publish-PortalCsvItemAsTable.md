# Publish-PortalCsvItemAsTable

## SYNOPSIS
Publish a CSV file in Portal as a Hosted table

## SYNTAX

```
Publish-PortalCsvItemAsTable [-ItemName] <String> [-ItemId] <String> [-Field] <Object[]> [[-UserName] <String>]
 [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Publish a CSV file in Portal as a Hosted table.
This takes and existing CSV file
published to Portal and publishes it as a Hosted table.

## EXAMPLES

### EXAMPLE 1
```
Publish-PortalCsvItemAsTable -ItemName SalesData -ItemId $iid -Field $schema @commonParams
Uses the existing Portal item with ID $iid to publish a new Hosted table with name SalesData using the fields in $fields
```

## PARAMETERS

### -ItemName
Name of new Portal table

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

### -ItemId
Id of Portal item

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

### -Field
Table fields (i.e., schema)

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
Username

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 5
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
Position: 6
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
Name:     Publish-PortalCsvItemAsTable
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-03-15
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/users-groups-and-items/publish-item.htm
https://developers.arcgis.com/documentation/mapping-apis-and-services/data-hosting/tutorials/tools/import-data-to-create-a-table/

## RELATED LINKS

# Edit-ServerFeature

## SYNOPSIS
Edit Hoste Feature Service

## SYNTAX

### _adds (Default)
```
Edit-ServerFeature -Record <Object[]> -ServiceName <String> [-LayerId <Int32>] -Context <Uri>
 -Token <String> [-SkipCertificateCheck] [<CommonParameters>]
```

### _updates
```
Edit-ServerFeature -Update <Object[]> -ServiceName <String> [-LayerId <Int32>] -Context <Uri>
 -Token <String> [-SkipCertificateCheck] [<CommonParameters>]
```

### _deletes
```
Edit-ServerFeature -Delete <Int32[]> -ServiceName <String> [-LayerId <Int32>] -Context <Uri>
 -Token <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Edit Hoste Feature Service using the /applyEdits endpoint.
This allows for
adding, updating, or deleting records/features.

## EXAMPLES

### EXAMPLE 1
```
Edit-ServerFeature
Explanation of what the example does
```

## PARAMETERS

### -Record
Record or data to add to the Portal Hosted Feature Service

```yaml
Type: Object[]
Parameter Sets: _adds
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Update
Record/feature to update

```yaml
Type: Object[]
Parameter Sets: _updates
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Delete
ObjectId of record/feature to delete

```yaml
Type: Int32[]
Parameter Sets: _deletes
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceName
Portal Hosted Feature Service Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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
Position: Named
Default value: 0
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
Position: Named
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
Position: Named
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
Name:     Edit-ServerFeature
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2024-03-17
- 0.1.1 - Added formatting of record to freatures
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/services-reference/enterprise/apply-edits-feature-service-layer-.htm

## RELATED LINKS

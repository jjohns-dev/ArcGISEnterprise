# Add-PortalHostedFeatureRecord

## SYNOPSIS
Add record to Portal Hosted Feature Service

## SYNTAX

```
Add-PortalHostedFeatureRecord [-Record] <Object[]> [-ServiceName] <String> [[-Layer] <Int32>] [-Context] <Uri>
 [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Add records/data to a Portal Hosted Feature Service

## EXAMPLES

### EXAMPLE 1
```
Add-PortalHostedFeatureRecord @commonParams -Record $rec -ServiceName "dashboard"
Add records to a Hosted Feature Service named "dashboard"
```

## PARAMETERS

### -Record
Record or data to add to the Portal Hosted Feature Service

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Layer
Service Layer index

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Name:     Add-PortalHostedFeatureRecord
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2023-04-04
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes

## RELATED LINKS

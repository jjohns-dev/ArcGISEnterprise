# Clear-ServerHostedFeatureService

## SYNOPSIS
Clear Portal Hosted Feature Service

## SYNTAX

```
Clear-ServerHostedFeatureService [-ServiceName] <String> [-LayerId] <Int32> [-Context] <Uri> [-Token] <String>
 [-SkipCertificateCheck] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Clear or purge all items from a table in a Hosted Feature Service Layer

## EXAMPLES

### EXAMPLE 1
```
Clear-ServerHostedFeatureService @commonParams -ServiceName dashboard -LayerId 0
Clear or purge all data from the "dashboard" Hosted Feature Service layer ID 0
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

Required: True
Position: 2
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
Position: 3
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
Position: 4
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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
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
Name:     Clear-ServerHostedFeatureService
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2024-03-12
- 0.1.1 - Update function name and parameter name
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes

## RELATED LINKS

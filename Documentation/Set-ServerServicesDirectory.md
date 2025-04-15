# Set-ServerServicesDirectory

## SYNOPSIS
Set ArcGIS Server services directory

## SYNTAX

```
Set-ServerServicesDirectory [[-CallbackFunctionsEnabled] <Boolean>] [[-ServicesDirectoryEnabled] <Boolean>]
 [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set ArcGIS Server services directory configuration data

## EXAMPLES

### EXAMPLE 1
```
Set-ServerServicesDirectory @cmnParams -CallbackFunctionsEnabled $false
Set the Callback Functions enabled property to false.
```

## PARAMETERS

### -CallbackFunctionsEnabled
Callback functions enabled

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServicesDirectoryEnabled
Services directory enabled

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Context
Server context (e.g., https://arcgis.com/arcgis)

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
Porta token

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
Name:     Set-ServerServicesDirectory
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-04-15
- Version history is captured in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/server/handlersrestservicesdirectoryedit/

## RELATED LINKS

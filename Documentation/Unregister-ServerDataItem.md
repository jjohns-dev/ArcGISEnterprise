# Unregister-ServerDataItem

## SYNOPSIS
Unregister a data item

## SYNTAX

```
Unregister-ServerDataItem [-ItemPath] <String> [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Unregisters a data item that has been previously registered with the server's data store.

## EXAMPLES

### EXAMPLE 1
```
Unregister-ServerDataItem -ItemPath /nosqlDatabases/AGSDataStore_cache_cs_jbpc7nk
unregisters the DataSTore cache store data item registered with the Server's data store.
```

## PARAMETERS

### -ItemPath
The item path for the data item

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
Server context (e.g., https://arcgis.com/arcgis)

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
Enterprise token

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
Name:     Unregister-ServerDataItem
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-09-11
- Version history is captured in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/server/unregisterdataitem/

## RELATED LINKS

# Remove-ServerFolder

## SYNOPSIS
Removes folder in ArcGIS Server

## SYNTAX

```
Remove-ServerFolder [-FolderName] <String> [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes folder in ArcGIS Server and all servers within the folder

## EXAMPLES

### EXAMPLE 1
```
Remove-ServerFolder -FolderName 'my_test_folder' @commonParams
Removes ArcGIS Server folder named 'my_test_folder' and all services within the folder
```

## PARAMETERS

### -FolderName
ArcGIS Server folder name

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
Name:     Remove-ServerFolder
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2024-05-30
- Version history is capture in repository commit history
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/enterprise-administration/server/deletefolder.htm

## RELATED LINKS

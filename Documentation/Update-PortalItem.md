# Update-PortalItem

## SYNOPSIS
Update Portal item

## SYNTAX

```
Update-PortalItem [[-UserName] <String>] [-ItemId] <String> [[-Title] <Uri>] [[-Description] <Uri>]
 [[-URL] <Uri>] [[-PrivateURL] <Uri>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Allows users to update an item's information and file, URL, or text, depending on type.

## EXAMPLES

### EXAMPLE 1
```
Update-PortalItem -ItemId 'fdc51cd9e3ac4f4aa8444949caf5e816' -URL 'https://arcgis.com/arcgis/rest/services/Data_Owner_Connection_Layers/Util_CommSite_SpeclUse/MapServer' @cmnParams
Updates the URL property of item with ID 'fdc51cd9e3ac4f4aa8444949caf5e816'
```

## PARAMETERS

### -UserName
Owner of Portal Item

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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

### -Title
Item Title

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Item Description

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -URL
Item URL

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateURL
Item Private URL

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
Position: 7
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
Position: 8
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
Name:     Update-PortalItem
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-06-10
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/update-item/
https://developers.arcgis.com/javascript/latest/api-reference/esri-layers-Layer.html

## RELATED LINKS

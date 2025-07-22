# Get-PortalItemData

## SYNOPSIS
Get Portal item data

## SYNTAX

```
Get-PortalItemData [-ItemId] <String> [-AsFile] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get all data for a Portal item including layers and layer data.
This will also retrieve
a file item that has been uploaded to Portal and return it as a web request with the
content as the file data stream.

## EXAMPLES

### EXAMPLE 1
```
Get-PortalItemData @cmnParams -ItemId 'fdc51cd9e3ac4f4aa8444949caf5e816'
Returns all the item data including layers and laery data
```

### EXAMPLE 2
```
$itemData = Get-PortalItemData @cmnParams -ItemId 'aaaea82adc734de2a8af89e7a408576f' -AsFile
PS C:\> Set-Content -Path 'C:\temp\Group.epk' -Value $itemData.Content -AsByteStream
The first command returns a web request with content-type 'application/octet-stream' from the Portal item 'Group.epk'.
The second command writes the data stream to a file.
```

## PARAMETERS

### -ItemId
Portal item ID

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

### -AsFile
Request data as application/octet-stream

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
Porta token

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.Object.
## NOTES
Name:     Get-PortalItemData
Author:   Justin Johns
Version:  0.1.2 | Last Edit: 2025-07-22
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/item-data/

## RELATED LINKS

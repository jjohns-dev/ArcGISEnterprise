# Export-PortalGroupItem

## SYNOPSIS
Exports all exportable content from a Portal group.

## SYNTAX

```
Export-PortalGroupItem [-GroupID] <String> [-Synchronous] [-Context] <Uri> [-Token] <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Extracts all supported items, or a set of supported items, from a group and exports
them into an export package (.epk) that can be uploaded and imported into a separate
ArcGIS Enterprise organization.

## EXAMPLES

### EXAMPLE 1
```
Export-PortalGroupItem -GroupId 'ad46a0e1a74742aeb4314250c3ea90e4'
Starts and asynchronous job to export of all content from the group with ID 'ad46a0e1a74742aeb4314250c3ea90e4'
```

## PARAMETERS

### -GroupID
Portal Group ID

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

### -Synchronous
Execute job synchronously

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
Name:     Export-PortalGroupItem
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-01-14
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/export-group-content/

## RELATED LINKS

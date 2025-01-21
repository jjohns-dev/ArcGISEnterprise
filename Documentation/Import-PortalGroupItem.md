# Import-PortalGroupItem

## SYNOPSIS
THIS FUNCTION DOES NOT CURRENTLY WORK

## SYNTAX

```
Import-PortalGroupItem [-GroupID] <String> [-ItemId] <String> [-OverwriteExistingItems]
 [-KeepPackageAfterImport] [-Async] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Imports supported content items from an export package (generated using the export operation) into the selected group.

## EXAMPLES

### EXAMPLE 1
```
Import-PortalGroupItem -GroupId 'ad46a0e1a74742aeb4314250c3ea90e4' -ItemId '2b28061dc08d4834be808500ac2bd967' @commonParams
Starts a job to import of all content from item with ID '2b28061dc08d4834be808500ac2bd967' to group ID 'ad46a0e1a74742aeb4314250c3ea90e4'
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

### -ItemId
Portal item ID

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

### -OverwriteExistingItems
Overwrite existing items

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

### -KeepPackageAfterImport
Keep package after import

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

### -Async
Execute job asynchronously

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.Object.
## NOTES
Name:     Import-PortalGroupItem
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-01-15
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/import-group/

## RELATED LINKS

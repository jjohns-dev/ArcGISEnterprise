# Get-PortalItemGroupList

## SYNOPSIS
Get Portal item groups

## SYNTAX

```
Get-PortalItemGroupList [-ItemId] <String> [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get Portal user item groups

## EXAMPLES

### EXAMPLE 1
```
Get-PortalItemGroupList -ItemId 0e68d8058b744d1c95f709d2ae975232 @commonParams
Returns an array of Portal item groups based on membership type (admin, member, other)
for the item with ID 0e68d8058b744d1c95f709d2ae975232
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.Object.
## NOTES
Name:     Get-PortalItemGroupList
Author:   Brandon Trampf
Version:  0.1.0 | Last Edit: 2025-08-06
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/groups.htm

## RELATED LINKS

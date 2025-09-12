# Find-ServerDataItem

## SYNOPSIS
Find data items

## SYNTAX

```
Find-ServerDataItem [-ItemType] <String> [[-ItemId] <String>] [-Context] <Uri> [-Token] <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Searches through the various data items registered in the server's data store and returns a list of items
found at a specified location.
This list of items is dynamic, as the results can be find tuned to return
items with a certain item type or item ID.
At least one of the parameters below must be defined for this
operation to run successfully.

## EXAMPLES

### EXAMPLE 1
```
Find-ServerDataItem -ItemType NoSQLDatabase
Returns all NoSQLDatabase data items registered with the Server's data store.
```

## PARAMETERS

### -ItemType
Item type (e.g., BigDataFileShare, CloudStore, EnterpriseDatabase, NoSQLDatabase, RasterStore, FileShare)

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
Item ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
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
Name:     Find-ServerDataItem
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-09-11
- Version history is captured in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/server/finddataitems/

## RELATED LINKS

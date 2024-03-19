# New-TableSchemaObject

## SYNOPSIS
Create a new table schema object

## SYNTAX

### _typ (Default)
```
New-TableSchemaObject -Type <String> -Name <String> -Alias <String> [-Length <Int32>] [<CommonParameters>]
```

### _oid
```
New-TableSchemaObject [-OID] [<CommonParameters>]
```

## DESCRIPTION
Create a new table schema object for a Hosted Feature Service table

## EXAMPLES

### EXAMPLE 1
```
New-TableSchemaObject -Type string -Name RegionName -Alias "Region Name" -Length 255
Returns an object with all required properties for a schema component of a Hosted Feature Service table
```

## PARAMETERS

### -Type
Object type

```yaml
Type: String
Parameter Sets: _typ
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Schema object name

```yaml
Type: String
Parameter Sets: _typ
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Alias
Schema object alias

```yaml
Type: String
Parameter Sets: _typ
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Length
Field maximum length

```yaml
Type: Int32
Parameter Sets: _typ
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OID
Internal OID property

```yaml
Type: SwitchParameter
Parameter Sets: _oid
Aliases:

Required: True
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
Name:     New-TableSchemaObject
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-03-19
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes

## RELATED LINKS

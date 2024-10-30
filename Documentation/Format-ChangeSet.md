# Format-ChangeSet

## SYNOPSIS
Format change set for reporting purposes

## SYNTAX

```
Format-ChangeSet [-ServiceName] <String> [-ChangeSet] <Object> [<CommonParameters>]
```

## DESCRIPTION
Re-format payload response from "extracChanges" API call to report-friendly object

## EXAMPLES

### EXAMPLE 1
```
Format-ChangeSet
Explanation of what the example does
```

## PARAMETERS

### -ServiceName
ArcGIS Server service name

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

### -ChangeSet
Response from "extractChanges" API call

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
Name:     Format-ChangeSet
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2024-10-30
Comments: \<Comment(s)\>

## RELATED LINKS

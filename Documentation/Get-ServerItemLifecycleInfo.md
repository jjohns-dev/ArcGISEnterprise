# Get-ServerItemLifecycleInfo

## SYNOPSIS
Get ArcGIS Server item lifecycle information

## SYNTAX

```
Get-ServerItemLifecycleInfo -DataItem <String> -ChildItem <String> [-Context] <Uri> [-Token <String>]
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get ArcGIS Service item lifecycle information

## EXAMPLES

### EXAMPLE 1
```
Get-ServerItemLifecycleInfo @cmnParams -DataItem 'enterpriseDatabases' -ChildItem 'AGSDataStore'
Returns the lifecycle info for 'AGSDataStore' child item of type 'enterpriseDatabases'
```

## PARAMETERS

### -DataItem
Data item type

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ChildItem
Name of child item

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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
Position: 1
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

Required: False
Position: Named
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
Name:     Get-ServerItemLifecycleInfo
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-10-25
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/server/lifecycle-info/
https://developers.arcgis.com/rest/enterprise-administration/server/dataitem/

## RELATED LINKS

# Add-ServerFeature

## SYNOPSIS
Add feature to Feature Service

## SYNTAX

### __rcd
```
Add-ServerFeature -Record <Object[]> -ServiceName <String> [-LayerId <Int32>] [-FolderName <String>]
 -Context <Uri> -Token <String> [-SkipCertificateCheck] [<CommonParameters>]
```

### __ftr
```
Add-ServerFeature -Feature <Object[]> -ServiceName <String> [-LayerId <Int32>] [-FolderName <String>]
 -Context <Uri> -Token <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Add feature to a Feature Service

## EXAMPLES

### EXAMPLE 1
```
Add-ServerFeature @commonParams -Record $rec -ServiceName "dashboard"
Add records to a Hosted Feature Service named "dashboard"
```

## PARAMETERS

### -Record
Feature record or attributes to add

```yaml
Type: Object[]
Parameter Sets: __rcd
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Feature
Feature to add to the Feature Service

```yaml
Type: Object[]
Parameter Sets: __ftr
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceName
Portal Hosted Feature Service Name

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

### -LayerId
Service Layer ID

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Layer

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FolderName
Server Service Folder Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Hosted
Accept pipeline input: False
Accept wildcard characters: False
```

### -Context
Portal context (e.g., https://arcgis.com/arcgis)

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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
Name:     Add-ServerFeature
Author:   Justin Johns
Version:  0.1.2 | Last Edit: 2024-02-19
- See commit history for version changes
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/services-reference/enterprise/add-features.htm

## RELATED LINKS

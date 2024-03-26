# Invoke-PortalItemAnalysis

## SYNOPSIS
Invoke Portal item analysis

## SYNTAX

### _itid (Default)
```
Invoke-PortalItemAnalysis -ItemId <String> -FileType <String> -Context <Uri> -Token <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

### _post
```
Invoke-PortalItemAnalysis -File <FileInfo> -FileType <String> -Context <Uri> -Token <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Invoke API endpoint "analyze." Analysis file prior to publishing

## EXAMPLES

### EXAMPLE 1
```
Invoke-PortalItemAnalysis -ItemId ea42cab6e3654405b54f0b2b50a0041b -FileType CSV @commonParams
Analyzes the CSV item with ID ea42cab6e3654405b54f0b2b50a0041b
```

### EXAMPLE 2
```
Invoke-PortalItemAnalysis -File C:\file.csv -FileType CSV @commonParams
Analyzes the CSV file C:\file.csv
```

## PARAMETERS

### -ItemId
Id of previously uploaded Portal item

```yaml
Type: String
Parameter Sets: _itid
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
System.IO.FileInfo object to POST and analyze

```yaml
Type: FileInfo
Parameter Sets: _post
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileType
File type

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
Name:     Invoke-PortalItemAnalysis
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-03-19
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/users-groups-and-items/analyze.htm

## RELATED LINKS

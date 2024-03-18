# New-PortalUserFolder

## SYNOPSIS
Creates a new folder in Portal for the specified user

## SYNTAX

```
New-PortalUserFolder [[-Username] <String>] [-Title] <String> [-Context] <Uri> [-Token] <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Creates a new folder in Portal for the specified user

## EXAMPLES

### EXAMPLE 1
```
New-PortalUserFolder -Username jsmith -Title NewFolder -Context 'https://arcgis.com/arcgis' -Token $token
Creates a folder titled 'NewFolder' in Portal for the user 'jsmith'.
```

## PARAMETERS

### -Username
Username

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
Title of new folder

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

### -Context
Portal context (e.g., https://arcgis.com/arcgis)

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
Portal token

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
Name:     New-PortalUserFolder
Author:   Phillip Glodowski
Version:  0.1.0 | Last Edit: 2024-03-13
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/users-groups-and-items/create-folder.htm
General notes:

## RELATED LINKS

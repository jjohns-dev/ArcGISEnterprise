# Get-PortalUserFolderList

## SYNOPSIS
Get Portal for ArcGIS user folder list

## SYNTAX

```
Get-PortalUserFolderList [[-Username] <String>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get all folders owned by user in Portal for ArcGIS

## EXAMPLES

### EXAMPLE 1
```
Get-PortalUserFolderList @commonParams -Username 'jsmith'
Get all Portal folders belonging to 'jsmith'
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

### -Context
Portal context (e.g., https://arcgis.com/arcgis)

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
Name:     Get-PortalUserFolderList
Author:   Phillip Glodowski
Version:  0.1.0 | Last Edit: 2024-3-13
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/users-groups-and-items/user-content.htm
This endpoint can also be used to retrieve user items, however the endpoint used
in the Get-PortalUserItemList function is a more efficient method of making sure
all of the user's items are returned.
General notes

## RELATED LINKS

# Grant-PortalUserItemAccess

## SYNOPSIS
Short description

## SYNTAX

### _grp (Default)
```
Grant-PortalUserItemAccess -ItemId <String[]> -GroupId <String[]> [-UserName <String>] -Context <Uri>
 -Token <String> [-SkipCertificateCheck] [<CommonParameters>]
```

### _ery
```
Grant-PortalUserItemAccess -ItemId <String[]> [-Everyone] [-UserName <String>] -Context <Uri> -Token <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

### _org
```
Grant-PortalUserItemAccess -ItemId <String[]> [-Org] [-UserName <String>] -Context <Uri> -Token <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Long description

## EXAMPLES

### EXAMPLE 1
```
Grant-PortalUserItemAccess -ItemId $iId -GroupId $myGroup.id @commonParams
Shares the current user's Portal item with ID $iId to the group with ID $myGroup.id
```

## PARAMETERS

### -ItemId
Id of Portal item

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupId
Group ID

```yaml
Type: String[]
Parameter Sets: _grp
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Everyone
Share item with everyone

```yaml
Type: SwitchParameter
Parameter Sets: _ery
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Org
Share item with org

```yaml
Type: SwitchParameter
Parameter Sets: _org
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
Username

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

### -Context
Server context (e.g., https://arcgis.com/arcgis)

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
Porta token

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
Name:     Grant-PortalUserItemAccess
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-03-22
- 0.1.0 - Initial version
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/share-items.htm

## RELATED LINKS

# Get-PortalUser

## SYNOPSIS
Get Portal user

## SYNTAX

```
Get-PortalUser [-Username] <String> [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get Portal user

## EXAMPLES

### EXAMPLE 1
```
Get-PortalUser -Context 'https://arcgis.com/arcgis' -Username 'joe' -Token $token
Returns user object with username 'joe' from Portal
```

## PARAMETERS

### -Username
Portal username

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
General notes
https://developers.arcgis.com/rest/users-groups-and-items/user.htm

## RELATED LINKS

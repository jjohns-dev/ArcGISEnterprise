# Set-ServerPSAPassword

## SYNOPSIS
Set ArcGIS Server PSA Account

## SYNTAX

```
Set-ServerPSAPassword [-Context] <Uri> [-Credential] <PSCredential> [-NewPassword] <PSCredential>
 [<CommonParameters>]
```

## DESCRIPTION
Set ArcGIS Server PSA Account

## EXAMPLES

### EXAMPLE 1
```
Set-ServerPSAPassword -Context https://arcgisonline.com/arcgis -Credential $creds -NewPassword $new
Set the Portal user specified by the "username" property of the $creds credential object to the password in the $new credential object
```

## PARAMETERS

### -Context
ArcGIS Server context (e.g., https://arcgis.com/arcgis)

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

### -Credential
PSCredential object containing current username and password

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewPassword
PSCredential object containing new password

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
Name:     Set-ServerPSAPassword
Author:   Phillip Glodowski, Justin Johns
Version:  0.2.1 | Last Edit: 2023-12-04
- 0.2.1 - Fixed error handling
- 0.2.0 - Renamed cmdlet to Set-ServerPSAPassword
- 0.1.0 - Initial version (Update-ServerPSA)
Comments: \<Comment(s)\>
General notes
https://developers.arcgis.com/rest/enterprise-administration/server/psa.htm
https://developers.arcgis.com/rest/enterprise-administration/server/updatepsa.htm
https://developers.arcgis.com/rest/users-groups-and-items/update-user.htm

## RELATED LINKS

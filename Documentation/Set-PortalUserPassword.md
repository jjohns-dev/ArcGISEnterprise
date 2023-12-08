# Set-PortalUserPassword

## SYNOPSIS
Set Portal for ArcGIS PSA Account

## SYNTAX

```
Set-PortalUserPassword [-Context] <Uri> [-Credential] <PSCredential> [-NewPassword] <PSCredential>
 [<CommonParameters>]
```

## DESCRIPTION
Set Portal for ArcGIS PSA Account

## EXAMPLES

### EXAMPLE 1
```
Set-PortalUserPassword -Context https://arcgisonline.com/arcgis -Credential $creds -NewPassword $new
Set the user ArcGIS Server specified by the "username" property of the $creds credential object to the password in the $new credential object
```

## PARAMETERS

### -Context
Portal context (e.g., https://arcgis.com/arcgis)

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
Name:     Set-PortalUserPassword
Author:   Justin Johns
Version:  0.2.1 | Last Edit: 2023-12-04
- 0.2.1 - Fixed error handling
- 0.2.0 - Renamed cmdlet to Set-PortalUserPassword
- 0.1.0 - Initial version (Update-PortalPSA)
General notes:

## RELATED LINKS

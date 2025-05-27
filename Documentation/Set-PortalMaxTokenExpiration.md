# Set-PortalMaxTokenExpiration

## SYNOPSIS
Set the maximum validity in minutes of both OAuth and nonOAuth tokens issued for users of the organization.

## SYNTAX

```
Set-PortalMaxTokenExpiration [-Expiration] <Int32> [[-PortalId] <String>] [-Context] <Uri> [-Token] <String>
 [-SkipCertificateCheck] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set the maximum validity in minutes of both OAuth and nonOAuth tokens issued for users of the organization.

## EXAMPLES

### EXAMPLE 1
```
Set-PortalMaxTokenExpiration @cmnParams -Expiration 1440
Set the maximum validity in minutes of both OAuth and nonOAuth tokens issued for users of the organization to 1440 minutes (24 hours).
```

## PARAMETERS

### -Expiration
The maximum validity in minutes of both OAuth and nonOAuth tokens issued for users of the organization.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PortalId
Portal application ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0123456789ABCDEF
Accept pipeline input: False
Accept wildcard characters: False
```

### -Context
Target Portal context

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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
Name:     Set-PortalMaxTokenExpiration
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2025-05-27
- Version history is captured in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/update.htm

## RELATED LINKS

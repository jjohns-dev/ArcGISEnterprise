# Get-PortalGroupItemJobStatus

## SYNOPSIS
Get job status for Portal Group export job

## SYNTAX

```
Get-PortalGroupItemJobStatus [-JobId] <String> [[-Key] <String>] [[-PortalId] <String>] [-Context] <Uri>
 [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get job status for Portal Group export job

## EXAMPLES

### EXAMPLE 1
```
Get-PortalGroupItemJobStatus @cmnParams -ItemId 0123456789ABCDEF
Returns the job status information for the Portal Group export job with the ID 0123456789ABCDEF
```

## PARAMETERS

### -JobId
Portal group export job ID

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

### -Key
Portal group export job key (only required for non-admin users)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
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
Position: 3
Default value: 0123456789ABCDEF
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
Position: 4
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
Position: 5
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
Name:     Get-PortalGroupItemJobStatus
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2025-07-22
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/export-group-content/

## RELATED LINKS

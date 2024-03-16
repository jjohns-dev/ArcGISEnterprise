# Get-PortalJobStatus

## SYNOPSIS
Get Portal job status

## SYNTAX

```
Get-PortalJobStatus [-ItemId] <String> [[-JobType] <String>] [-JobId] <String> [[-UserName] <String>]
 [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Gets the job status for a Portal job

## EXAMPLES

### EXAMPLE 1
```
Get-PortalJobStatus -ItemId $iid -JobId j808b16d104894c8b8d9404555966eb6e @commonParams
Gets the job status for a publish job with id j808b16d104894c8b8d9404555966eb6e and Item ID $iid
```

## PARAMETERS

### -ItemId
Id of Portal item

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

### -JobType
Portal job type

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Publish
Accept pipeline input: False
Accept wildcard characters: False
```

### -JobId
Portal job ID

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

### -UserName
Username

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 5
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
Position: 6
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
Name:     Get-PortalJobStatus
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-03-15
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/users-groups-and-items/status.htm

## RELATED LINKS

# Get-ServerServiceExtractChange

## SYNOPSIS
Return change history for ArcGIS Server service

## SYNTAX

```
Get-ServerServiceExtractChange [-ServiceName] <String> [[-FolderName] <String>] [-IdsOnly] [-Context] <Uri>
 [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Use the extractChanges endpoint to return change history for service

## EXAMPLES

### EXAMPLE 1
```
$request = Get-ServerServiceExtractChange @cmnParams -ServiceName 'MyService'
$job = Invoke-RestMethod -Uri $request.statusUrl -Method Post -Body @{ f = 'json'; token = $token }
$data = Invoke-RestMethod -Uri $job.resultUrl -Method Post -Body @{ f = 'json'; token = $token }
The first line submits a job to generate the change data for service "MyService."
Second line returns an object with the property "resultUrl" to retrieve the change data.
Third line returns the change data for the service "MyService"
```

## PARAMETERS

### -ServiceName
Name of service

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

### -FolderName
Folder name in ArcGIS Server (defaults to "Hosted")

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Hosted
Accept pipeline input: False
Accept wildcard characters: False
```

### -IdsOnly
Returns IDs only

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

### -Context
Server context (e.g., https://arcgis.com/arcgis)

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
Porta token

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
Name:     Get-ServerServiceExtractChange
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-10-25
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/services-reference/enterprise/extract-changes-feature-service/

## RELATED LINKS

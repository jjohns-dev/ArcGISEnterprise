# Get-ServerService

## SYNOPSIS
Get ArcGIS Server service metadata

## SYNTAX

```
Get-ServerService [-ServiceName] <String> [-ServiceType] <String> [[-FolderName] <String>] [-Admin]
 [-Context] <Uri> [[-Token] <String>] [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get ArcGIS Server service metadata

## EXAMPLES

### EXAMPLE 1
```
Get-ServerService @cmnParams -Folder 'Energy' -ServiceName 'Geology' -ServiceType 'FeatureServer'
Returns service metadata for the 'Geology' FeatureServer in the 'Energy' folder
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

### -ServiceType
Type of service (e.g., FeatureServer or MapServer)

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

### -FolderName
Folder name in ArcGIS Server

```yaml
Type: String
Parameter Sets: (All)
Aliases: Folder

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Admin
Use admin endpoint

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

Required: False
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
Name:     Get-ServerService
Author:   Justin Johns
Version:  0.1.1 | Last Edit: 2025-07-22
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/enterprise-administration/server/service/
https://developers.arcgis.com/rest/services-reference/enterprise/get-started-with-the-services-directory/
Performance Testing:
Using custom properties instead of custom objects for output appears to be slightly faster, but only slightly.
Below is the code used to test performance.
The cmdlet "Test-Performance" requires the SecurityTools modules.
Test-Performance -Runs 100 -ScriptBlock {
    $params = @{
        Context     = 'https://sampleserver6.arcgisonline.com/arcgis'
        ServiceName = 'DamageAssessment'
        ServiceType = 'FeatureServer'
    }
    Get-ServerService @params | Out-Null
}

## RELATED LINKS

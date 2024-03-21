# Get-ServerServiceItemInfo

## SYNOPSIS
Get ArcGIS Server service item information

## SYNTAX

```
Get-ServerServiceItemInfo [-ServiceName] <String> [[-FolderName] <String>] [-Context] <Uri> [[-Token] <String>]
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get ArcGIS Server service item information/details

## EXAMPLES

### EXAMPLE 1
```
Get-ServerServiceItemInfo -Context 'https://arcgis.com/arcgis' -Token $token -Service $s
Returns the service item info for service $s
```

## PARAMETERS

### -ServiceName
\[Parameter(Mandatory = $true, HelpMessage = 'ArcGIS Server service object (use Get-ServerAdminServiceList -Admin)')\]
       \[ValidateScript({ $_.serviceName -and $_.type })\]
       \[System.Object\] $Service,

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
ArcGIS Server folder name

```yaml
Type: String
Parameter Sets: (All)
Aliases: Folder

Required: False
Position: 2
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

Required: False
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
General notes:
https://developers.arcgis.com/rest/enterprise-administration/server/services.htm

## RELATED LINKS

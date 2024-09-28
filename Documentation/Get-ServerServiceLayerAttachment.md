# Get-ServerServiceLayerAttachment

## SYNOPSIS
Get ArcGIS service layer attachment(s)

## SYNTAX

### __gid (Default)
```
Get-ServerServiceLayerAttachment -GlobalId <String[]> -LayerId <Int32> -ServiceName <String>
 [-FolderName <String>] [-ReportData] -Context <Uri> [-Token <String>] [-SkipCertificateCheck]
 [<CommonParameters>]
```

### __oid
```
Get-ServerServiceLayerAttachment -ObjectId <Int64[]> -LayerId <Int32> -ServiceName <String>
 [-FolderName <String>] [-ReportData] -Context <Uri> [-Token <String>] [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
The result of this operation are attachments grouped by the source feature object Ids and global ids (if exist)

## EXAMPLES

### EXAMPLE 1
```
Get-ServerServiceLayerAttachment @cmnParams -GlobalId '96B099D7-C4FD-4B73-99E6-C7D6552F4E22' -LayerId 0 -ServiceName 'dashboard'
Returns the attachment(s) for the feature with the global ID '96B099D7-C4FD-4B73-99E6-C7D6552F4E22' in the 'dashboard' service
```

## PARAMETERS

### -GlobalId
Global ID

```yaml
Type: String[]
Parameter Sets: __gid
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ObjectId
Object ID

```yaml
Type: Int64[]
Parameter Sets: __oid
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LayerId
Service Layer ID

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Layer

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceName
Name of service

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

### -FolderName
Folder name in ArcGIS Server

```yaml
Type: String
Parameter Sets: (All)
Aliases: Folder

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportData
Return report data

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

Required: False
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
Name:     Get-ServerServiceLayerAttachment
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-09-25
- Version history is capture in repository commit history
Comments:
https://developers.arcgis.com/rest/services-reference/enterprise/query-attachments-feature-service-layer/

## RELATED LINKS

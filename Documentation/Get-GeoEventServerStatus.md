# Get-GeoEventServerStatus

## SYNOPSIS
Retrieves the health status of a GeoEvent Server

## SYNTAX

```
Get-GeoEventServerStatus [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Sends a web request to the GeoEvent Server health status endpoint and retrieves the current health status information.
For now, this is merely a web response with no further information.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> $GeoEventContext = 'https://arcgis.com/geoevent'
PS C:\> $ServerContext = 'https://arcgis.com/arcgis'
PS C:\> $token = Get-ServerToken -Credentials (Get-Credential) -Context $ServerContext -Referer $GeoEventContext -Client 'referer'
PS C:\> Get-GeoEventServerStatus -Context $GeoEventContext -Token $token.token
```

Sends a web request to the GeoEvent Server health status endpoint

## PARAMETERS

### -Context
Target GeoEvent Server Context

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

### -Token
Server token (from the GeoEvent Server's ArcGIS Server site)
When generating token, you must set the "Referer" parameter to the GeoEvent Server context URL
and the "Client" parameter to "referer"

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

### None
## OUTPUTS

### System.Object
## NOTES
Name:     Get-GeoEventServerStatus
Author:   Phillip Glodowski
Version:  0.1.0 | Last Edit: 2025-11-14

API Documentation can be found at:
https://yourgeoeventserver.domain/geoevent/admin/api/index.html

## RELATED LINKS

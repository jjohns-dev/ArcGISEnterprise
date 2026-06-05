---
document type: cmdlet
external help file: ArcGISEnterprise-Help.xml
HelpUri: ''
Locale: en-US
Module Name: ArcGISEnterprise
ms.date: 06/05/2026
PlatyPS schema version: 2024-05-01
title: Get-GeoEventServerStatus
---

# Get-GeoEventServerStatus

## SYNOPSIS

Retrieves the health status of a GeoEvent Server

## SYNTAX

### __AllParameterSets

```
Get-GeoEventServerStatus [-Context] <uri> [-Token] <string> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Sends a web request to the GeoEvent Server health status endpoint and retrieves the current health status information.
For now, this is merely a web response with no further information.

## EXAMPLES

### EXAMPLE 1

$GeoEventContext = 'https://arcgis.com/geoevent'
PS C:\> $ServerContext = 'https://arcgis.com/arcgis'
PS C:\> $token = Get-ServerToken -Credentials (Get-Credential) -Context $ServerContext -Referer $GeoEventContext -Client 'referer'
PS C:\> Get-GeoEventServerStatus -Context $GeoEventContext -Token $token.token

Sends a web request to the GeoEvent Server health status endpoint

## PARAMETERS

### -Context

Target GeoEvent Server Context

```yaml
Type: System.Uri
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SkipCertificateCheck

Ignore missing or invalid certificate

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Token

Server token (from the GeoEvent Server's ArcGIS Server site)
When generating token, you must set the "Referer" parameter to the GeoEvent Server context URL
and the "Client" parameter to "referer"

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object

{{ Fill in the Description }}

### System.Management.Automation.PSCustomObject

{{ Fill in the Description }}

## NOTES

Status: Stable

API Documentation can be found at:
https://yourgeoeventserver.domain/geoevent/admin/api/index.html


## RELATED LINKS

{{ Fill in the related links here }}


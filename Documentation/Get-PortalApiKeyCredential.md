---
document type: cmdlet
external help file: ArcGISEnterprise-Help.xml
HelpUri: ''
Locale: en-US
Module Name: ArcGISEnterprise
ms.date: 10/21/2026
PlatyPS schema version: 2024-05-01
title: Get-PortalApiKeyCredential
---

# Get-PortalApiKeyCredential

## SYNOPSIS

Get Portal API key credentials

## SYNTAX

### __AllParameterSets

```
Get-PortalApiKeyCredential [[-ItemId] <string>] [[-UserName] <string>] [-Context] <uri>
 [-Token] <string> [-SkipCertificateCheck] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Get API key credentials items with the state and expiration of each API key slot.
With -ItemId, returns that item.
Without -ItemId, returns every API key credentials
item owned by -UserName (default: the user associated with the token).
Slot
expirations are returned only for active slots, because Portal keeps the last
expiration on a slot after its key is revoked.

## EXAMPLES

### EXAMPLE 1

Get-PortalApiKeyCredential -ItemId '0123456789abcdef0123456789abcdef' @commonParams
Returns the API key credentials item, including whether each key slot is active and when it expires

### EXAMPLE 2

Get-PortalApiKeyCredential -UserName 'jsmith' @commonParams
Returns all API key credentials items owned by jsmith

## PARAMETERS

### -Context

Portal context (e.g., https://arcgis.com/arcgis)

```yaml
Type: System.Uri
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ItemId

API key credentials item ID

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

Portal token

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UserName

Owner whose API key credentials are listed when -ItemId is not given.
Defaults to the
user associated with the token.
Ignored with -ItemId, which always uses the item owner

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
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

### System.String.

{{ Fill in the Description }}

### System.String

{{ Fill in the Description }}

## OUTPUTS

### System.Management.Automation.PSCustomObject.

{{ Fill in the Description }}

### System.Management.Automation.PSCustomObject

{{ Fill in the Description }}

## NOTES

Status: Stable
Comments: Requires ArcGIS Enterprise 11.4 or later.
Verified on 11.5; an administrator
token can read credentials owned by other users.
https://developers.arcgis.com/rest/users-groups-and-items/registered-app-info.htm


## RELATED LINKS

{{ Fill in the related links here }}


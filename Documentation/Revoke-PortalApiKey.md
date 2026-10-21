---
document type: cmdlet
external help file: ArcGISEnterprise-Help.xml
HelpUri: ''
Locale: en-US
Module Name: ArcGISEnterprise
ms.date: 10/21/2026
PlatyPS schema version: 2024-05-01
title: Revoke-PortalApiKey
---

# Revoke-PortalApiKey

## SYNOPSIS

Revoke a Portal API key

## SYNTAX

### __AllParameterSets

```
Revoke-PortalApiKey [-ItemId] <string> [-Slot] <int> [-Context] <uri> [-Token] <string>
 [-SkipCertificateCheck] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Invalidate the API key in slot 1 or 2 of an API key credentials item.
The key stops
working immediately.
If the slot is not active, a warning is written and no request
is made.

## EXAMPLES

### EXAMPLE 1

Revoke-PortalApiKey -ItemId '0123456789abcdef0123456789abcdef' -Slot 1 @commonParams
Invalidates the API key in slot 1

### EXAMPLE 2

Get-PortalApiKeyCredential -ItemId $itemId @commonParams | Revoke-PortalApiKey -Slot 1 -Confirm:$false @commonParams
Invalidates the API key in slot 1 without prompting, for use in automation

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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
  IsRequired: true
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

### -Slot

API key slot (1 or 2)

```yaml
Type: System.Int32
DefaultValue: 0
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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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

### None.

{{ Fill in the Description }}

### System.Void

{{ Fill in the Description }}

## NOTES

Status: Stable
Comments: Requires ArcGIS Enterprise 11.4 or later.
Verified on 11.5; an administrator
token can manage credentials owned by other users.
The apiToken and regenerateApiToken
parameters of oauth2/revokeToken are not in the REST API reference; they follow Esri's
ArcGIS REST JS developer-credentials package.
https://developers.arcgis.com/arcgis-rest-js/api-reference/arcgis-rest-developer-credentials/invalidateApiKey/


## RELATED LINKS

{{ Fill in the related links here }}


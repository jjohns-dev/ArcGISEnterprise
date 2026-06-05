---
document type: cmdlet
external help file: ArcGISEnterprise-Help.xml
HelpUri: ''
Locale: en-US
Module Name: ArcGISEnterprise
ms.date: 06/05/2026
PlatyPS schema version: 2024-05-01
title: Set-PortalItemOwner
---

# Set-PortalItemOwner

## SYNOPSIS

Change ownership of a portal item

## SYNTAX

### __AllParameterSets

```
Set-PortalItemOwner [-ItemId] <string[]> [-UserName] <string> [-TargetUserName] <string>
 [[-TargetFolderName] <string>] [-Context] <uri> [-Token] <string> [-SkipCertificateCheck] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The reassignItems operation reassigns items owned by one user to another user in the organization.
Before performing this operation, it is recommended that you first determine whether the user is eligible to receive content.
Item owners must have the portal:user:reassignItems privilege assigned to them to transfer content to another user.
Users assigned the default administrator role, or users assigned a custom administrative role that includes the
portal:user:reassignItems privilege, can also perform this operation on behalf of the item owner.

## EXAMPLES

### EXAMPLE 1

Set-PortalItemOwner @cmnParams -ItemId 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6' -UserName 'jsmith' -TargetUserName 'jdoe'
Changes ownership of the item with ID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6' from user 'jsmith' to user 'jdoe'.

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

Server context (e.g., https://arcgis.com/arcgis)

```yaml
Type: System.Uri
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ItemId

Portal item ID

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
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

### -TargetFolderName

Name of the folder to move the item to (default to new folder with date).
Use '/' for root folder.
Creates new folder if it does not exist.
Name of the folder to move the item to (default to new folder with date).
Use '/' for root folder.
Creates new folder if it does not exist.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TargetUserName

Username of new item owner

```yaml
Type: System.String
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

### -Token

Porta token

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 5
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UserName

Username of current item owner

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

### System.String[]

{{ Fill in the Description }}

## OUTPUTS

### System.Object.

{{ Fill in the Description }}

### System.Management.Automation.PSCustomObject

{{ Fill in the Description }}

## NOTES

Status: Stable
Comments:
https://developers.arcgis.com/rest/users-groups-and-items/reassign-items/
(old) https://developers.arcgis.com/rest/users-groups-and-items/reassign-item/

## RELATED LINKS

{{ Fill in the related links here }}


# Test-PortalDataStore

## SYNOPSIS
Validates Data Store connection

## SYNTAX

```
Test-PortalDataStore [-ItemId] <String> [-ServerId] <String> [[-PortalId] <String>] [-Context] <Uri>
 [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Validates Data Store connection with Portal for ArcGIS

## EXAMPLES

### EXAMPLE 1
```
$item = Get-PortalUserItemList -UserName 'janedoe@fake.com' @commonParams | Where-Object title -EQ 'test_store_internal'
PS C:\> $server = Get-PortalDataStoreServer -ItemId $item.id @commonParams
PS C:\> Test-PortalDataStore -ItemId $item.id -ServerId $server.servers[0].id @commonParams
Validates the Data Store item named 'test_store_internal' connection to the ArcGIS Server
```

## PARAMETERS

### -ItemId
Portal item ID of Data Store item

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

### -ServerId
ID of the Server where the DataStore is registered

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

### -PortalId
Portal application ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0123456789ABCDEF
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
Position: 4
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
Name:     Test-PortalDataStore
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2024-03-21
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
https://developers.arcgis.com/rest/users-groups-and-items/validate-datastore.htm

## RELATED LINKS

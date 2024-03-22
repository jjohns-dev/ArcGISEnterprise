# ArcGISEnterprise

PowerShell module for ArcGIS Enterprise REST API. Includes functions for both
ArcGIS Server and Portal for ArcGIS.

## Function Naming

Like all PowerShell functions and cmdlets, the functions in this module follow the `Verb` `-` `Noun` scheme.
Each `Noun` will start with the ArcGIS Enterprise component the function should be executaged against.
For example, to use `Get-PortalRole` pass a Portal for ArcGIS URI argument in the `-Context` parameter.
Or, as another example, pass an ArcGIS Server URI argument to the `-Context` parameter for `Set-ServerAllowedOrigins`
to set/update the allowed origins property in ArcGIS Server.

## Updates

Please see releases for updates and features

## Function to API Mapping

### Root Directories

| Component | Name | Path |
| --------- | ---- | ---- |
| Portal | ROOT | `/sharing/rest` |
| Server | ROOT | `/rest/services` |
| Server | RADMIN | `/rest/admin` |
| Server | ADMIN | `/admin` |

### API Endpoints

| Function | Component | API Endpoint | Description |
| -------- | --------- | ------------ | ----------- |
| Add-ServerHostedFeatureServiceRecord | Server | `[ROOT]/Hosted/[SERVICENAME]/FeatureServer/[LAYERID]/addFeatures` | Appends data to table in Hosted Feature Service |
| Clear-ServerHostedFeatureService | Server | `[ROOT]/Hosted/[SERVICENAME]/FeatureServer/[LAYERID]/deleteFeatures` | Truncates table data in Hosted Feature Service |
| Edit-ServerHostedFeatureRecord | Server | `[ROOT]/Hosted/[SERVICENAME]/FeatureServer/[LAYERID]/applyEdits` | Adds, updates, or deletes features/records from a table layer |
| Get-PortalDataStoreServer | Portal | `[ROOT]/portals/[PORTALID]/datastores/getServers` | Get server object for Portal DataStore item |
| Get-PortalJobStatus | Portal | `[ROOT]/content/users/[USERNAME]/items/[ITEMID]/status` | Get Portal job status |
| Get-PortalUserFolderList | Portal | `[ROOT]/content/users/[USERNAME]` | Gets list of folders owned by user in Portal |
| Get-PortalUserGroupList | Portal | `[ROOT]/community/groups` | Search for groups owned by specified user. Additional options available |
| Get-PortalUserItemList | Portal | `[ROOT]/search` | Search Portal. Additional options available |
| Get-ServerAllowedOrigins | Server | `[ADMIN]/system/handlers/soap/soaphandlerconfig` | Get allowed origins for Server |
| Get-ServerLicense | Server | `[ADMIN]/system/licenses` | Get Server license info |
| Get-ServerPSA | Server | `[ADMIN]/security/psa` | Get Server PSA account |
| Get-ServerService | Server | `[ADMIN]/services/[FOLDERNAME]/[SERVICENAME].[SERVICETYPE]` | Get service from admin endpoint |
| Get-ServerServiceItemInfo | Server | `[ADMIN]/services/[FOLDERNAME]/[SERVICENAME].[SERVICETYPE]/iteminfo` | Get service item info from admin endpoint |
| Get-ServerServicesDirectory | Server | `[ADMIN]/system/handlers/rest/servicesdirectory` | Get service directory from admin endpoint |
| Get-ServerSetting | Server | `/[SETTINGSURL]` | Get Server settings from admin endpoint |
| Get-ServerServiceFieldInfo | Server | `[ROOT]/[FOLDERNAME]/[SERVICENAME]/[SERVICETYPE]` | Get service field info |
| Get-ServerServiceList | Server | `[ROOT]` and `[ADMIN]/services` | Get list of services in ArcGIS Server |
| Get-ServerHostedFeatureService | Server | `[ROOT]/Hosted/[SERVICENAME]/FeatureServer` | Gets Hosted Feature Service |
| Grant-PortalUserItemAccess | Portal | `[ROOT]/content/users/[USERNAME]/shareItems` | Share Portal item |
| Invoke-PortalItemAnalysis | Portal | `[ROOT]/content/features/analyze` | Analyze file prior to publishing |
| Invoke-ServerHostedFeatureQuery | Server | `[ROOT]/Hosted/[SERVICENAME]/FeatureServer/[LAYERID]/query` | Query feature service layer. Additional options available |
| Move-PortalUserItem | Portal | `[ROOT]/content/users/[USERNAME]/moveItems` | Move Portal item to folder |
| New-PortalHostedFeatureService | Portal | `[ROOT]/content/users/[USERNAME]/createService` | Creates new Hosted Feature Service |
| New-PortalUserFolder | Portal | `[ROOT]/content/users/[USERNAME]/createFolder` | Creates new folder in Portal |
| New-PortalUserGroup | Portal | `[ROOT]/community/createGroup` | Create new Portal user group |
| New-ServerFolder | Server | `[ADMIN]/services/createFolder` | Create a new folder in ArcGIS Server |
| New-ServerHostedFeatureTable | Server | `[RADMIN]/services/Hosted/[SERVICENAME]/FeatureServer/addToDefinition` | Creates table as a layer in Hosted Feature Service |
| Publish-PortalCsvItemAsTable | Portal | `[ROOT]/content/users/[USERNAME]/publish` | Publish CSV item (Portal item) as Hosted Table. Additional options available |
| Remove-PortalItem | Portal | `[ROOT]/content/users/[USERNAME]/items/[ITEMID]/delete` | Deletes Portal item (e.g., Hosted Feature Service) |
| Remove-PortalUserGroup | Portal | `[ROOT]/community/groups/[GROUPID]/delete` | Delete Portal user group |
| Remove-ServerFolder | Server | `[ADMIN]/services/[FOLDERNAME]/deleteFolder` | Deletes folder in ArcGIS Server and all services in folder |
| Remove-ServerService | Server | `[ADMIN]/services/deleteServices` | Deletes ArcGIS Server Service |
| Remove-ServerServiceLayer | Server | `[RADMIN]/services/Hosted/[SERVICENAME]/FeatureServer/deleteFromDefinition` | Deletes table/layer from ArcGIS Server Service |
| Revoke-PortalUserItemAccess | Portal | `[ROOT]/content/users/[USERNAME]/unshareItems` | Unshare Portal item |
| Test-PortalDataStore | Portal | `[ROOT]/sharing/rest/portals/[PORTALID]/datastores/validate` | Validates connection between Data Store and ArcGIS Server |
| Write-PortalUserItem | Portal | `[ROOT]/content/users/[USERNAME]/addItem` | Uploads a Portal item (file item) |

## Potential Future Functions

| API Endpoint | Description | Link |
| ------------ | ----------- | ---- |
| `updateDefinition` | Update schema | [developer guide](https://developers.arcgis.com/rest/services-reference/online/update-definition-feature-layer-.htm) |

- Add new Server Hosted Feature Layer (point/polygon/line)

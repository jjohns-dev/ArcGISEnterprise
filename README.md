# ArcGISEnterprise

PowerShell module for ArcGIS Enterprise REST API. Includes functions for both
ArcGIS Server and Portal for ArcGIS.

## Function Naming

Like all PowerShell functions and cmdlets, the functions in this module follow the `Verb` `-` `Noun` scheme.
Each `Noun` will start with the ArcGIS Enterprise component the function should be executaged against.
For example, to use `Get-PortalRoleList` pass a Portal for ArcGIS URI argument in the `-Context` parameter.
Or, as another example, pass an ArcGIS Server URI argument to the `-Context` parameter for `Set-ServerAllowedOrigins`
to set/update the allowed origins property in ArcGIS Server.

## Updates

Please see releases for updates and features

## Function to API Mapping

### Root Directories

| Component | Name | Path |
| --------- | ---- | ---- |
| Portal | ROOT | `/sharing/rest` |
| Portal | ADMIN | `/portaladmin` |
| Server | ROOT | `/rest/services` |
| Server | RADMIN | `/rest/admin` |
| Server | ADMIN | `/admin` |

### API Endpoints

| Function | Component | API Endpoint | Description |
| -------- | --------- | ------------ | ----------- |
| Add-PortalOAuthRedirectURI | Portal | `[ADMIN]/security/oauth/updateAppInfo` | Add redirect URI to Portal OAuth app |
| Add-PortalUserToGroup | Portal | `[ROOT]/community/groups/[GROUPID]/addUsers` | Add Portal user to Portal group |
| Add-ServerFeature | Server | `[ROOT]/Hosted/[SERVICENAME]/FeatureServer/[LAYERID]/addFeatures` | Appends data to table in Hosted Feature Service |
| ADD-ServerUsageReport | Server | `[ADMIN]/usagereports/add` | Adds a new usage report |
| Clear-ServerHostedFeatureService | Server | `[ROOT]/Hosted/[SERVICENAME]/FeatureServer/[LAYERID]/deleteFeatures` | Truncates table data in Hosted Feature Service |
| Edit-ServerFeature | Server | `[ROOT]/Hosted/[SERVICENAME]/FeatureServer/[LAYERID]/applyEdits` | Adds, updates, or deletes features/records from a table layer |
| Export-PortalGroupItem | Portal | `[ROOT]/community/groups/[GROUPID]/export` | Exports all exportable content from a Portal group |
| Find-PortalItem | Portal | `[ROOT]/search` | Returns Portal item based on search criteria |
| Find-ServerAddressCandidate | Server | `[ROOT]/[SERVICENAME]/GeocodeServer/findAddressCandidates` | GeoCode single address |
| Find-ServerGeocodeAddress | Server | `[ROOT]/[SERVICENAME]/GeocodeServer/geocodeAddresses` | GeoCode list of addresses |
| Find-ServerReverseGeocode | Server | `[ROOT]/[SERVICENAME]/GeocodeServer/reverseGeocode` | Reverse GeoCode lookup |
| Find-ServerServiceLayerData | Server | `[ROOT]/[SERVICENAME]/FeatureServer/[LAYERID]/query` | Query service layer for data |
| Get-PortalAllowedOriginList | Portal | `[ROOT]/portals/[PORTALID]` | Get the allowed origins configured for ArcGIS Portal |
| Get-PortalCategorySchema | Portal | `[ROOT]/portals/[PORTALID]/categorySchema` | Get Portal category schema |
| Get-PortalDataStoreServer | Portal | `[ROOT]/portals/[PORTALID]/datastores/getServers` | Get server object for Portal DataStore item |
| Get-PortalDefaultUserSettings | Portal | `[ROOT]/portals/[PORTALID]/userDefaultSettings` | Get default user settings from Portal |
| Get-PortalGroupItemJobStatus | Portal | `[ROOT]/portals/[PORTALID]/jobs/[JOBID]` | Get job status for Portal Group export job |
| Get-PortalGroupUserList | Portal | `[ROOT]/community/groups/[GROUPID]/userList` | Get users from group in Portal for ArcGIS |
| Get-PortalIndexStatus | Portal | `[ADMIN]/system/indexer/status` | Get Portal index status |
| Get-PortalItem | Portal | `[ROOT]/content/items/[ITEMID]` | Get Portal item |
| Get-PortalItemData | Portal | `[ROOT]/content/items/[ITEMID]/data` | Get Portal item data |
| Get-PortalJobStatus | Portal | `[ROOT]/content/users/[USERNAME]/items/[ITEMID]/status` | Get Portal job status |
| Get-PortalLicense | Portal | `[ADMIN]/license` | Get Portal license |
| Get-PortalLog | Portal | `[ADMIN]/logs/query` | Get Portal logs |
| Get-PortalMachineList | Portal | `[ADMIN]/machines` | Get Portal machines |
| Get-PortalMachineStatus | Portal | `[ADMIN]/machines/status/[MACHINENAME]` | Get Portal machine status |
| Get-PortalOAuthAppInfo | Portal | `[ADMIN]/security/oauth/getAppInfo` | Get OAuth App Info |
| Get-PortalOAuthToken | Portal | `[ROOT]/oauth2/token` | Get Portal OAuth token |
| Get-PortalRoleList | Portal | `[ROOT]/portals/[PORTALID]/roles` | Get Portal for ArcGIS Role |
| Get-PortalSecurityConfig | Portal | `[ADMIN]/security/config` | Get Portal security configuration |
| Get-PortalSecurityPolicy | Portal | `[ROOT]/portals/[PORTALID]/securityPolicy` | Get Portal security policy |
| Get-PortalSettings | Portal | `[ROOT]/portals/[PORTALID]` | Get Portal configuration or "self" |
| Get-PortalToken | Portal | `[ROOT]/generateToken` | Generate token for ArcGIS Portal |
| Get-PortalUser | Portal | `[ROOT]/community/users/[USERNAME]` | Get Portal user |
| Get-PortalUserFolderList | Portal | `[ROOT]/content/users/[USERNAME]` | Gets list of folders owned by user in Portal |
| Get-PortalUserGroupList | Portal | `[ROOT]/community/groups` | Search for groups owned by specified user. Additional options available |
| Get-PortalUserItemList | Portal | `[ROOT]/search` | Search Portal. Additional options available |
| Get-PortalUserList | Portal | `[ROOT]/portals/[PORTALID]/users` | Get list of all Portal users |
| Get-ServerAllowedOriginList | Server | `[ADMIN]/system/handlers/soap/soaphandlerconfig` | Get allowed origins for Server |
| Get-ServerHostedFeatureService | Server | `[ROOT]/Hosted/[SERVICENAME]/FeatureServer` | Gets Hosted Feature Service |
| Get-ServerItemLifecycleInfo | Server | `[ADMIN]/data/items/[DATAITEM]/[CHILDITEM]/lifecycleinfos` | Get lifecycle info for Server item |
| Get-ServerLicense | Server | `[ADMIN]/system/licenses` | Get Server license info |
| Get-ServerLog | Server | `[ADMIN]/logs/query` | Get Server logs |
| Get-ServerPSA | Server | `[ADMIN]/security/psa` | Get Server PSA account |
| Get-ServerService | Server | `[ADMIN]/services/[FOLDERNAME]/[SERVICENAME].[SERVICETYPE]` | Get service from admin endpoint |
| Get-ServerService | Server | `[ROOT]/[FOLDERNAME]/[SERVICENAME]/[SERVICETYPE]` | Get service from rest endpoint |
| Get-ServerServiceExtractChange | Server | `[ROOT]/[FOLDERNAME]/[SERVICENAME]/FeatureServer/extractChanges` | Submit a job to generate service changes payload |
| Get-ServerServiceItemInfo | Server | `[ADMIN]/services/[FOLDERNAME]/[SERVICENAME].[SERVICETYPE]/iteminfo` | Get service item info from admin endpoint |
| Get-ServerServiceLayer | Server | `[ROOT]/[FOLDERNAME]/[SERVICENAME]/[SERVICETYPE]/[LAYERID]` | Get service layer metadata |
| Get-ServerServiceLayerAttachment | Server | `[ROOT]/[FOLDERNAME]/[SERVICENAME]/[SERVICETYPE]/[LAYERID]/queryAttachments` | Get layer attachments |
| Get-ServerServiceLifecycleInfo | Server | `[ADMIN]/services/[FOLDERNAME]/[SERVICENAME].[SERVICETYPE]/lifecycleinfos` | Get service lifecycle info |
| Get-ServerServiceList | Server | `[ROOT]` and `[ADMIN]/services` | Get list of services in ArcGIS Server |
| Get-ServerServicesDirectory | Server | `[ADMIN]/system/handlers/rest/servicesdirectory` | Get service directory from admin endpoint |
| Get-ServerSetting | Server | `/[SETTINGSURL]` | Get Server settings from admin endpoint |
| Get-ServerToken | Server | `[ADMIN]/generateToken` | Generate token for ArcGIS Server |
| Get-ServerUsageReport | Server | `[ADMIN]/usagereports/[REPORTNAME]` | Return individual or all usage reports |
| Get-ServerUsageReportData | Server | `[ADMIN]/usagereports/[REPORTNAME]/data` | Gets the report data for a usage report |
| Grant-PortalUserItemAccess | Portal | `[ROOT]/content/users/[USERNAME]/shareItems` | Share Portal item |
| Import-PortalGroupItem | Portal | `[ROOT]/community/groups/[GROUPID]/import` |  |
| Invoke-PortalItemAnalysis | Portal | `[ROOT]/content/features/analyze` | Analyze file prior to publishing |
| Invoke-ServerHostedFeatureQuery | Server | `[ROOT]/Hosted/[SERVICENAME]/FeatureServer/[LAYERID]/query` | Query feature service layer. Additional options available |
| Move-PortalUserItem | Portal | `[ROOT]/content/users/[USERNAME]/moveItems` | Move Portal item to folder |
| New-PortalHostedFeatureService | Portal | `[ROOT]/content/users/[USERNAME]/createService` | Creates new Hosted Feature Service |
| New-PortalRole | Portal | `[ROOT]/portals/[PORTALID]/createRole` | Create new Role in Portal for ArcGIS |
| New-PortalUser | Portal | `[ADMIN]/security/users/createUser` | Create new Portal user |
| New-PortalUserFolder | Portal | `[ROOT]/content/users/[USERNAME]/createFolder` | Creates new folder in Portal |
| New-PortalUserGroup | Portal | `[ROOT]/community/createGroup` | Create new Portal user group |
| New-ServerFolder | Server | `[ADMIN]/services/createFolder` | Create a new folder in ArcGIS Server |
| New-ServerHostedFeatureTable | Server | `[RADMIN]/services/Hosted/[SERVICENAME]/FeatureServer/addToDefinition` | Creates table as a layer in Hosted Feature Service |
| Publish-PortalCsvItemAsTable | Portal | `[ROOT]/content/users/[USERNAME]/publish` | Publish CSV item (Portal item) as Hosted Table. Additional options available |
| Publish-PortalDataStoreLayer | Portal | `[ROOT]portals/[PORTALID]/datastores/allDatasets/publishLayers` | Publish on map layer and one feature layer from dataset in DataStore |
| Remove-PortalCategorySchema | Portal | `[ROOT]/portals/[PORTALID]/deleteCategorySchema` | Removes the category schema set for the organization |
| Remove-PortalItem | Portal | `[ROOT]/content/users/[USERNAME]/items/[ITEMID]/delete` | Deletes Portal item (e.g., Hosted Feature Service) |
| Remove-PortalRole | Portal | `[ROOT]/portals/[PORTALID]/roles/[ROLEID]/delete` | Remove Role in Portal for ArcGIS |
| Remove-PortalUser | Portal | `[ROOT]/sharing/rest/portals/[PORTALID]/removeUsers` | Deletes Portal user |
| Remove-PortalUserFromGroup | Portal | `[ROOT]/community/groups/[GROUPID]/removeUsers` | Remove Portal user from group |
| Remove-PortalUserGroup | Portal | `[ROOT]/community/groups/[GROUPID]/delete` | Delete Portal user group |
| Remove-ServerFolder | Server | `[ADMIN]/services/[FOLDERNAME]/deleteFolder` | Deletes folder in ArcGIS Server and all services in folder |
| Remove-ServerService | Server | `[ADMIN]/services/deleteServices` | Deletes ArcGIS Server Service |
| Remove-ServerServiceLayer | Server | `[RADMIN]/services/Hosted/[SERVICENAME]/FeatureServer/deleteFromDefinition` | Deletes table/layer from ArcGIS Server Service |
| Remove-ServerUsageReport | Server | `[ADMIN]/usagereports/[REPORTNAME]/delete` | Deletes a Server usage report |
| Revoke-PortalUserItemAccess | Portal | `[ROOT]/content/users/[USERNAME]/unshareItems` | Unshare Portal item |
| Set-PortalAllowedOrigins | Portal | `[ROOT]/portals/[PORTALID]/update` | Set the allowed origins property for Portal |
| Set-PortalCategorySchema | Portal | `[ROOT]/portals/[PORTALID]/assignCategorySchema` | Write ArcGIS Portal category schema to Enterprise |
| Set-PortalDefaultUserLicenseType | Portal | `[ROOT]/portals/[PORTALID]/setUserDefaultSettings` | Set the default User License Type in Portal |
| Set-PortalDefaultUserRole | Portal | `[ROOT]/portals/[PORTALID]/setUserDefaultSettings` | Set the default User Role in Portal |
| Set-PortalProxyHosts | Portal | `[ADMIN]/security/config/update` | Set Portal security configuration |
| Set-PortalPublicSharing | Portal | `[ROOT]/portals/[PORTALID]/update` | Set the Public Sharing setting of Portal for ArcGIS |
| Set-PortalRolePrivilege | Portal | `[ROOT]/portals/[PORTALID]` | Set privilege for Portal for ArcGIS Role |
| Set-PortalUserPassword | Portal | `[ROOT]/community/users/[USERNAME]/update` | Set password for Portal user |
| Set-PortalUserProfileEditing | Portal | `[ROOT]/portals/[PORTALID]/update` | Set the User Profile Editing setting of Portal for ArcGIS |
| Set-ServerAllowedOrigins | Server | `[ADMIN]/system/handlers/rest/servicesdirectory` | Set ArcGIS Server allowed origins |
| Set-ServerPSAPassword | Server | `[ADMIN]/security/psa/update` | Set ArcGIS Server PSA Account |
| Test-PortalDataStore | Portal | `[ROOT]/portals/[PORTALID]/datastores/validate` | Validates Data Store connection |
| Test-PortalDataStore | Portal | `[ROOT]/sharing/rest/portals/[PORTALID]/datastores/validate` | Validates connection between Data Store and ArcGIS Server |
| Test-PortalFederation | Portal | `[ADMIN]/federation/servers/validate` | Validate Portal federation status |
| Test-ServerHealth | Server | `/rest/info/healthCheck` | Validates ArcGIS Server health |
| Update-PortalItem | Portal | `[ROOT]/content/users/[USERNAME]/items/[ITEMID]/update` | Updates Portal item (e.g., layer, etc.) |
| Update-PortalUser | Portal | `[ROOT]/community/users/[USERNAME]/update` | Update Portal user properties |
| Write-PortalUserItem | Portal | `[ROOT]/content/users/[USERNAME]/addItem` | Uploads a Portal item (file item) |

## Potential Future Functions

| API Endpoint | Description | Link |
| ------------ | ----------- | ---- |
| `updateDefinition` | Update schema | [developer guide](https://developers.arcgis.com/rest/services-reference/online/update-definition-feature-layer-.htm) |

- Add new Server Hosted Feature Layer (point/polygon/line)

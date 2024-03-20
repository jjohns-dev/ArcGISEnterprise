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
| Portal | root | `/sharing/rest` |
| Server | root | `/rest/services` |
| Server | admin | `/rest/admin` |

### API Endpoints

| Function | Component | API Endpoint | Description |
| -------- | --------- | ------------ | ----------- |
| Add-ServerHostedFeatureServiceRecord | Server | `[root]/Hosted/[SERVICENAME]/FeatureServer/[LAYERID]/addFeatures` | Appends data to table in Hosted Feature Service |
| Clear-ServerHostedFeatureService | Server | `[root]/Hosted/[SERVICENAME]/FeatureServer/[LAYERID]/deleteFeatures` | Truncates table data in Hosted Feature Service |
| Edit-ServerHostedFeatureRecord | Server | `[root]/Hosted/[SERVICENAME]/FeatureServer/[LAYERID]/applyEdits` | Adds, updates, or deletes features/records from a table layer |
| Get-PortalDataStoreServer | Portal | `[root]/portals/[PORTALID]/datastores/getServers` | Get server object for Portal DataStore item |
| Get-PortalJobStatus | Portal | `[root]/content/users/[USERNAME]/items/[ITEMID]/status` | Get Portal job status |
| Get-PortalUserFolderList | Portal | `[root]/content/users/[USERNAME]` | Gets list of folders owned by user in Portal |
| Get-PortalUserGroupList | Portal | `[root]/community/groups` | Search for groups owned by specified user. Additional options available |
| Get-PortalUserItemList | Portal | `[root]/search` | Search Portal. Additional options available |
| Get-ServerHostedFeatureService | Server | `[root]/Hosted/[SERVICENAME]/FeatureServer` | Gets Hosted Feature Service |
| Invoke-PortalItemAnalysis | Portal | `[root]/content/features/analyze` | Analyze file prior to publishing |
| Invoke-ServerHostedFeatureQuery | Server | `[root]/Hosted/[SERVICENAME]/FeatureServer/[LAYERID]/query` | Query feature service layer. Additional options available |
| Move-PortalUserItem | Portal | `[root]/content/users/[USERNAME]/moveItems` | Move Portal item to folder |
| New-PortalHostedFeatureService | Portal | `[root]/content/users/[USERNAME]/createService` | Creates new Hosted Feature Service |
| New-PortalUserFolder | Portal | `[root]/content/users/[USERNAME]/createFolder` | Creates new folder in Portal |
| New-ServerHostedFeatureTable | Server | `[admin]/services/Hosted/[SERVICENAME]/FeatureServer/addToDefinition` | Creates table as a layer in Hosted Feature Service |
| Publish-PortalCsvItemAsTable | Portal | `[root]/content/users/[USERNAME]/publish` | Publish CSV item (Portal item) as Hosted Table. Additional options available |
| Remove-PortalItem | Portal | `[root]/content/users/[USERNAME]/items/[ITEMID]/delete` | Deletes Portal item (e.g., Hosted Feature Service) |
| Remove-ServerService | Server | `/admin/services/deleteServices` | Deletes ArcGIS Server Service |
| Remove-ServerServiceLayer | Server | `[admin]/services/Hosted/[SERVICENAME]/FeatureServer/deleteFromDefinition` | Deletes table/layer from ArcGIS Server Service |
| Write-PortalUserItem | Portal | `[root]/content/users/[USERNAME]/addItem` | Uploads a Portal item (file item) |

## Potential Future Functions

| API Endpoint | Description | Link |
| ------------ | ----------- | ---- |
| `updateDefinition` | Update schema | [developer guide](https://developers.arcgis.com/rest/services-reference/online/update-definition-feature-layer-.htm) |

- Add new Server Hosted Feature Layer (point/polygon/line)

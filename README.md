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

| Function | API Endpoint | Description |
| -------- | ------------ | ----------- |
| Add-PortalHostedFeatureServiceRecord | `/addFeatures` | Appends data to table in Hosted Feature Service |
| Clear-PortalHostedFeatureService | `/deleteFeatures` | Truncates table data in Hosted Feature Service |
| Get-ServerHostedFeatureService | `/FeatureServer` | Gets Hosted Feature Service |
| New-PortalHostedFeatureService | `/createService` | Creates new Hosted Feature Service |
| New-ServerHostedFeatureTable | `/addToDefinition` | Creates table as a layer in Hosted Feature Service |
| Remove-PortalItem | `/delete` | Deletes Portal item (e.g., Hosted Feature Service) |
| Remove-ServerService | `/deleteServices` | Deletes ArcGIS Server Service |
| Remove-ServerServiceLayer | `/deleteFromDefinition` | Deletes table/layer from ArcGIS Server Service |
|  | `` |  |

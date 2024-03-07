# ==============================================================================
# Filename: ArcGISEnterprise.psm1
# Updated:  2023-10-05
# Author:   Justin Johns
# ==============================================================================

# IMPORT ALL FUNCTIONS
foreach ( $directory in @('Public', 'Private') ) {
    foreach ( $fn in (Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1") ) { . $fn.FullName }
}

# VARIABLES
# NOT VALIDATING CONTEXT URL STRUCTURE AS THIS IS DONE BY [SYSTEM.URI] OBJECT
# ONLY VALIDATE URI DOES NOT END WITH FORWARD SLASH. OLD REGEX: '^https?://[\w\/\.:-]+[^/]$'
New-Variable -Name 'context_regex' -Option Constant -Value '^.+[^/]$'
New-Variable -Name 'token_regex' -Option Constant -Value '^[\w\.=-]+$'

# FUNCTION VARIALBLES
New-Variable -Name 'NewHostedServiceTemplate' -Value @'
{
    "name": "ApiTestService",
    "serviceDescription": "This is the service description from the JSON template.",
    "hasStaticData": false,
    "maxRecordCount": 1000,
    "supportedQueryFormats": "JSON",
    "capabilities": "Create,Delete,Query,Update,Editing",
    "description": "This is the description from the JSON template.",
    "copyrightText": "This is the copyright text from the JSON template.",
    "spatialReference": {
        "wkid": 102100,
        "latestWkid": 3857
    },
    "initialExtent": {
        "xmin": -20037507.0671618,
        "ymin": -30240971.9583862,
        "xmax": 20037507.0671618,
        "ymax": 18398924.324645,
        "spatialReference": {
            "wkid": 102100,
            "latestWkid": 3857
        }
    },
    "allowGeometryUpdates": false,
    "units": "esriMeters"
}
'@

# EXPORT MEMBERS
# THESE ARE SPECIFIED IN THE MODULE MANIFEST AND THEREFORE DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
#Export-ModuleMember -Variable *
#Export-ModuleMember -Alias *
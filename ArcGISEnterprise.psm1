# ==============================================================================
# Filename: ArcGISEnterprise.psm1
# Updated:  2024-03-07
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
New-Variable -Name 'TableFieldTypes' -Option Constant -Value @{
    oid    = @{ type = 'esriFieldTypeOID'; modelName = 'OBJECTID'; sqlType = 'sqlTypeInteger' }
    string = @{ type = 'esriFieldTypeString'; modelName = 'type_text'; sqlType = 'sqlTypeVarchar' }
    double = @{ type = 'esriFieldTypeDouble'; modelName = 'type_double'; sqlType = 'sqlTypeNumeric' }
    short  = @{ type = 'esriFieldTypeSmallInteger'; modelName = 'type_int_short'; sqlType = 'sqlTypeSmallInt' }
    long   = @{ type = 'esriFieldTypeInteger'; modelName = 'type_int_long'; sqlType = 'sqlTypeInteger' }
    float  = @{ type = 'esriFieldTypeDouble'; modelName = 'type_float'; sqlType = 'sqlTypeNumeric' }
    date   = @{ type = 'esriFieldTypeDate'; modelName = 'type_date'; sqlType = 'sqlTypeTimestamp' }
    guid   = @{ type = 'esriFieldTypeGUID'; modelName = 'type_guid'; sqlType = 'sqlTypeVarchar' }
    blob   = @{ type = 'esriFieldTypeBlob'; modelName = 'type_blob'; sqlType = 'sqlTypeBinary' }
}
New-Variable -Name 'NewHostedServiceTemplate' -Value '{"name":"ApiTestService","serviceDescription":"This is the service description from the JSON template.","hasStaticData":false,"maxRecordCount":1000,"supportedQueryFormats":"JSON","capabilities":"Create,Delete,Query,Update,Editing","description":"This is the description from the JSON template.","copyrightText":"This is the copyright text from the JSON template.","spatialReference":{"wkid":102100,"latestWkid":3857},"initialExtent":{"xmin":-20037507.0671618,"ymin":-30240971.9583862,"xmax":20037507.0671618,"ymax":18398924.324645,"spatialReference":{"wkid":102100,"latestWkid":3857}},"allowGeometryUpdates":false,"units":"esriMeters"}'
New-Variable -Name 'NewHostedTableTemplate' -Value '{"layers":[{"fields":[{"nullable":false,"defaultValue":null,"editable":false,"length":4,"type":"esriFieldTypeOID","modelName":"OBJECTID","sqlType":"sqlTypeInteger","domain":null,"name":"objectid","alias":"OBJECTID"},{"modelName":"type_text","sqlType":"sqlTypeVarchar","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_text","length":100,"alias":"TYPE_TEXT","type":"esriFieldTypeString"},{"modelName":"type_double","sqlType":"sqlTypeNumeric","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_double","length":38,"alias":"TYPE_DOUBLE","type":"esriFieldTypeDouble"},{"modelName":"type_int_short","sqlType":"sqlTypeSmallInt","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_int_short","length":5,"alias":"TYPE_INT_SHORT","type":"esriFieldTypeSmallInteger"},{"modelName":"type_int_long","sqlType":"sqlTypeInteger","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_int_long","length":10,"alias":"TYPE_INT_LONG","type":"esriFieldTypeInteger"},{"modelName":"type_float","sqlType":"sqlTypeNumeric","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_float","length":38,"alias":"TYPE_FLOAT","type":"esriFieldTypeDouble"},{"modelName":"type_date","sqlType":"sqlTypeTimestamp","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_date","length":29,"alias":"TYPE_DATE","type":"esriFieldTypeDate"},{"modelName":"type_guid","sqlType":"sqlTypeVarchar","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_guid","length":38,"alias":"TYPE_GUID","type":"esriFieldTypeGUID"},{"modelName":"type_blob","sqlType":"sqlTypeBinary","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_blob","length":2147483647,"alias":"TYPE_BLOB","type":"esriFieldTypeBlob"}],"name":"DataTable","objectIdField":"objectid","type":"Table"}]}'

# EXPORT MEMBERS
# THESE ARE SPECIFIED IN THE MODULE MANIFEST AND THEREFORE DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
Export-ModuleMember -Variable *
#Export-ModuleMember -Alias *
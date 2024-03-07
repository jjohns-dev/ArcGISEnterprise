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

# EXPORT MEMBERS
# THESE ARE SPECIFIED IN THE MODULE MANIFEST AND THEREFORE DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
#Export-ModuleMember -Variable *
#Export-ModuleMember -Alias *
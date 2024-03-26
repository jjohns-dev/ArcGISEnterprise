# ==============================================================================
# Filename: ArcGISEnterprise.psm1
# Updated:  2024-03-16
# Author:   Justin Johns
# ==============================================================================

# IMPORT ALL FUNCTIONS
foreach ( $directory in @('Public', 'Private') ) {
    foreach ( $fn in (Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1") ) { . $fn.FullName }
}

# VARIABLES
# NOT VALIDATING CONTEXT URL STRUCTURE AS THIS IS DONE BY [SYSTEM.URI] OBJECT
# ONLY VALIDATE URI DOES NOT END WITH FORWARD SLASH. OLD REGEX: '^https?://[\w\/\.:-]+[^/]$'
New-Variable -Name 'context_regex' -Option Constant -Value '^https?://.+[^/]$'
New-Variable -Name 'token_regex' -Option Constant -Value '^[\w\.=-]+$'
New-Variable -Name 'ModulePrivate' -Option Constant -Value "$PSScriptRoot\Private"

# EXPORT MEMBERS
# FUNCTIONS ARE SPECIFIED IN THE MODULE MANIFEST AND DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
Export-ModuleMember -Variable * -Alias *
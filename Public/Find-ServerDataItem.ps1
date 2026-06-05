function Find-ServerDataItem {
    <#
    .SYNOPSIS
        Find data items
    .DESCRIPTION
        Searches through the various data items registered in the server's data store and returns a list of items
        found at a specified location. This list of items is dynamic, as the results can be find tuned to return
        items with a certain item type or item ID. At least one of the parameters below must be defined for this
        operation to run successfully.
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Enterprise token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .PARAMETER ItemType
        Item type (e.g., BigDataFileShare, CloudStore, EnterpriseDatabase, NoSQLDatabase, RasterStore, FileShare)
    .PARAMETER ItemId
        Item ID
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Find-ServerDataItem -ItemType NoSQLDatabase
        Returns all NoSQLDatabase data items registered with the Server's data store.
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/finddataitems/
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Item type')]
        [ValidateSet('BigDataFileShare', 'CloudStore', 'EnterpriseDatabase', 'FileShare', 'NoSQLDatabase', 'RasterStore')]
        [System.String] $ItemType,

        [Parameter(Mandatory = $false, HelpMessage = 'Item ID')]
        [ValidatePattern('^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$')] # f4d7549a-c603-4a2b-a2e6-9727bbc7e9c4
        [System.String] $ItemId,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Server context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Enterprise token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(Mandatory = $false, HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/admin/data/findItems' -f $Context
            Method = 'GET'
            Body   = @{
                f = 'json'
                token = $Token
                parentPath = switch ($ItemType) {
                    'BigDataFileShare'   { '/bigDataFileShares' }
                    'CloudStore'         { '/cloudStores' }
                    'EnterpriseDatabase' { '/enterpriseDatabases' }
                    'FileShare'          { '/fileShares' }
                    'NoSQLDatabase'      { '/nosqlDatabases' }
                    'RasterStore'        { '/rasterStores' }
                }
            }
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
        }

        # ADD ITEM ID IF PROVIDED
        if ($PSBoundParameters.ContainsKey('ItemId')) { $restParams.Body['id'] = $ItemId }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
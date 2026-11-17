function Get-ServerItemLifecycleInfo {
    <#
    .SYNOPSIS
        Get ArcGIS Server item lifecycle information
    .DESCRIPTION
        Get ArcGIS Service item lifecycle information
    .PARAMETER DataItem
        Data item type
    .PARAMETER ChildItem
        Name of child item
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServerItemLifecycleInfo @cmnParams -DataItem 'enterpriseDatabases' -ChildItem 'AGSDataStore'
        Returns the lifecycle info for 'AGSDataStore' child item of type 'enterpriseDatabases'
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/lifecycle-info/
        https://developers.arcgis.com/rest/enterprise-administration/server/dataitem/
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Data item type')]
        [ValidateSet('enterpriseDatabases', 'fileShares', 'nosqlDatabases', 'bigDataFileShares', 'cloudStores', 'rasterStores')]
        [System.String] $DataItem,

        [Parameter(Mandatory = $true, HelpMessage = 'Child item name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ChildItem,

        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Target Server context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/admin/data/items/{1}/{2}/lifecycleinfos' -f $Context, $DataItem, $ChildItem
            Method = 'GET'
            Body    = @{ f = 'json' }
            Headers = @{
                referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority
            }
        }

        # ADD TOKEN IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams['Headers']['X-Esri-Authorization'] = 'Bearer {0}' -f $Token }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
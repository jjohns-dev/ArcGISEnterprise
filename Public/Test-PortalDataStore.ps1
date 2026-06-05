function Test-PortalDataStore {
    <#
    .SYNOPSIS
        Validates Data Store connection
    .DESCRIPTION
        Validates Data Store connection with Portal for ArcGIS
    .PARAMETER ItemId
        Portal item ID of Data Store item
    .PARAMETER ServerId
        ID of the Server where the DataStore is registered
    .PARAMETER PortalId
        Portal application ID
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> $item = Get-PortalUserItemList -UserName 'janedoe@fake.com' @commonParams | Where-Object title -EQ 'test_store_internal'
        PS C:\> $server = Get-PortalDataStoreServer -ItemId $item.id @commonParams
        PS C:\> Test-PortalDataStore -ItemId $item.id -ServerId $server.servers[0].id @commonParams
        Validates the Data Store item named 'test_store_internal' connection to the ArcGIS Server
    .NOTES
        Name:     Test-PortalDataStore
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-21
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/validate-datastore.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal item ID of Data Store item')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $ItemId,

        [Parameter(Mandatory = $true, HelpMessage = 'ID of the Server where the DataStore is registered')]
        [ValidatePattern('[a-z0-9]{16}')]
        [System.String] $ServerId,

        [Parameter(HelpMessage = 'Portal application ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF',

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/portals/{1}/datastores/validate' -f $Context, $PortalId
            Method = 'POST'
            Body   = @{
                f           = 'json'
                token       = $Token
                datastoreId = $ItemId
                serverId    = $ServerId
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE GETSERVERS
        Invoke-RestMethod @restParams
    }
}
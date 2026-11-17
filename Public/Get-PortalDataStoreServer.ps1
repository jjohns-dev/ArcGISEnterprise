function Get-PortalDataStoreServer {
    <#
    .SYNOPSIS
        Get server object for Portal DataStore item
    .DESCRIPTION
        Get server object for Portal DataStore item
    .PARAMETER ItemId
        Portal item ID of Data Store item
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
        PS C:\> Get-PortalDataStoreServer -ItemId $itemId @commonParams
        Returns an array of Servers where the DataStore item ID is registered
    .NOTES
        Status: Stable
        Comments: No public documentation available for this endpoint.
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal item ID of Data Store item')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $ItemId,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal application ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF',

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal token')]
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
            Uri    = '{0}/sharing/rest/portals/{1}/datastores/getServers' -f $Context, $PortalId
            Method = 'GET'
            Headers = @{ 'X-Esri-Authorization' = 'Bearer {0}' -f $Token }
            Body   = @{
                f           = 'json'
                datastoreId = $ItemId
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE GETSERVERS
        Invoke-RestMethod @restParams
    }
}
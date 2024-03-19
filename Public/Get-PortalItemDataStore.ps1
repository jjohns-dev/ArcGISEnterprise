function Get-PortalItemDataStore {
    <# =========================================================================
    .SYNOPSIS
        Get server object for Portal DataStore item
    .DESCRIPTION
        Get server object for Portal DataStore item
    .PARAMETER ItemId
        Portal item ID
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
        PS C:\> Get-PortalItemDataStore -ItemId $itemId @commonParams
        Returns an array of Servers where the DataStore item ID is registered
    .NOTES
        Name:     Get-PortalItemDataStore
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-19
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = '_itid', HelpMessage = 'Id of previously uploaded Portal item')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $ItemId,

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
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/portals/{1}/datastores/getServers' -f $Context, $PortalId
            Method = 'POST'
            Body   = @{
                f           = 'json'
                token       = $Token
                datastoreId = $ItemId
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE GETSERVERS
        Invoke-RestMethod @restParams
    }
}
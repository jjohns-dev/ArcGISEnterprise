function Get-PortalApiKeyCredential {
    <#
    .SYNOPSIS
        Get Portal API key credentials
    .DESCRIPTION
        Get API key credentials items with the state and expiration of each API key slot.
        With -ItemId, returns that item. Without -ItemId, returns every API key credentials
        item owned by -UserName (default: the user associated with the token). Slot
        expirations are returned only for active slots, because Portal keeps the last
        expiration on a slot after its key is revoked.
    .PARAMETER ItemId
        API key credentials item ID
    .PARAMETER UserName
        Owner of the API key credentials. Defaults to the item owner with -ItemId, otherwise
        to the user associated with the token
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        System.String.
    .OUTPUTS
        System.Management.Automation.PSCustomObject.
    .EXAMPLE
        PS C:\> Get-PortalApiKeyCredential -ItemId '0123456789abcdef0123456789abcdef' @commonParams
        Returns the API key credentials item, including whether each key slot is active and when it expires
    .EXAMPLE
        PS C:\> Get-PortalApiKeyCredential -UserName 'jsmith' @commonParams
        Returns all API key credentials items owned by jsmith
    .NOTES
        Status: Stable
        Comments: Requires ArcGIS Enterprise 11.4 or later. Verified on 11.5; an administrator
        token can read credentials owned by other users.
        https://developers.arcgis.com/rest/users-groups-and-items/registered-app-info.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(ValueFromPipelineByPropertyName, HelpMessage = 'API key credentials item ID')]
        [ValidatePattern('^[a-f0-9]{32}$')]
        [System.String] $ItemId,

        [Parameter(HelpMessage = 'Owner of the API key credentials')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)

        $commonParams = @{ Context = $Context; Token = $Token }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $commonParams['SkipCertificateCheck'] = $true }
    }
    Process {
        if ($PSBoundParameters.ContainsKey('ItemId')) {
            $item = Get-PortalItem -ItemId $ItemId @commonParams
            if ($item.error) {
                Write-Error -Message ('Unable to get item [{0}]: {1} {2}' -f $ItemId, $item.error.code, $item.error.message) -ErrorAction Stop
            }
            if ($item.type -ne 'Application' -or $item.typeKeywords -notcontains 'APIToken') {
                Write-Error -Message ('Item [{0}] is not an API key credentials item.' -f $ItemId) -ErrorAction Stop
            }
            $owner = if ($PSBoundParameters.ContainsKey('UserName')) { $UserName } else { $item.owner }
            $items = @($item)
        }
        else {
            $owner = if ($PSBoundParameters.ContainsKey('UserName')) { $UserName } else { Resolve-PortalUserName @commonParams }
            $found = Find-PortalItem -Owner $owner -Type 'Application' @commonParams
            $searchError = @($found).Where({ $null -ne $_.error }, 'First')
            if ($searchError) {
                Write-Error -Message ('Unable to search items for [{0}]: {1} {2}' -f $owner, $searchError.error.code, $searchError.error.message) -ErrorAction Stop
            }
            $items = @($found).Where({ $_.typeKeywords -contains 'APIToken' })
            Write-Verbose -Message ('Found [{0}] API key credentials item(s) for [{1}]' -f $items.Count, $owner)
        }

        foreach ($i in $items) {
            $app = Get-PortalRegisteredAppInfo -ItemId $i.id -UserName $owner @commonParams

            # INACTIVE SLOTS KEEP A STALE EXPIRATION, SO ONLY ACTIVE SLOTS REPORT ONE
            $slot1Expires = if ($app.apiToken1Active -and $i.apiToken1ExpirationDate -gt 0) { ConvertFrom-Epoch -Milliseconds $i.apiToken1ExpirationDate }
            $slot2Expires = if ($app.apiToken2Active -and $i.apiToken2ExpirationDate -gt 0) { ConvertFrom-Epoch -Milliseconds $i.apiToken2ExpirationDate }

            [PSCustomObject] @{
                PSTypeName    = 'ArcGISEnterprise.ApiKeyCredential'
                ItemId        = $i.id
                Title         = $i.title
                Owner         = $i.owner
                ClientId      = $app.client_id
                Privileges    = $app.privileges
                HttpReferrers = $app.httpReferrers
                Slot1Active   = [System.Boolean] $app.apiToken1Active
                Slot1Expires  = $slot1Expires
                Slot2Active   = [System.Boolean] $app.apiToken2Active
                Slot2Expires  = $slot2Expires
            }
        }
    }
    Clean {
        Remove-Variable -Name 'app' -Force -ErrorAction Ignore
    }
}

function Revoke-PortalApiKey {
    <#
    .SYNOPSIS
        Revoke a Portal API key
    .DESCRIPTION
        Invalidate the API key in slot 1 or 2 of an API key credentials item. The key stops
        working immediately. If the slot is not active, a warning is written and no request
        is made.
    .PARAMETER ItemId
        API key credentials item ID
    .PARAMETER Slot
        API key slot (1 or 2)
    .PARAMETER UserName
        Owner of the API key credentials. Defaults to the item owner
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        System.String.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Revoke-PortalApiKey -ItemId '0123456789abcdef0123456789abcdef' -Slot 1 @commonParams
        Invalidates the API key in slot 1
    .EXAMPLE
        PS C:\> Get-PortalApiKeyCredential -ItemId $itemId @commonParams | Revoke-PortalApiKey -Slot 1 -Confirm:$false @commonParams
        Invalidates the API key in slot 1 without prompting, for use in automation
    .NOTES
        Status: Stable
        Comments: Requires ArcGIS Enterprise 11.4 or later. Verified on 11.5; an administrator
        token can manage credentials owned by other users. The apiToken and regenerateApiToken
        parameters of oauth2/revokeToken are not in the REST API reference; they follow Esri's
        ArcGIS REST JS developer-credentials package.
        https://developers.arcgis.com/arcgis-rest-js/api-reference/arcgis-rest-developer-credentials/invalidateApiKey/
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([System.Void])]
    Param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, HelpMessage = 'API key credentials item ID')]
        [ValidatePattern('^[a-f0-9]{32}$')]
        [System.String] $ItemId,

        [Parameter(Mandatory, HelpMessage = 'API key slot (1 or 2)')]
        [ValidateSet(1, 2)]
        [System.Int32] $Slot,

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
        $credentialParams = @{ ItemId = $ItemId }
        if ($PSBoundParameters.ContainsKey('UserName')) { $credentialParams['UserName'] = $UserName }
        $credential = Get-PortalApiKeyCredential @credentialParams @commonParams
        $owner = if ($PSBoundParameters.ContainsKey('UserName')) { $UserName } else { $credential.Owner }

        $slotActive = if ($Slot -eq 1) { $credential.Slot1Active } else { $credential.Slot2Active }
        if (-not $slotActive) {
            Write-Warning -Message ('Slot {0} of [{1}] is not active; nothing to revoke.' -f $Slot, $ItemId)
            return
        }

        if (-not $PSCmdlet.ShouldProcess(('{0} ({1})' -f $credential.Title, $ItemId), ('Revoke API key in slot {0}' -f $Slot))) { return }

        $app = Get-PortalRegisteredAppInfo -ItemId $ItemId -UserName $owner @commonParams
        $revokeParams = @{
            Uri    = '{0}/sharing/rest/oauth2/revokeToken' -f $Context
            Method = 'POST'
            Body   = @{
                f                  = 'json'
                client_id          = $app.client_id
                client_secret      = $app.client_secret
                grant_type         = 'client_credentials'
                apiToken           = $Slot
                regenerateApiToken = 'true'
            }
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $revokeParams['SkipCertificateCheck'] = $true }
        $response = Invoke-RestMethod @revokeParams

        if (-not $response.success) {
            Write-Error -Message ('Unable to revoke the API key in slot {0}: {1} {2}' -f $Slot, $response.error.code, $response.error.message) -ErrorAction Stop
        }
        Write-Verbose -Message ('Revoked the API key in slot {0} of [{1}]' -f $Slot, $ItemId)
    }
    Clean {
        Remove-Variable -Name 'app', 'revokeParams' -Force -ErrorAction Ignore
    }
}

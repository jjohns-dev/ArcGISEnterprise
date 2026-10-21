function New-PortalApiKey {
    <#
    .SYNOPSIS
        Generate a Portal API key
    .DESCRIPTION
        Generate an API key in slot 1 or 2 of an API key credentials item. The slot's
        expiration is set on the item first, because the new key's lifetime follows it.
        Regenerating an active slot invalidates the key currently in that slot. If
        generation fails, the active slot's previous expiration is restored. The key is
        returned as a SecureString and can only be retrieved at generation time. The
        SecureString only guards against the key being displayed or logged by accident; it
        is not encrypted in memory on Linux or macOS.
    .PARAMETER ItemId
        API key credentials item ID
    .PARAMETER Slot
        API key slot (1 or 2)
    .PARAMETER Expiration
        Expiration date of the new API key; must be in the future and no more than one year out
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
        PS C:\> New-PortalApiKey -ItemId '0123456789abcdef0123456789abcdef' -Slot 2 -Expiration (Get-Date).AddDays(90) @commonParams
        Generates an API key in slot 2 that expires in 90 days
    .EXAMPLE
        PS C:\> $newKey = Get-PortalApiKeyCredential -ItemId $itemId @commonParams | New-PortalApiKey -Slot 2 -Expiration (Get-Date).AddDays(90) -Confirm:$false @commonParams
        Generates a key without prompting, for use in automation
    .NOTES
        Status: Stable
        Comments: Requires ArcGIS Enterprise 11.4 or later. Verified on 11.5; an administrator
        token can manage credentials owned by other users. The apiToken and regenerateApiToken
        parameters of oauth2/token are not in the REST API reference; they follow Esri's
        ArcGIS REST JS developer-credentials package.
        https://developers.arcgis.com/rest/users-groups-and-items/token.htm
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, HelpMessage = 'API key credentials item ID')]
        [ValidatePattern('^[a-f0-9]{32}$')]
        [System.String] $ItemId,

        [Parameter(Mandatory, HelpMessage = 'API key slot (1 or 2)')]
        [ValidateSet(1, 2)]
        [System.Int32] $Slot,

        [Parameter(Mandatory, HelpMessage = 'Expiration date of the new API key')]
        [System.DateTime] $Expiration,

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
        if ($SkipCertificateCheck) { $commonParams['SkipCertificateCheck'] = $true }
    }
    Process {
        $now = Get-Date
        if ($Expiration -le $now) {
            Write-Error -Message 'Expiration must be in the future.' -ErrorAction Stop
        }
        if ($Expiration -gt $now.AddYears(1)) {
            Write-Error -Message 'Expiration must be no more than one year from now.' -ErrorAction Stop
        }

        $credential = Get-PortalApiKeyCredential -ItemId $ItemId @commonParams
        $owner = $credential.Owner

        $slotActive = if ($Slot -eq 1) { $credential.Slot1Active } else { $credential.Slot2Active }
        $previousExpires = if ($Slot -eq 1) { $credential.Slot1Expires } else { $credential.Slot2Expires }
        $action = if ($slotActive) {
            'Regenerate API key in slot {0}; the key currently in slot {0} will stop working' -f $Slot
        }
        else {
            'Generate API key in slot {0}' -f $Slot
        }
        if (-not $PSCmdlet.ShouldProcess(('{0} ({1})' -f $credential.Title, $ItemId), $action)) { return }

        # THE KEY'S LIFETIME FOLLOWS THE SLOT EXPIRATION SET BEFORE GENERATION
        $expirationMs = [System.DateTimeOffset]::new($Expiration).ToUnixTimeMilliseconds()
        $updateParams = @{
            Uri    = '{0}/sharing/rest/content/users/{1}/items/{2}/update' -f $Context, $owner, $ItemId
            Method = 'POST'
            Body   = @{ f = 'json'; token = $Token; ('apiToken{0}ExpirationDate' -f $Slot) = $expirationMs }
        }
        if ($SkipCertificateCheck) { $updateParams['SkipCertificateCheck'] = $true }
        $update = Invoke-RestMethod @updateParams
        if (-not $update.success) {
            Write-Error -Message ('Unable to set the expiration of slot {0}: {1} {2}' -f $Slot, $update.error.code, $update.error.message) -ErrorAction Stop
        }

        try {
            $app = Get-PortalRegisteredAppInfo -ItemId $ItemId -UserName $owner @commonParams
            $tokenParams = @{
                Uri    = '{0}/sharing/rest/oauth2/token' -f $Context
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
            if ($SkipCertificateCheck) { $tokenParams['SkipCertificateCheck'] = $true }
            $response = Invoke-RestMethod @tokenParams
            if ($response.error) {
                Write-Error -Message ('Unable to generate an API key in slot {0}: {1} {2}' -f $Slot, $response.error.code, $response.error.message) -ErrorAction Stop
            }
        }
        catch {
            $generateError = $_
            # THE EXISTING KEY STILL WORKS, SO THE ITEM SHOULD KEEP SHOWING ITS EXPIRATION
            if ($slotActive -and $previousExpires) {
                $restoreParams = $updateParams.Clone()
                $restoreParams['Body'] = @{ f = 'json'; token = $Token; ('apiToken{0}ExpirationDate' -f $Slot) = [System.DateTimeOffset]::new($previousExpires).ToUnixTimeMilliseconds() }
                try {
                    $restore = Invoke-RestMethod @restoreParams
                    if (-not $restore.success) { throw ('{0} {1}' -f $restore.error.code, $restore.error.message) }
                }
                catch {
                    Write-Warning -Message ('Unable to restore the previous expiration of slot {0} ({1}): {2}' -f $Slot, $previousExpires, $_)
                }
            } $generateError
            throw
        }

        # THE SLOT NUMBER IS ENCODED 10 CHARACTERS FROM THE END OF THE KEY
        $key = $response.access_token
        if (-not $key -or $key.Length -lt 10 -or $key.Substring($key.Length - 10, 1) -ne [System.String] $Slot) {
            Write-Error -Message ('Portal did not return a key for slot {0}.' -f $Slot) -ErrorAction Stop
        }

        [PSCustomObject] @{
            PSTypeName = 'ArcGISEnterprise.ApiKey'
            ItemId     = $ItemId
            Slot       = $Slot
            Expires    = ConvertFrom-Epoch -Milliseconds $expirationMs
            ApiKey     = ConvertTo-SecureString -String $key -AsPlainText -Force
        }
    }
    Clean {
        Remove-Variable -Name 'app', 'tokenParams', 'response', 'key' -Force -ErrorAction Ignore
    }
}

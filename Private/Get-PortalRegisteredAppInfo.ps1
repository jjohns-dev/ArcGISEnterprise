function Get-PortalRegisteredAppInfo {
    <#
    .SYNOPSIS
        Get registered app info for a Portal item
    .DESCRIPTION
        Returns the raw registeredAppInfo response for an application item, including
        client_secret. Module-internal only: callers must never output client_secret.
    .PARAMETER ItemId
        Portal item ID
    .PARAMETER UserName
        Owner of the item
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Management.Automation.PSCustomObject.
    .EXAMPLE
        PS C:\> Get-PortalRegisteredAppInfo -ItemId $itemId -UserName 'jsmith' -Context $context -Token $token
        Returns the registered app info for the item
    .NOTES
        Status: Stable
        Comments: Private helper. Verified on ArcGIS Enterprise 11.5; an administrator token
        works for items owned by other users.
        https://developers.arcgis.com/rest/users-groups-and-items/registered-app-info.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Portal item ID')]
        [ValidatePattern('^[a-f0-9]{32}$')]
        [System.String] $ItemId,

        [Parameter(Mandatory, HelpMessage = 'Owner of the item')]
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
    }
    Process {
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/users/{1}/items/{2}/registeredAppInfo' -f $Context, $UserName, $ItemId
            Method = 'POST'
            Body   = @{ f = 'json'; token = $Token }
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        $response = Invoke-RestMethod @restParams

        # PORTAL RETURNS ERRORS IN THE RESPONSE BODY
        if ($response.error) {
            Write-Error -Message ('Unable to get registered app info for item [{0}]: {1} {2}' -f $ItemId, $response.error.code, $response.error.message) -ErrorAction Stop
        }

        $response
    }
}

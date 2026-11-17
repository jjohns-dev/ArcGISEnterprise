function Add-PortalOAuthRedirectURI {
    <#
    .SYNOPSIS
        Add redirect URI to Portal OAuth app
    .DESCRIPTION
        Add redirect URI to Portal OAuth app
    .PARAMETER AppID
        AppID
    .PARAMETER RedirectURI
        Redirect URI
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
        PS C:\> Add-PortalOAuthRedirectURI @commonParams -RedirectURI 'https://mydomain.internal.com'
        Addes the new redirect URI to the app 'arcgisonline'
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/portal/update-app-info.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'AppID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $AppID = 'arcgisonline',

        [Parameter(Mandatory = $true, HelpMessage = 'Redirect URI')]
        [ValidateNotNullOrEmpty()]
        [System.Uri] $RedirectURI,

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
        # SET PARAMETERS
        $restParams = @{
            Uri    = '{0}/portaladmin/security/oauth/getAppInfo' -f $Context
            Method = 'GET'
            Headers = @{ 'X-Esri-Authorization' = 'Bearer {0}' -f $Token }
            Body   = @{ appID = $AppID; f = 'json' }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        $appInfo = Invoke-RestMethod @restParams

        # ADD REDIRECT URI
        $appInfo.redirectURIs += $RedirectURI

        # SET UPDATE PARAMETERS
        $restParams = @{
            Uri    = '{0}/portaladmin/security/oauth/updateAppInfo' -f $Context
            Method = 'POST'
            Body   = @{ appInfo = ($appInfo | ConvertTo-Json -Depth 6 -Compress); f = 'json'; token = $Token }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
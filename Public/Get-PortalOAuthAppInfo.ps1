function Get-PortalOAuthAppInfo {
    <#
    .SYNOPSIS
        Get OAuth App Info
    .DESCRIPTION
        Get OAuth App Info
    .PARAMETER AppID
        AppID
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
        PS C:\> Get-PortalOAuthAppInfo @commonParams
        Gets the information associated with the app 'arcgisonline'
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/portal/get-app-info.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'AppID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $AppID = 'arcgisonline',

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
        Invoke-RestMethod @restParams
    }
}
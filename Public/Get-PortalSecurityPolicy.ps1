function Get-PortalSecurityPolicy {
    <#
    .SYNOPSIS
        Get Portal security policy
    .DESCRIPTION
        Get Portal security policy for user of provided token
    .PARAMETER PortalId
        Portal internal ID
    .PARAMETER Context
        Target Portal context
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-SecurityPolicy -Context 'https://arcgis.com/arcgis' -Token $token
        Get security policy for Portal user
    .NOTES
        Status: Stable
        https://developers.arcgis.com/rest/users-groups-and-items/security-policy.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    [Alias('Get-SecurityPolicy')]
    Param(
        [Parameter(HelpMessage = 'Portal application ID')]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [System.String] $PortalId = '0123456789ABCDEF',

        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/portals/{1}/securityPolicy' -f $Context, $PortalId
            Method = 'GET'
            Headers = @{ 'X-Esri-Authorization' = 'Bearer {0}' -f $Token }
            Body   = @{ f = 'json' }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE GETSERVERS
        Invoke-RestMethod @restParams
    }
}
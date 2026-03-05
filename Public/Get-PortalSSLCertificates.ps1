function Get-PortalSSLCertificates {
    <#
    .SYNOPSIS
        Get Portal SSL certificates
    .DESCRIPTION
        Get Portal SSL certificates
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER Machine
        Portal system to test
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-PortalSSLCertificates -Machine 'myMachine.com' -Context 'https://arcgis.com/arcgis' -Token $token
        Get SSL certificates of Portal system
    .NOTES
        General notes
        https://developers.arcgis.com/rest/enterprise-administration/server/sslcertificates.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(Mandatory, HelpMessage = 'Portal system to test')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Machine,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        $restParams = @{
            Uri    = '{0}/portaladmin/machines/{1}/sslcertificates' -f $Context, $Machine
            Method = 'GET'
            Body   = @{
                f     = 'json'
                token = $Token
            }
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        Invoke-RestMethod @restParams
    }
}
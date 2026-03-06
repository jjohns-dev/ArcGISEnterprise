function Get-PortalSSLCertificate {
    <#
    .SYNOPSIS
        Get Portal SSL certificate
    .DESCRIPTION
        Get Portal SSL certificate information
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER Machine
        Portal system to test
    .PARAMETER Certificate
        SSL certificate name
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-PortalSSLCertificate -Machine 'myMachine.com' -Context 'https://arcgis.com/arcgis' -Token $token -Certificate 'myCertificate'
        Get SSL certificate information for Portal system
    .NOTES
        General notes
        https://developers.arcgis.com/rest/enterprise-administration/server/certificate.htm
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

        [Parameter(Mandatory, HelpMessage = 'SSL certificate name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Certificate,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        $restParams = @{
            Uri    = '{0}/portaladmin/machines/{1}/sslCertificates/{2}' -f $Context, $Machine, $Certificate
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
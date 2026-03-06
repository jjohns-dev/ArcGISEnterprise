function Get-ServerSSLCertificate {
    <#
    .SYNOPSIS
        Get Server SSL certificate
    .DESCRIPTION
        Get Server SSL certificate information
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Server token
    .PARAMETER Machine
        Server system to test
    .PARAMETER Certificate
        SSL certificate name
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServerSSLCertificate -Machine 'myMachine.com' -Context 'https://arcgis.com/arcgis' -Token $token -Certificate 'myCertificate'
        Get SSL certificate information for Server system
    .NOTES
        General notes
        https://developers.arcgis.com/rest/enterprise-administration/server/certificate.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Server context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Server token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(Mandatory, HelpMessage = 'Server system to test')]
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
            Uri    = '{0}/admin/machines/{1}/sslCertificates/{2}' -f $Context, $Machine, $Certificate
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
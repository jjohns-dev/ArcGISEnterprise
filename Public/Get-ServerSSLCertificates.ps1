function Get-ServerSSLCertificates {
    <#
    .SYNOPSIS
        Get Server SSL certificates
    .DESCRIPTION
        Get Server SSL certificates
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Server token
    .PARAMETER Machine
        Server system to test
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServerSSLCertificates -Machine 'myMachine.com' -Context 'https://arcgis.com/arcgis' -Token $token
        Get SSL certificates of Server system
    .NOTES
        General notes
        https://developers.arcgis.com/rest/enterprise-administration/server/sslcertificates.htm
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

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        $restParams = @{
            Uri    = '{0}/admin/machines/{1}/sslcertificates' -f $Context, $Machine
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
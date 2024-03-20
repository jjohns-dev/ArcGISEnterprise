function Get-ServerAdminPSA {
    <#
    .SYNOPSIS
        Get Portal user
    .DESCRIPTION
        Get Portal user
    .PARAMETER Referer
        Portal referer
    .PARAMETER Context
        ArcGIS Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServerAdminPSA -Context 'https://arcgis.com/arcgis' -Token $token
        Get PSA user from Server
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    [Alias('Get-ServerPSA')]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Referer')]
        [System.String] $Referer = 'referer-value',

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri     = '{0}/admin/security/psa' -f $Context
            Method  = 'POST'
            Headers = @{ Referer = $Referer }
            Body    = @{
                f     = 'json'
                token = $Token
            }
        }

        # ADD SKIP CERTIFICATE CHECK
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
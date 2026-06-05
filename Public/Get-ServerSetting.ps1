function Get-ServerSetting {
    <#
    .SYNOPSIS
        Get ArcGIS Server admin setting
    .DESCRIPTION
        Get ArcGIS Server admin setting
    .PARAMETER Context
        Target Portal context
    .PARAMETER SettingUrl
        ArcGIS Server setting URL
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServerSetting -Context https://arcgis.com/arcgis -SettingUrl 'admin/security/tokens'
        Explanation of what the example does
    .NOTES
        Status: Stable
        Comments:
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'ArcGIS Server setting URL')]
        [ValidateNotNullOrEmpty()]
        [System.String] $SettingUrl,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        $restParams = @{
            Uri    = '{0}/{1}' -f $Context, $SettingUrl
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
function Get-PortalUser {
    <#
    .SYNOPSIS
        Get Portal user
    .DESCRIPTION
        Get Portal user
    .PARAMETER Username
        Portal username
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
        PS C:\> Get-PortalUser -Context 'https://arcgis.com/arcgis' -Username 'joe' -Token $token
        Returns user object with username 'joe' from Portal
    .NOTES
        Status: Stable
        https://developers.arcgis.com/rest/users-groups-and-items/user.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal username')]
        [ValidatePattern('^[\w\.@-]+$')]
        [System.String] $Username,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(Mandatory = $false, HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/community/users/{1}' -f $Context, $Username
            Method = 'GET'
            Body    = @{ f = 'json' }
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority; 'X-Esri-Authorization' = 'Bearer {0}' -f $Token }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
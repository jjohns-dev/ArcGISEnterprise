function Get-PortalAllowedOriginList {
    <#
    .DESCRIPTION
        Get the allowed origins configured for ArcGIS Portal
    .PARAMETER Context
        Target Portal context
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> $params = @{ Context = 'https://arcgis.com/arcgis'; Token = $token }
        PS C:\> Get-PortalAllowedOriginList @params
        Gets the allowed origins for ArcGIS Portal
    .NOTES
        Name:     Get-PortalAllowedOriginList
        Author:   Justin Johns
        Version:  0.1.2 | Last Edit: 2024-07-18
        - Version history is capture in repository commit history
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    [Alias('Get-PortalAllowedOrigins')]
    Param(
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
        # GET ALLOWED ORIGINS
        $origins = (Get-PortalSelf @PSBoundParameters).allowedOrigins

        # RETURN ORIGINS OR NULL
        if ($origins.Count -EQ 0) { $null } else { $origins.Split(',') }
    }
}
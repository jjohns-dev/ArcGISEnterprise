function Get-PortalDefaultUserSetting {
    <#
    .SYNOPSIS
        Get default user settings from Portal
    .DESCRIPTION
        Get default user settings from Portal
    .PARAMETER PortalId
        Portal ID
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
        PS C:\> Get-PortalDefaultUserSetting @cParams
        Get the default user settings from Portal
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/user-default-settings.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    [Alias('Get-PortalDefaultUserSettings')]
    Param(
        [Parameter(HelpMessage = 'Portal ID')]
        [ValidateNotNullOrEmpty()]
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
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = ('{0}/sharing/rest/portals/{1}/userDefaultSettings' -f $Context, $PortalId)
            # USING "GET" METHOD RETURNS RAW HTML FOR SOME REASON. "POST" APPEARS TO BE REQUIRED
            Method = 'GET'
            Headers = @{ 'X-Esri-Authorization' = 'Bearer {0}' -f $Token }
            Body   = @{ f = 'json' }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
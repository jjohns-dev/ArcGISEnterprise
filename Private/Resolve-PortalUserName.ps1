function Resolve-PortalUserName {
    <#
    .SYNOPSIS
        Resolve the Portal username for a token
    .DESCRIPTION
        Returns the username of the Portal user associated with a token. Writes a
        terminating error when the token is not associated with a user, such as an
        API key, so the caller can be told to specify a username explicitly.
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Resolve-PortalUserName -Context 'https://arcgis.com/arcgis' -Token $token
        Returns the username associated with $token
    .NOTES
        Status: Stable
        Comments: Private helper. API keys have no associated user in portals/self.
    #>
    [CmdletBinding()]
    [OutputType([System.String])]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        # GET USER PORTAL INFO
        try {
            Write-Verbose -Message 'Getting user settings...'
            $userSettings = Get-PortalSetting -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck -ErrorAction Stop
        }
        catch {
            Write-Error -Message ('Unable to get user info with error: {0}' -f $PSItem.Exception.Message) -ErrorAction Stop
        }

        # PORTAL RETURNS ERRORS SUCH AS AN INVALID TOKEN IN THE RESPONSE BODY
        if ($userSettings.error) {
            Write-Error -Message ('Unable to get user info with error: {0}' -f $userSettings.error.message) -ErrorAction Stop
        }

        if (-not $userSettings.user.username) {
            Write-Error -Message 'Token is not associated with a Portal user (e.g., an API key). Specify -UserName.' -ErrorAction Stop
        }

        $userSettings.user.username
    }
}

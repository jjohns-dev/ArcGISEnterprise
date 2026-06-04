function Get-PortalDefaultUserSettings {
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
        PS C:\> Get-PortalDefaultUserSettings @cParams
        Get the default user settings from Portal
    .NOTES
        Name:     Get-PortalDefaultUserSettings
        Author:   Phillip Glodowski, Justin Johns
        Version:  0.1.1 | Last Edit: 2025-07-22
        Comments: <Comment(s)>
        General notes
        https://developers.arcgis.com/rest/users-groups-and-items/user-default-settings.htm
    #>
    [CmdletBinding()]
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
            Body   = @{ Token = $Token; f = 'json' }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
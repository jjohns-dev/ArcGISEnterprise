function Set-PortalSetting {
    <#
    .SYNOPSIS
        Set Portal setting.
    .DESCRIPTION
        Set or configure setting in Portal for ArcGIS sharing REST API.
    .PARAMETER DisableEditing
        Disable Portal User Profile Editing
    .PARAMETER MaxTokenExpiration
        The maximum validity in minutes of both OAuth and nonOAuth tokens issued for users of the organization.
    .PARAMETER Origin
        Origin to be allowed for Portal
    .PARAMETER SharePublicly
        Share objects publicly
    .PARAMETER PortalId
        Portal application ID
    .PARAMETER Context
        Target Portal context
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Set-PortalSetting @cmnParams -MaxTokenExpiration 1440
        Set the maximum validity in minutes of both OAuth and nonOAuth tokens issued for users of the organization to 1440 minutes (24 hours).
    .EXAMPLE
        PS C:\> Set-PortalSetting @cmnParams -Origin 'https://arcgis.com', 'https://test.com'
        Sets the allowed origins property to 'https://arcgis.com,https://test.com'
    .EXAMPLE
        PS C:\> Set-PortalSetting @cmnParams -SharePublicly $false
        Disables the public sharing of Portal content
    .EXAMPLE
        PS C:\> Set-PortalSetting @cmnParams -DisableEditing $true
        Disables Portal User Profile editing
    .NOTES
        Name:     Set-PortalSetting
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-05-27
        - Version history is captured in repository commit history
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/update.htm
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Share Portal items publicly')]
        [System.Boolean] $DisableEditing,

        [Parameter(Mandatory = $false, HelpMessage = 'The maximum validity in minutes of tokens issued for users.')]
        [ValidateNotNullOrEmpty()]
        [System.Int32] $MaxTokenExpiration,

        [Parameter(Mandatory = $false, HelpMessage = 'Origin to be allowed')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $Origin,

        [Parameter(Mandatory = $false, HelpMessage = 'Share Portal items publicly')]
        [System.Boolean] $SharePublicly,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal application ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF',

        [Parameter(Mandatory = $true, HelpMessage = 'Target Server context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(Mandatory = $false, HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # SET QUERY PARAMETERS
        $restParams = @{
            Uri     = '{0}/sharing/rest/portals/{1}/update' -f $Context, $PortalId
            Method  = 'POST'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
            Body    = @{ f = 'json'; token = $Token }
        }

        # SWITCH ON PARAMETERS
        switch ($PSBoundParameters.Keys) {
            'MaxTokenExpiration' { # Set-PortalMaxTokenExpiration
                $restParams['Body']['maxTokenExpirationMinutes'] = $MaxTokenExpiration
                $shouldProcessMessage = 'Update Portal max token expiration to [{0}] minutes.' -f $MaxTokenExpiration
            }
            'Origin' { # Set-PortalAllowedOrigins
                $restParams['Body']['allowedOrigins'] = ($Origin -join ',')
                $shouldProcessMessage = 'Set Portal allowed origins to: [{0}].' -f ($Origin -join ', ')
            }
            'SharePublicly' { # Set-PortalPublicSharing
                $restParams['Body']['canSharePublic'] = $SharePublicly
                $shouldProcessMessage = 'Set public sharing to [{0}].' -f $SharePublicly
            }
            'DisableEditing' { # Set-PortalUserProfileEditing
                $restParams['Body']['updateUserProfileDisabled'] = $DisableEditing
                $shouldProcessMessage = 'Set Portal user profile editing disabled to [{0}].' -f $DisableEditing
            }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($PortalId, ($shouldProcessMessage))) {
            # INVOKE REQUEST
            Invoke-RestMethod @restParams
        }
    }
}
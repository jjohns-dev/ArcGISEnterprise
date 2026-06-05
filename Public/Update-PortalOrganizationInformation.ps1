function Update-PortalOrganizationInformation {
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
        PS C:\> Update-PortalOrganizationInformation @cmnParams -MaxTokenExpiration 1440
        Set the maximum validity in minutes of both OAuth and nonOAuth tokens issued for users of the organization to 1440 minutes (24 hours).
    .EXAMPLE
        PS C:\> Update-PortalOrganizationInformation @cmnParams -Origin 'https://arcgis.com', 'https://test.com'
        Sets the allowed origins property to 'https://arcgis.com,https://test.com'
    .EXAMPLE
        PS C:\> Update-PortalOrganizationInformation @cmnParams -SharePublicly $false -DisableEditing $true
        Disables the public sharing of Portal content and Portal User Profile editing
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/update.htm
        This function replaced functionality from the following old, deprecated functions:
        - Set-PortalMaxTokenExpiration
        - Set-PortalAllowedOrigins
        - Set-PortalPublicSharing
        - Set-PortalUserProfileEditing
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    [Alias('Update-PortalOrgInfo')]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Share Portal items publicly')]
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
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)

        # VALIDATE AT LEAST ONE PARAMETER IS PROVIDED
        if (
            $PSBoundParameters.Keys -notcontains 'MaxTokenExpiration' -and
            $PSBoundParameters.Keys -notcontains 'Origin' -and
            $PSBoundParameters.Keys -notcontains 'SharePublicly' -and
            $PSBoundParameters.Keys -notcontains 'DisableEditing'
        ) {
            Write-Error -Message 'At least one parameter must be provided to update Portal settings.' -ErrorAction Stop
        }
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
            'MaxTokenExpiration' { $restParams['Body']['maxTokenExpirationMinutes'] = $MaxTokenExpiration }
            'Origin' { $restParams['Body']['allowedOrigins'] = ($Origin -join ',') }
            'SharePublicly' { $restParams['Body']['canSharePublic'] = $SharePublicly }
            'DisableEditing' { $restParams['Body']['updateUserProfileDisabled'] = $DisableEditing }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # CLONE PARAMETERS FOR SHOULD PROCESS MESSAGE
        $apiParams = $restParams['Body'] | ConvertTo-Json | ConvertFrom-Json -AsHashtable

        # REMOVE COMMON PARAMETERS
        $apiParams.Remove('f'); $apiParams.Remove('token')

        # CONVERT TO JSON STRING
        $apiParams = $apiParams | ConvertTo-Json -Compress

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($PortalId, ('Set Portal sharing API settings: [{0}]' -f $apiParams))) {
            # INVOKE REQUEST
            Invoke-RestMethod @restParams
        }
    }
}
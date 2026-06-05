function Set-PortalDefaultUserRole {
    <#
    .SYNOPSIS
        Set the default User Role in Portal
    .DESCRIPTION
        Set the default User Role in Portal
    .PARAMETER PortalId
        Portal ID
    .PARAMETER Role
        Portal Role
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
        PS C:\> Set-PortalDefaultUserRole -Role 'Viewer' @cParams
        Sets the default user type to 'Viewer'
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/set-user-default-settings.htm
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(HelpMessage = 'Portal ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF',

        [Parameter(Mandatory, HelpMessage = 'Role name')]
        [ValidatePattern('^[\w -]+$')]
        [System.String] $Role,

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

        # SET HASH FOR BUILT-IN ROLES
        $orgRoles = @(
            [PSCustomObject] @{ name = 'Admin'; id = 'org_admin' }
            [PSCustomObject] @{ name = 'User'; id = 'org_user' }
            [PSCustomObject] @{ name = 'Publisher'; id = 'org_publisher' }
        )

        # GET PORTAL ROLES
        $portalRoles = Get-PortalRoleList -Context $Context -Token $Token

        # FIND ROLE
        $inRole = switch ($Role) {
            { $_ -in $orgRoles.name } { $orgRoles | Where-Object name -EQ $Role }
            { $_ -in $portalRoles.name } { $portalRoles | Where-Object name -EQ $Role }
        }

        # VALIDATE PROVIDED ROLE
        if (-Not $inRole) { Write-Error -Message ('Provided role "{0}" not valid.' -f $Role) -ErrorAction Stop }

        # VERBOSE
        Write-Verbose -Message ('Role selected - Name: "{0}"; Id: "{1}"' -f $inRole.name, $inRole.id)
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = ('{0}/sharing/rest/portals/{1}/setUserDefaultSettings' -f $Context, $PortalId)
            Method = 'POST'
            Body   = @{
                Token           = $Token
                f               = 'json'
                role            = $inRole.id
            }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        # THIS DOES NOT APPEAR TO RESET OR REMOVE ANY SETTINGS IN THE EXISTING CONFIGURATION
        if ($PSCmdlet.ShouldProcess($Role, 'Set Portal default user role')) {
            Invoke-RestMethod @restParams
        }
    }
}
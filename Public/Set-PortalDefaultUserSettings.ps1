function Set-PortalDefaultUserSettings {
    <#
    .SYNOPSIS
        Set the default user settings in Portal
    .DESCRIPTION
        Set the default Role and/or User License type in Portal
    .PARAMETER PortalId
        Portal ID
    .PARAMETER Role
        Portal Role
    .PARAMETER UserLicenseType
        Portal User License Type
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
        PS C:\> Set-PortalDefaultUserSettings -UserLicenseType 'viewerUT' -Role 'Viewer' @cParams
        Sets the default user type to 'Viewer' and default license type to 'viewerUT'
    .NOTES
        Name:     Set-PortalDefaultUserSettings
        Author:   Phillip Glodowski, Justin Johns
        Version:  0.1.0 | Last Edit: 2023-11-06
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
        https://developers.arcgis.com/rest/users-groups-and-items/set-user-default-settings.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'Portal ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF',

        [Parameter(Mandatory = $false, HelpMessage = 'Role name')]
        [ValidatePattern('^[\w -]+$')]
        [System.String] $Role,

        [Parameter(Mandatory = $false, HelpMessage = 'User license type')]
        [System.String] $UserLicenseType,

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
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # VALIDATE PARAMETERS
        if (-Not $Role -and -Not $UserLicenseType) { Throw 'Role and/or UserLicenseType required' }

        # SET COMMON PARAMETERS
        $cParams = @{ Context = $Context; Token = $Token }

        #region - VALIDATE ROLE ========================================================
        if ($PSBoundParameters.ContainsKey('Role')) {

            # SET HASH FOR BUILT-IN ROLES
            $orgRoles = @(
                [PSCustomObject] @{ name = 'Admin'; id = 'org_admin' }
                [PSCustomObject] @{ name = 'User'; id = 'org_user' }
                [PSCustomObject] @{ name = 'Publisher'; id = 'org_publisher' }
            )

            # GET PORTAL ROLES
            $portalRoles = Get-PortalRole @cParams

            # FIND ROLE
            $inRole = switch ($Role) {
                { $_ -in $orgRoles.name } { $orgRoles | Where-Object name -EQ $Role }
                { $_ -in $portalRoles.name } { $portalRoles | Where-Object name -EQ $Role }
            }

            # VALIDATE PROVIDED ROLE
            if (-Not $inRole) { Throw ('Provided role "{0}" not valid.' -f $Role) }

            # VERBOSE
            Write-Verbose -Message ('Role selected - Name: "{0}"; Id: "{1}"' -f $inRole.name, $inRole.id)
        }
        #endregion =====================================================================


        #region - VALIDATE LICENSE =====================================================
        if ($PSBoundParameters.ContainsKey('UserLicenseType')) {
            # GET LICENSE
            $licenses = Get-PortalLicense @cParams

            # VALIDATE PROVIDED LICENSE TYPE
            if ($UserLicenseType -notin $licenses.userTypes.id) {
                Throw ('Provided user license "{0}" not valid.' -f $UserLicenseType)
            }
        }
        #endregion =====================================================================
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
                userLicenseType = $UserLicenseType
            }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        # THIS DOES NOT APPEAR TO RESET OR REMOVE ANY SETTINGS IN THE EXISTING CONFIGURATION
        Invoke-RestMethod @restParams
    }
}
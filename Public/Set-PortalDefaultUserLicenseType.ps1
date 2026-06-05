function Set-PortalDefaultUserLicenseType {
    <#
    .SYNOPSIS
        Set the default User License Type in Portal
    .DESCRIPTION
        Set the default User License Type in Portal
    .PARAMETER PortalId
        Portal ID
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
        PS C:\> Set-PortalDefaultUserLicenseType -UserLicenseType 'viewerUT'
        Sets the default default user license type to 'viewerUT'
    .NOTES
        Name:     Set-PortalDefaultUserLicenseType
        Author:   Phillip Glodowski, Justin Johns
        Version:  0.1.0 | Last Edit: 2023-11-06
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
        https://developers.arcgis.com/rest/users-groups-and-items/set-user-default-settings.htm
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(HelpMessage = 'Portal ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF',

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
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)

        # VALIDATE PARAMETERS
        if (-Not $Role -and -Not $UserLicenseType) { Write-Error -Message 'Role and/or UserLicenseType required' -ErrorAction Stop }

        # GET LICENSE
        $licenses = Get-PortalLicense -Context $Context -Token $Token

        # VALIDATE PROVIDED LICENSE TYPE
        if ($UserLicenseType -notin $licenses.userTypes.id) {
            Write-Error -Message ('Provided user license "{0}" not valid.' -f $UserLicenseType) -ErrorAction Stop
        }
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
        if ($PSCmdlet.ShouldProcess($PortalId, 'Set Portal default user license type')) {
            Invoke-RestMethod @restParams
        }
    }
}
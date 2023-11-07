function Set-PortalDefaultUserSettings {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
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
        PS C:\> Set-PortalDefaultUserSettings
        Explanation of what the example does
    .NOTES
        Name:     Set-PortalDefaultUserSettings
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2023-11-06
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'Portal ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF',

        [Parameter(Mandatory, HelpMessage = 'Role name')]
        [ValidateSet('viewer', 'editor???')]
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
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET ROLE HASH
        $roleMap = @{
            viewer = 'iAAAAAAAAAAAAAAA'
            editor = ''
        }
    }
    Process {
        # do we need to get the existing settings and preserve any non-changing settings while
        # making changes?

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = ('{0}/sharing/rest/portals/{1}/setUserDefaultSettings' -f $Context, $PortalId)
            Method = 'POST'
            Body   = @{
                Token           = $Token
                f               = 'json'
                role            = $roleMap[$Role] # >> create hash table
                userLicenseType = 'viewerUT' # >> get list of valid options
            }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
function Add-PortalUserToGroup {
    <#
    .SYNOPSIS
        Add Portal group member
    .DESCRIPTION
        Add member and/or manager to Portal group
    .PARAMETER GroupID
        Group ID
    .PARAMETER UserName
        Username of group member
    .PARAMETER AdminName
        Username of group manager
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Porta token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Add-PortalUserToGroup -GroupId $gid -UserName 'jsmith', 'jdoe' -AdminName 'jdoe' @commonParams
        Adds users 'jsmith' and 'jdoe' as members of the group and adds 'jdoe' as a group manager
    .NOTES
        Name:     Add-PortalUserToGroup
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-05-28
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/add-users-to-group/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Group ID')]
        [ValidatePattern('^[A-Za-z0-9]{32}$')]
        [System.String] $GroupID,

        [Parameter(Mandatory = $false, HelpMessage = 'Username of group member')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $UserName,

        [Parameter(Mandatory = $false, HelpMessage = 'Username of group manager')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $AdminName,

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

        # VALIDATE USER/ADMIN UPDATE
        if (-Not $PSBoundParameters.ContainsKey('UserName') -and -Not $PSBoundParameters.ContainsKey('AdminName')) {
            Write-Error -Message 'At least one group member or manager must be specified.' -ErrorAction Stop
        }
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/community/groups/{1}/addUsers' -f $Context, $GroupId
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
            }
        }

        # ADD USER TYPES
        if ($PSBoundParameters.ContainsKey('UserName')) { $restParams.Body.Add('users', ($UserName -join ',')) }
        if ($PSBoundParameters.ContainsKey('AdminName')) { $restParams.Body['admins'] = $AdminName -join ',' }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Adding group members: {0}' -f ($UserName -join ', '))
        Write-Verbose -Message ('Adding group managers: {0}' -f ($AdminName -join ', '))

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
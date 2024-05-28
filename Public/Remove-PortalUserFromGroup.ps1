function Remove-PortalUserFromGroup {
    <#
    .SYNOPSIS
        Remove Portal user from group
    .DESCRIPTION
        Remove Portal user or manager from group
    .PARAMETER GroupID
        Group ID
    .PARAMETER UserName
        Username of group member
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
        PS C:\> Remove-PortalUserFromGroup -GroupId $gid -UserName 'jsmith' @commonParams
        Remove user 'jsmith' from group
    .NOTES
        Name:     Remove-PortalUserFromGroup
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-05-28
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/remove-users-from-group/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Group ID')]
        [ValidatePattern('^[A-Za-z0-9]{32}$')]
        [System.String] $GroupID,

        [Parameter(Mandatory = $true, HelpMessage = 'Username of group member')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $UserName,

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
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/community/groups/{1}/removeUsers' -f $Context, $GroupId
            Method = 'POST'
            Body   = @{
                users = $UserName -join ','
                f     = 'json'
                token = $Token
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
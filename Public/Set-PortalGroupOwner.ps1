function Set-PortalGroupOwner {
    <#
    .SYNOPSIS
        Reassign a Portal group to another user
    .DESCRIPTION
        The Reassign Group operation (POST only) allows the administrator of an organization to reassign a group to another member of the organization.
    .PARAMETER GroupID
        Portal Group ID
    .PARAMETER UserName
        Portal username of new owner
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
        PS C:\> Set-PortalGroupOwner @cmnParams -GroupID '12345678901234567890123456789012' -UserName 'jsmith'
        Reassign the group with ID '12345678901234567890123456789012' to the user 'jsmith'.
    .NOTES
        Name:     Set-PortalGroupOwner
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-04-28
        - Version history is captured in repository commit history
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/reassign-group/
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal Group ID')]
        [ValidatePattern('^[A-Za-z0-9]{32}$')]
        [System.String] $GroupID,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal username of new owner')]
        [ValidatePattern('^[\w\.@-]+$')]
        [System.String] $UserName,

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

        <# # VALIDATE GROUP ID
        $group = Get-PortalUserGroupList

        # GET USER FROM USERNAME
        $user = Get-PortalUser -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck

        # VALIDATE USER
        if (-Not $user) { Write-Error -Message ('User with name [{0}] not found' -f $UserName) -ErrorAction Stop } #>
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/community/groups/{1}/reassign' -f $Context, $GroupID
            Method = 'POST'
            Body    = @{
                f              = 'json'
                token          = $Token
                targetUsername = $UserName
            }
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($GroupID, ('Change owner of group to [{0}]' -f $UserName))) {

            # INVOKE REQUEST
            Invoke-RestMethod @restParams
        }
    }
}
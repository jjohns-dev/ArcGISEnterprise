function Remove-PortalUserFolder {
    <#
    .SYNOPSIS
        Delete a folder from a Portal user
    .DESCRIPTION
        The delete user folder operation is available only on the user's non-root folders.
        The user's root folder cannot be deleted. Deleting a folder also deletes all items
        that it contains (both the items and the links).
    .PARAMETER UserName
        Username
    .PARAMETER FolderID
        Folder ID of Portal user folder to be deleted
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
        PS C:\> Remove-PortalUserFolder @cmnParams -UserName 'jsmith' -FolderID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6'
        Deletes the folder with ID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6' from the user 'jsmith'
    .NOTES
        Name:     Remove-PortalUserFolder
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-05-01
        - Version history is captured in repository commit history
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/delete-folder/
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

        [Parameter(Mandatory = $true, HelpMessage = 'Folder ID of Portal user folder to be deleted')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $FolderID,

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

        # VALIDATE USER NAME
        if (-Not $PSBoundParameters.ContainsKey('UserName')) {
            try {
                # GET USER PORTAL INFO
                Write-Verbose -Message 'Getting user settings...'
                $userSettings = Get-PortalSettings -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck

                # SET USER NAME
                $UserName = $userSettings.user.username
            }
            catch {
                # PASS ERROR
                Write-Error -Message ('Unable to get user error: {0}' -f $_.Exception.Message) -ErrorAction Stop
            }
        }
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/users/{1}/{2}/delete' -f $Context, $UserName, $FolderID
            Method = 'POST'
            Body   = @{ f = 'json'; token = $Token }
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($FolderID, ('Delete folder from user [{0}]' -f $UserName))) {

            # INVOKE REQUEST
            Invoke-RestMethod @restParams
        }
    }
}
function Get-PortalUserFolderList {
    <#
    .SYNOPSIS
        Get Portal for ArcGIS user folder list
    .DESCRIPTION
        Get all folders owned by user in Portal for ArcGIS
    .PARAMETER Username
        Username
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
        PS C:\> Get-PortalUserFolderList @commonParams -Username 'jsmith'
        Get all Portal folders belonging to 'jsmith'
    .NOTES
        Name:     Get-PortalUserFolderList
        Author:   Phillip Glodowski
        Version:  0.1.0 | Last Edit: 2024-3-13
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/user-content.htm
        This endpoint can also be used to retrieve user items, however the endpoint used
        in the Get-PortalUserItemList function is a more efficient method of making sure
        all of the user's items are returned.
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Username,

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
    }
    Process {
        # VALIDATE USER NAME
        if (-Not $PSBoundParameters.ContainsKey('UserName')) {
            try {
                # GET USER PORTAL INFO
                Write-Verbose -Message 'Getting user settings...'
                $userSettings = Get-PortalSettings -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck

                # SET USER NAME
                $Username = $userSettings.user.username
            }
            catch {
                # PASS ERROR
                throw ('Unable to get user info with error: {0}' -f $_.Exception.Message)
            }
        }

        # SET PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/users/{1}' -f $Context, $Username
            Method = 'GET'
            Body   = @{
                f     = 'json'
                token = $Token
                num   = 100
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        $rest = Invoke-RestMethod @restParams

        # CHECK FOR ERRORS
        if ($rest.error) {
            # RETURN ANY ERRORS
            $rest
        }
        else {
            # RETURN LIST OF FOLDERS
            $rest.folders
        }
    }
}
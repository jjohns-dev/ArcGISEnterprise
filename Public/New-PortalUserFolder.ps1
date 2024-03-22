function New-PortalUserFolder {
    <#
    .SYNOPSIS
        Creates a new folder in Portal for the specified user
    .DESCRIPTION
        Creates a new folder in Portal for the specified user
    .PARAMETER Username
        Username
    .PARAMETER Title
        Title of new folder
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
        PS C:\> New-PortalUserFolder -Username jsmith -Title NewFolder -Context 'https://arcgis.com/arcgis' -Token $token
        Creates a folder titled 'NewFolder' in Portal for the user 'jsmith'.
    .NOTES
        Name:     New-PortalUserFolder
        Author:   Phillip Glodowski
        Version:  0.1.0 | Last Edit: 2024-03-13
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/create-folder.htm
        General notes:
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Username,

        [Parameter(Mandatory = $true, HelpMessage = 'Title of new folder')]
        [ValidateNotNullOrEmpty()]
        [Alias('FolderName')]
        [System.String] $Title,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
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

        # VALIDATE USERNAME
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
    }
    Process {
        # SET PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/users/{1}/createFolder' -f $Context, $Username
            Method = 'POST'
            Body   = @{
                title = $Title
                f     = 'json'
                token = $Token
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams

    }
}
function New-PortalUserFolder {
    <#
    .SYNOPSIS
        Creates a new folder in Portal for the specified user
    .DESCRIPTION
        Creates a new folder in Portal for the specified user
    .PARAMETER UserName
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
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/create-folder.htm
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

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
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)

        # VALIDATE USERNAME
        if (-Not $PSBoundParameters.ContainsKey('UserName')) {
            try {
                # GET USER PORTAL INFO
                Write-Verbose -Message 'Getting user settings...'
                $userSettings = Get-PortalSetting -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck

                # SET USER NAME
                $Username = $userSettings.user.username
            }
            catch {
                # PASS ERROR
                Write-Error -Message ('Unable to get user info with error: {0}' -f $PSItem.Exception.Message) -ErrorAction Stop
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
        if ($PSCmdlet.ShouldProcess(('{0} for user [{1}]' -f $Title, $Username), 'Create Portal folder')) {
            Invoke-RestMethod @restParams
        }

    }
}
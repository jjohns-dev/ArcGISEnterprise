function Move-PortalUserItem {
    <#
    .SYNOPSIS
        Move Portal item to target folder
    .DESCRIPTION
        Move Portal item to target folder
    .PARAMETER ItemId
        Id of Portal item
    .PARAMETER FolderId
        Destination folder ID (use forward shlash "/" to move item to root folder)
    .PARAMETER UserName
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
        PS C:\> Move-PortalUserItem
        Explanation of what the example does
    .NOTES
        Name:     Move-PortalUserItem
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-15
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/move-items.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Id of Portal item')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String[]] $ItemId,

        [Parameter(Mandatory = $true, HelpMessage = 'Destination folder ID (use forward shlash "/" to move item to root folder)')]
        [ValidatePattern('([a-f0-9]{32}|/)')]
        [System.String] $FolderId,

        [Parameter(Mandatory = $false, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)

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
                Write-Error -Message ('Unable to get user info with error: {0}' -f $PSItem.Exception.Message) -ErrorAction Stop
            }
        }
    }
    Process {
        # SET PARAMETERS FOR ITEM UPLOAD
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/users/{1}/moveItems' -f $Context, $UserName
            Method = 'POST'
            Body   = @{
                f      = 'json'
                token  = $Token
                items  = $ItemId -join ','
                folder = $FolderId
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE UPLOAD
        Invoke-RestMethod @restParams
    }
}
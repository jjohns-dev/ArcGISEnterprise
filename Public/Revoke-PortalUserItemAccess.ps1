function Revoke-PortalUserItemAccess {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .PARAMETER ItemId
        Id of Portal item
    .PARAMETER GroupId
        Group ID
    .PARAMETER UserName
        Username
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
        PS C:\> Revoke-PortalUserItemAccess -ItemId $iId -GroupId $myGroup.id @commonParams
        Un-shares the current user's Portal item with ID $iId to the group with ID $myGroup.id
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/share-items.htm
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Id of Portal item')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String[]] $ItemId,

        [Parameter(Mandatory = $false, HelpMessage = 'Group ID')]
        [ValidatePattern('^[A-Za-z0-9]{32}$')]
        [System.String[]] $GroupId,

        [Parameter(Mandatory = $false, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
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
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)

        # VALIDATE USER NAME
        if (-Not $PSBoundParameters.ContainsKey('UserName')) {
            try {
                # GET USER PORTAL INFO
                Write-Verbose -Message 'Getting user settings...'
                $userSettings = Get-PortalSetting -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck

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
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/users/{1}/unshareItems' -f $Context, $UserName
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
                items = $ItemId -join ','
            }
        }

        # CHECK FOR GROUPIDS
        if ($PSBoundParameters.ContainsKey('GroupId')) { $restParams['Body'].Add('groups', ($GroupId -join ',')) }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Items:' -f $restParams.Body.items)
        Write-Verbose -Message ('Items:' -f $restParams.Body.groups)

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        if ($PSCmdlet.ShouldProcess(($ItemId -join ', '), 'Revoke Portal item access')) {
            Invoke-RestMethod @restParams
        }
    }
}
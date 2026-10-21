function Grant-PortalUserItemAccess {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .PARAMETER ItemId
        Id of Portal item
    .PARAMETER GroupId
        Group ID
    .PARAMETER Everyone
        Share item with everyone
    .PARAMETER Org
        Share item with org
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
        PS C:\> Grant-PortalUserItemAccess -ItemId $iId -GroupId $myGroup.id @commonParams
        Shares the current user's Portal item with ID $iId to the group with ID $myGroup.id
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/share-items.htm
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', DefaultParameterSetName = '_grp')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Id of Portal item')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String[]] $ItemId,

        [Parameter(Mandatory = $true, ParameterSetName = '_grp', HelpMessage = 'Group ID')]
        [ValidatePattern('^[A-Za-z0-9]{32}$')]
        [System.String[]] $GroupId,

        [Parameter(Mandatory = $true, ParameterSetName = '_ery', HelpMessage = 'Share item with everyone')]
        [System.Management.Automation.SwitchParameter] $Everyone,

        [Parameter(Mandatory = $true, ParameterSetName = '_org', HelpMessage = 'Share item with org')]
        [System.Management.Automation.SwitchParameter] $Org,

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
            $UserName = Resolve-PortalUserName -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck
        }
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/users/{1}/shareItems' -f $Context, $UserName
            Method = 'POST'
            Body   = @{
                f                  = 'json'
                token              = $Token
                items              = $ItemId -join ','
                confirmItemControl = $true
            }
        }

        # CHECK FOR PARAMETER SET NAME
        switch ($PSCmdlet.ParameterSetName) {
            '_grp' { $restParams['Body'].Add('groups', ($GroupId -join ',')) }
            '_ery' { $restParams['Body'].Add('everyone', $true) }
            '_org' { $restParams['Body'].Add('org', $true) }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        if ($PSCmdlet.ShouldProcess(($ItemId -join ', '), 'Grant Portal item access')) {
            Invoke-RestMethod @restParams
        }
    }
}

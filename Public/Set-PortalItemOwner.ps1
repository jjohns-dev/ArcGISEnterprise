function Set-PortalItemOwner {
    <#
    .SYNOPSIS
        Change ownership of a portal item
    .DESCRIPTION
        The reassignItems operation reassigns items owned by one user to another user in the organization.
        Before performing this operation, it is recommended that you first determine whether the user is eligible to receive content.
        Item owners must have the portal:user:reassignItems privilege assigned to them to transfer content to another user.
        Users assigned the default administrator role, or users assigned a custom administrative role that includes the
        portal:user:reassignItems privilege, can also perform this operation on behalf of the item owner.
    .PARAMETER ItemId
        Portal item ID
    .PARAMETER UserName
        Username of current item owner
    .PARAMETER TargetUserName
        Username of new item owner
    .PARAMETER TargetFolderName
        Name of the folder to move the item to (default to new folder with date). Use '/' for root folder. Creates new folder if it does not exist.
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Porta token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        System.String.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Set-PortalItemOwner @cmnParams -ItemId 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6' -UserName 'jsmith' -TargetUserName 'jdoe'
        Changes ownership of the item with ID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6' from user 'jsmith' to user 'jdoe'.
    .NOTES
        Name:     Set-PortalItemOwner
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-08-01
        - Version history is captured in repository commit history
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/reassign-items/
        (old) https://developers.arcgis.com/rest/users-groups-and-items/reassign-item/
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'Portal item ID')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String[]] $ItemId,

        [Parameter(Mandatory = $true, HelpMessage = 'Username of current item owner')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

        [Parameter(Mandatory = $true, HelpMessage = 'Username of new item owner')]
        [ValidateNotNullOrEmpty()]
        [System.String] $TargetUserName,

        [Parameter(Mandatory = $false, HelpMessage = 'Name of the folder to move item to')]
        [ValidateNotNullOrEmpty()]
        [System.String] $TargetFolderName,

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
            Uri     = '{0}/sharing/rest/content/users/{1}/reassignItems' -f $Context, $UserName
            Method  = 'POST'
            Body    = @{
                f                = 'json'
                token            = $Token
                items            = $ItemId -join ','
                targetUsername   = $TargetUserName
                #targetFoldername = if ($PSBoundParameters.ContainsKey('TargetFolderName')) { $TargetFolderName } else { '/' }
                targetFoldername = if ($PSBoundParameters.ContainsKey('TargetFolderName')) { $TargetFolderName }
            }
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($ItemId, ('Change item owner to [{0}]' -f $TargetUserName))) {

            # INVOKE REQUEST
            Invoke-RestMethod @restParams
        }
    }
}
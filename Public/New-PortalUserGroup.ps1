function New-PortalUserGroup {
    <#
    .SYNOPSIS
        Create new Portal user group
    .DESCRIPTION
        Create new Portal user group
    .PARAMETER Title
        Group title or name
    .PARAMETER Access
        Group access level
    .PARAMETER Description
        Group description
    .PARAMETER Snippet
        Group snippet or summary
    .PARAMETER Tag
        Group tag
    .PARAMETER SortField
        Group sort field
    .PARAMETER SortOrder
        Group sort order
    .PARAMETER IsViewOnly
        Set group to view only
    .PARAMETER IsInvitationOnly
        Set group to invitation only
    .PARAMETER Capability
        Group capability
    .PARAMETER LeavingDisallowed
        Set leaving to disallowed
    .PARAMETER HiddenMembers
        Set members to hidden (applies only to ArcGIS Online organizations)
    .PARAMETER MembershipAccess
        Group membership access
    .PARAMETER TypeKeyword
        Type keyword
    .PARAMETER Phone
        Group contact information (limit 50 characters)
    .PARAMETER Thumbnail
        Path to the thumbnail image to be used for the group
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> New-PortalUserGroup
        Creates a new folder named 'my_test_folder' in ArcGIS Server
    .NOTES
        Name:     New-PortalUserGroup
        Author:   Justin Johns
        Version:  0.1.2 | Last Edit: 2025-05-01
        - Version history is captured in repository commit history
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/create-group.htm
        https://developers.arcgis.com/rest/users-groups-and-items/common-parameters/#group-parameters
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Group title or name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Title,

        [Parameter(Mandatory = $false, HelpMessage = 'Group access level')]
        [ValidateSet('private', 'org', 'public')]
        [System.String] $Access = 'private',

        [Parameter(Mandatory = $false, HelpMessage = 'Group description')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Description,

        [Parameter(Mandatory = $false, HelpMessage = 'Group snippet or summary')]
        [ValidateNotNullOrEmpty()]
        [Alias('Summary')]
        [System.String] $Snippet,

        [Parameter(Mandatory = $false, HelpMessage = 'Group tag')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $Tag,

        [Parameter(Mandatory = $false, HelpMessage = 'Group sort field')]
        [ValidateSet('title', 'owner', 'avgrating', 'numviews', 'created', 'modified')]
        [System.String] $SortField,

        [Parameter(Mandatory = $false, HelpMessage = 'Group sort order')]
        [ValidateSet('asc', 'desc')]
        [System.String] $SortOrder,

        [Parameter(Mandatory = $false, HelpMessage = 'Set group to view only')]
        [System.Management.Automation.SwitchParameter] $IsViewOnly,

        [Parameter(Mandatory = $false, HelpMessage = 'Set group to invitation only')]
        [System.Boolean] $IsInvitationOnly = $true,

        [Parameter(Mandatory = $false, HelpMessage = 'Group capability')]
        [ValidateSet('updateItemControl', 'distributed')]
        [System.String[]] $Capability,

        [Parameter(Mandatory = $false, HelpMessage = 'Set leaving to disallowed')]
        [System.Management.Automation.SwitchParameter] $LeavingDisallowed,

        [Parameter(Mandatory = $false, HelpMessage = 'Set members to hidden (applies only to ArcGIS Online organizations)')]
        [System.Management.Automation.SwitchParameter] $HiddenMembers,

        # THIS IS SET TO 'org' BY DEFAULT AFTER REVIEWING THE API DOCS AND PURPOSE OF USER GROUPS IN ENTERPRISE
        [Parameter(Mandatory = $false, HelpMessage = 'Group membership access')]
        [ValidateSet('org', 'collaboration', 'none')]
        [System.String] $MembershipAccess = 'org',

        [Parameter(Mandatory = $false, HelpMessage = 'Type keyword')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $TypeKeyword,

        [Parameter(Mandatory = $false, HelpMessage = 'Group contact information (limit 50 characters)')]
        [ValidatePattern('^[\w\s-:/,.]{1,50}$')]
        [System.String] $Phone,

        [Parameter(Mandatory = $false, HelpMessage = 'Path to the thumbnail image to be used for the group')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Thumbnail, # thumbnail=subfolder/thumbnail.jpg

        [Parameter(Mandatory = $true, HelpMessage = 'Target Server context')]
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
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/community/createGroup' -f $Context
            Method = 'POST'
            Body   = @{
                f                 = 'json'
                token             = $Token
                title             = $Title
                access            = $Access
                description       = $Description
                snippet           = $Snippet
                tags              = $Tag -join ','
                sortField         = $SortField
                sortOrder         = $SortOrder
                isViewOnly        = if ($PSBoundParameters.ContainsKey('IsViewOnly')) { $true } else { $false }
                isInvitationOnly  = $IsInvitationOnly
                capabilities      = $Capability -join ','
                leavingDisallowed = if ($PSBoundParameters.ContainsKey('LeavingDisallowed')) { $true } else { $false }
                hiddenMembers     = if ($PSBoundParameters.ContainsKey('HiddenMembers')) { $true } else { $false }
                membershipAccess  = $MembershipAccess
                autoJoin          = $false
                typeKeywords      = $TypeKeyword -join ','
                phone             = $Phone
                thumbnail         = $Thumbnail
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
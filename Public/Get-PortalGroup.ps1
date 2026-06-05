function Get-PortalGroup {
    <#
    .SYNOPSIS
        Get Portal for ArcGIS group information.
    .DESCRIPTION
        An individual group resource represents a group within the organization.
        The group owner is automatically an administrator and is returned in the list
        of administrators. Administrators can invite, add to, or remove members from
        a group as well as update or delete the group. The administrator for an
        organization can also reassign the group to another member of the organization.
    .PARAMETER GroupID
        Group ID
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
        PS C:\> Get-PortalGroup @cmnParams -GroupID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6'
        Returns the group information for the group with ID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6' from Portal for ArcGIS.
    .NOTES
        Name:     Get-PortalGroup
        Author:   Justin Johns
        Version:  0.1.1 | Last Edit: 2025-07-22
        - Version history is captured in repository commit history
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/group/
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Group ID')]
        [ValidatePattern('^[A-Za-z0-9]{32}$')]
        [System.String] $GroupID,

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
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/community/groups/{1}' -f $Context, $GroupID
            Method = 'GET'
            Body   = @{ f = 'json'; token = $Token }
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
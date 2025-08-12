function Get-PortalItemGroupList {
    <#
    .SYNOPSIS
        Get Portal item groups
    .DESCRIPTION
        Get Portal user item groups
    .PARAMETER ItemId
        Portal item ID
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
        PS C:\> Get-PortalItemGroupList -ItemId 0e68d8058b744d1c95f709d2ae975232 @commonParams
        Returns an array of Portal item groups based on membership type (admin, member, other)
        for the item with ID 0e68d8058b744d1c95f709d2ae975232
    .NOTES
        Name:     Get-PortalItemGroupList
        Author:   Brandon Trampf
        Version:  0.1.0 | Last Edit: 2025-08-06
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/groups.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal item ID')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $ItemId,

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
            Uri    = '{0}/sharing/rest/content/items/{1}/groups' -f $Context, $ItemId
            Method = 'GET'
            Body   = @{ f = 'json'; token = $Token }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
function Get-PortalSettings {
    <#
    .SYNOPSIS
        Get Portal configuration or "self"
    .DESCRIPTION
        Get Portal configuration or "self." This may also be a good test of
        Portal token validity
    .PARAMETER Context
        Target Portal context
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-PortalSettings -Context 'https://arcgis.com/arcgis' -Token $token
        Gets Portal "self" configuration
    .NOTES
        Name:     Get-PortalSettings
        Author:   Phillip Glodowski, Justin Johns
        Version:  0.3.1 | Last Edit: 2025-07-22
        Comments: <Comment(s)>
        General notes
        https://developers.arcgis.com/rest/users-groups-and-items/portal.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    [Alias('Test-PortalToken', 'Get-PortalSelf')]
    Param(
        <# [Parameter(HelpMessage = 'Portal ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF', #>

        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/portals/self' -f $Context
            #Uri    = ('{0}/sharing/rest/portals/{1}' -f $Context, $PortalId)
            Method = 'GET'
            Body   = @{ token = $Token; f = 'json' }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
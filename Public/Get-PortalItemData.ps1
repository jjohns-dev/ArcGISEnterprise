function Get-PortalItemData {
    <#
    .SYNOPSIS
        Get Portal item data
    .DESCRIPTION
        Get all data for a Portal item including layers and layer data
    .PARAMETER ItemId
        Portal item ID
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
        PS C:\> Get-PortalItemData -ItemId 'fdc51cd9e3ac4f4aa8444949caf5e816' @cmnParams
        Returns all the item data including layers and laery data
    .NOTES
        Name:     Get-PortalItemData
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-06-04
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/item-data/
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
            Uri    = '{0}/sharing/rest/content/items/{1}/data' -f $Context, $ItemId
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
            }
            Headers = @{
                referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
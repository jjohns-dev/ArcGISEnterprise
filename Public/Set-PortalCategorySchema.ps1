function Set-PortalCategorySchema {
    <#
    .SYNOPSIS
        Write ArcGIS Portal category schema to Enterprise/organization
    .DESCRIPTION
        Applies the content category schema to an organization
    .PARAMETER Schema
        Portal category schema
    .PARAMETER PortalId
        Portal application ID
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
        PS C:\> $schema = Get-PortalCategorySchema @cmnParams
        PS C:\> Set-PortalCategorySchema @cmnParams -Schema $schema
        Gets the content category schema for the organization and then sets the exact same schema again.
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/assign-category-schema/
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal category schema')]
        [ValidateNotNullOrEmpty()]
        [System.Object] $Schema,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal application ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF',

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
            Uri     = '{0}/sharing/rest/portals/{1}/assignCategorySchema' -f $Context, $PortalId
            Method  = 'POST'
            Body    = @{
                f              = 'json'
                token          = $Token
                categorySchema = $Schema | ConvertTo-Json -Depth 10
            }
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        if ($PSCmdlet.ShouldProcess($PortalId, 'Set Portal category schema')) {
            Invoke-RestMethod @restParams
        }
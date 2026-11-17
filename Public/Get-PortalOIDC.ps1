function Get-PortalOIDC {
    <#
    .SYNOPSIS
        Retrieve OpenID Connect configuration from Portal for ArcGIS.
    .DESCRIPTION
        This function retrieves the OpenID Connect configuration from the Portal for ArcGIS sharing REST API.
    .PARAMETER ConfigId
        The ID of the OpenID Connect configuration to retrieve.
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
        PS C:\> Get-PortalOIDC @cmnParams -ConfigId '1234567890abcdef'
        Retrieves the OpenID Connect configuration with the specified ID from the Portal for ArcGIS.
    .NOTES
        Status: Stable
        Comments: No public documentation available for this endpoint.
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'ID of the OpenID Connect configuration')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ConfigId,

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
            Uri     = '{0}/sharing/rest/portals/{1}/oidc/{2}' -f $Context, $PortalId, $ConfigId
            Method  = 'GET'
            Body    = @{ f = 'json' }
            Headers = @{
                referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority
                'X-Esri-Authorization' = 'Bearer {0}' -f $Token
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
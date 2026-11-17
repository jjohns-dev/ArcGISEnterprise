function Get-ServerSystemProperty {
    <#
    .SYNOPSIS
        Get the system properties of the ArcGIS Server.
    .DESCRIPTION
        This function retrieves the system properties of the server using the ArcGIS REST API.
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
        PS C:\> Get-ServerSystemProperty
        Get the system properties of the ArcGIS Server.
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/serverproperties/
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
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
            Uri    = '{0}/admin/system/properties' -f $Context
            Method = 'GET'
            Body   = @{ f = 'json' }
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

function Get-ServerAllowedOriginList {
    <#
    .DESCRIPTION
        Get the allowed origins for ArcGIS Server
    .PARAMETER SOAP
        Get SOAP Allowed Origins
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> $params = @{ Context = 'https://arcgis.com/arcgis'; Token = $token }
        PS C:\> Get-ServerAllowedOriginList @params
        Gets the allowed origins for ArcGIS Server
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/soap-handler-config/
        https://developers.arcgis.com/rest/enterprise-administration/server/handlersrestservicesdirectory/
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    [Alias('Get-ServerAllowedOrigins')]
    Param(
        [Parameter(HelpMessage = 'Get SOAP Allowed Origins')]
        [System.Management.Automation.SwitchParameter] $SOAP,

        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        if ($PSBoundParameters.ContainsKey('SOAP')) {
            # SET QUERY PARAMETERS
            $restParams = @{
                Uri    = '{0}/admin/system/handlers/soap/soaphandlerconfig' -f $Context
                Method = 'GET'
                Headers = @{ 'X-Esri-Authorization' = 'Bearer {0}' -f $Token }
                Body   = @{ f = 'json' }
            }

            # ADD SKIP CERTIFICATE CHECK IF PROVIDED
            if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

            # SEND REQUEST
            (Invoke-RestMethod @restParams).allowedOrigins.Split(',')
        }
        else {
            $origins = (Get-ServerServicesDirectory @PSBoundParameters).allowedOrigins
            if ($origins.Count -EQ 0) { $null } else { $origins.Split(',') }
        }
    }
}
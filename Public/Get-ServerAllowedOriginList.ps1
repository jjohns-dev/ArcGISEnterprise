
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
        Name:     Get-ServerAllowedOriginList
        Author:   Justin Johns
        Version:  0.1.3 | Last Edit: 2024-07-18
        - Version history is capture in repository commit history
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding()]
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
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        if ($PSBoundParameters.ContainsKey('SOAP')) {
            # SET QUERY PARAMETERS
            $restParams = @{
                Uri    = '{0}/admin/system/handlers/soap/soaphandlerconfig' -f $Context
                Method = 'GET'
                Body   = @{ f = 'json'; token = $Token }
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
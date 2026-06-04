function Get-GeoEventServerStatus {
    <#
    .SYNOPSIS
        Retrieves the health status of a GeoEvent Server
    .DESCRIPTION
        Sends a web request to the GeoEvent Server health status endpoint and retrieves the current health status information.
        For now, this is merely a web response with no further information.
    .PARAMETER Context
        Target GeoEvent Server Context
    .PARAMETER Token
        Server token (from the GeoEvent Server's ArcGIS Server site)
        When generating token, you must set the "Referer" parameter to the GeoEvent Server context URL
        and the "Client" parameter to "referer"
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None
    .OUTPUTS
        System.Object
    .EXAMPLE
        PS C:\> $GeoEventContext = 'https://arcgis.com/geoevent'
        PS C:\> $ServerContext = 'https://arcgis.com/arcgis'
        PS C:\> $token = Get-ServerToken -Credentials (Get-Credential) -Context $ServerContext -Referer $GeoEventContext -Client 'referer'
        PS C:\> Get-GeoEventServerStatus -Context $GeoEventContext -Token $token.token

        Sends a web request to the GeoEvent Server health status endpoint
    .NOTES
        Name:     Get-GeoEventServerStatus
        Author:   Phillip Glodowski
        Version:  0.1.0 | Last Edit: 2025-11-14

        API Documentation can be found at:
        https://yourgeoeventserver.domain/geoevent/admin/api/index.html
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Target GeoEvent Server context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Server token')]
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
        $requestParams = @{
            Uri = '{0}/admin/health/status' -f $Context
            Method = 'GET'
            Headers = @{
                GeoEventAuthorization = $Token
            }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $requestParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-WebRequest @requestParams
    }
}
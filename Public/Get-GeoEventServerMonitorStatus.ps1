function Get-GeoEventServerMonitorStatus {
    <#
    .SYNOPSIS
        Retrieves GeoEvent Server Monitoring objects
    .DESCRIPTION
        Retrieves a list of GeoEvent Server Monitoring objects
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
        PS C:\> Get-GeoEventServerMonitorStatus -Context $GeoEventContext -Token $token.token

        Retrieves a list of all GeoEvent Server Monitor Status objects
    .NOTES
        Name:     Get-GeoEventServerMonitorStatus
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
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # SET REQUEST PARAMETERS
        $requestParams = @{
            Uri     = '{0}/admin/monitoring' -f $Context
            Method  = 'GET'
            Headers = @{
                GeoEventAuthorization = $Token
            }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $requestParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @requestParams
    }
}
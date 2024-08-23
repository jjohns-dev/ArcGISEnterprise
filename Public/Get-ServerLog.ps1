function Get-ServerLog {
    <#
    .SYNOPSIS
        Get ArcGIS Server logs
    .DESCRIPTION
        Get ArcGIS Server logs by using the logs query endpoint
    .PARAMETER Level
        Returns only records with a log level at or more severe than the level specified
    .PARAMETER StartTime
        The most recent time to query
    .PARAMETER EndTime
        The oldest time to include in the result set
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
        PS C:\> Get-ServerLog @commonParams -Level 'SEVERE'
        Get all server logs with a level of SEVERE
    .NOTES
        Name:     Get-ServerLog @commonParams
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-08-23
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/logsquery.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Logging level to return')]
        [ValidateSet('SEVERE', 'WARNING', 'INFO', 'FINE', 'VERBOSE', 'DEBUG')]
        [System.String] $Level = 'WARNING',

        [Parameter(Mandatory = $false, HelpMessage = 'The most recent time to query')]
        [System.DateTime] $StartTime,

        [Parameter(Mandatory = $false, HelpMessage = 'The oldest time to include in the result set')]
        [System.DateTime] $EndTime,

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
            Uri    = '{0}/admin/logs/query' -f $Context
            Method = 'POST'
            Body    = @{
                level      = $Level
                filterType = 'json'
                #filter     = '{"codes":[""],"processIds":[""],"requestIds":[""],"component":[""],"services":[""],"machines":[""]}'
                filter     = @{
                    codes      = @()
                    processIds = @()
                    requestIds = @()
                    component  = @() # Values: ADMIN|REST|SERVER|SOAP|DATA STORE
                    services   = @()
                    machines   = @()
                } | ConvertTo-Json -Compress
                startTime  = if ($PSBoundParameters.ContainsKey('StartTime')) { [System.DateTimeOffset]::new($StartTime).ToUnixTimeMilliseconds() }
                endTime    = if ($PSBoundParameters.ContainsKey('EndTime')) { [System.DateTimeOffset]::new($EndTime).ToUnixTimeMilliseconds() }
                pageSize   = '1000' # Default is 1000
                f          = 'json'
                token      = $Token
            }
            Headers = @{
                referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Request Body: {0}' -f ($restParams['Body']['filter'] | Out-String))

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
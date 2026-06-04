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
    .PARAMETER Code
        Log code
    .PARAMETER PageSize
        Number of log entries in response
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
        Version:  0.1.2 | Last Edit: 2025-07-22
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

        [Parameter(Mandatory = $false, HelpMessage = 'Log code')]
        [ValidateRange(0, 169999)]
        [System.Int32[]] $Code,

        [Parameter(Mandatory = $false, HelpMessage = 'Number of log entries in response')]
        [ValidateRange(1000, 10000)]
        [System.Int32] $PageSize = 1000,

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
            Uri     = '{0}/admin/logs/query' -f $Context
            Method  = 'GET'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
            Body    = @{
                level      = $Level
                filterType = 'json'
                filter     = @{
                    codes      = @()
                    processIds = @()
                    requestIds = @()
                    #component  = @() # Values: ADMIN|REST|SERVER|SOAP|DATA STORE
                    server     = '*' #@()
                    services   = '*' #@()
                    machines   = '*' #@()
                }
                startTime  = if ($PSBoundParameters.ContainsKey('StartTime')) { [System.DateTimeOffset]::new($StartTime).ToUnixTimeMilliseconds() }
                endTime    = if ($PSBoundParameters.ContainsKey('EndTime')) { [System.DateTimeOffset]::new($EndTime).ToUnixTimeMilliseconds() }
                pageSize   = $PageSize # Default is 1000, max is 10,000
                f          = 'json'
                token      = $Token
            }
        }

        # ADD CODES IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Code')) { $restParams['Body']['filter'].codes = @( $Code ) }

        # CONVERT FILTER TO JSON
        $restParams['Body']['filter'] = $restParams['Body']['filter'] | ConvertTo-Json -Depth 4 -Compress

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Request Body: {0}' -f ($restParams['Body'] | Out-String))

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
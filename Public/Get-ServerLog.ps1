function Get-ServerLog {
    <#
    .SYNOPSIS
        Get ArcGIS Server logs
    .DESCRIPTION
        Get ArcGIS Server logs by using the logs query endpoint. All pages are automatically
        retrieved and returned when more records exist beyond the requested page size.
    .PARAMETER Level
        Returns only records with a log level at or more severe than the level specified
    .PARAMETER StartTime
        The most recent time to query
    .PARAMETER EndTime
        The oldest time to include in the result set
    .PARAMETER Code
        Log code
    .PARAMETER PageSize
        Number of log entries per page. Defaults to 1000.
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
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
        Status: Stable
        Comments:
        Returns a flat collection of individual log-message objects gathered across all pages.
        This differs from earlier versions, which returned the API wrapper object exposing the
        log entries on a 'logMessages' property.
        Pagination walks the time window using each response's 'endTime'. The API exposes no
        row cursor, so if more records share a single millisecond than 'PageSize', the window
        cannot advance and iteration stops at that boundary (reported via a warning); the large
        default PageSize (1000) makes this practically unreachable.
        https://developers.arcgis.com/rest/enterprise-administration/server/logsquery.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[System.Object]])]
    Param(
        [Parameter(HelpMessage = 'Logging level to return')]
        [ValidateSet('SEVERE', 'WARNING', 'INFO', 'FINE', 'VERBOSE', 'DEBUG')]
        [System.String] $Level = 'WARNING',

        [Parameter(HelpMessage = 'The most recent time to query')]
        [System.DateTime] $StartTime,

        [Parameter(HelpMessage = 'The oldest time to include in the result set')]
        [System.DateTime] $EndTime,

        [Parameter(HelpMessage = 'Log code')]
        [ValidateRange(0, 169999)]
        [System.Int32[]] $Code,

        [Parameter(HelpMessage = 'Number of log entries per page')]
        [ValidateRange(1000, 10000)]
        [System.Int32] $PageSize = 1000,

        [Parameter(Mandatory, HelpMessage = 'Target Server context')]
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

        # CREATE LOG ENTRY LIST
        $logEntries = [System.Collections.Generic.List[System.Object]]::new()
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

        # COLLECT LOG ENTRIES ACROSS ALL PAGES
        # Server paginates by time: the response 'endTime' is the oldest (epoch ms) record in the
        # page. Setting the next request 'startTime' to that value returns the next, older page.
        # The bound is inclusive, so each subsequent page repeats the previous page's last record;
        # that leading duplicate is dropped. The window not advancing is a safety stop.
        # NOTE: the response carries no usable 'nextStart' cursor; only hasMore/startTime/endTime.
        $firstPage = $true
        $previousEndTime = $null
        do {
            $rest = Invoke-RestMethod @restParams

            if ($rest.error) {
                $rest
                break
            }

            $messages = @($rest.logMessages)
            if (-not $firstPage -and $messages.Count -gt 0) {
                $messages = @($messages | Select-Object -Skip 1)
            }
            foreach ($entry in $messages) { $logEntries.Add($entry) | Out-Null }

            $firstPage = $false
            $continue = $rest.hasMore -eq $true -and $rest.endTime -ne $previousEndTime
            $previousEndTime = $rest.endTime

            # Advance the cursor on a fresh Body copy so each request carries its own
            # startTime rather than mutating the previous request's Body in place.
            if ($continue) {
                $nextBody = $restParams.Body.Clone()
                $nextBody['startTime'] = $rest.endTime
                $restParams.Body = $nextBody
            }
        } while ($continue)

        # If the loop exited while the server still reports more pages, the time-window cursor
        # could not advance — more than PageSize records share a single millisecond. The result
        # is truncated at that boundary; warn rather than return a silently-incomplete set.
        if ($rest.hasMore -eq $true) {
            Write-Warning -Message ('Get-ServerLog result is truncated: more than PageSize ({0}) log records share timestamp {1} (epoch ms), so the query cannot page past it. Increase -PageSize (max 10000) or narrow the time range with -StartTime/-EndTime.' -f $PageSize, $previousEndTime)
        }

        $logEntries
    }
}
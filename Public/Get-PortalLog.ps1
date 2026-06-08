function Get-PortalLog {
    <#
    .SYNOPSIS
        Get Portal for ArcGIS logs
    .DESCRIPTION
        Get Portal for ArcGIS logs by using the logs query endpoint. All pages are automatically
        retrieved and returned when more records exist beyond the requested page size.
    .PARAMETER Level
        Returns only records with a log level at or more severe than the level specified
    .PARAMETER StartTime
        The most recent time to query
    .PARAMETER EndTime
        The oldest time to include in the result set
    .PARAMETER Code
        Log code
    .PARAMETER UserName
        Organization member usernames
    .PARAMETER PageSize
        Number of log entries per page. Defaults to 1000.
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Collections.Generic.List[System.Object].
    .EXAMPLE
        PS C:\> Get-PortalLog @commonParams -EndTime (Get-Date).AddDays(-7)
        Get all portal logs from the last 7 days
    .NOTES
        Status: Stable
        Comments:
        Returns a flat collection of individual log-message objects gathered across all pages.
        This differs from earlier versions, which returned the API wrapper object exposing the
        log entries on a 'logMessages' property.
        https://developers.arcgis.com/rest/enterprise-administration/portal/query-logs.htm
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
        [ValidateRange(200000, 9999999)]
        [System.String[]] $Code,

        [Parameter(HelpMessage = 'Organization member usernames')]
        [System.String[]] $UserName,

        # TODO: Verify Portal API max page size — assumed 10,000 matching Server API
        [Parameter(HelpMessage = 'Number of log entries per page')]
        [ValidateRange(1, 10000)]
        [System.Int32] $PageSize = 1000,

        <# # THIS DOESN'T SEEM TO WORK
        [Parameter(Mandatory = $false, HelpMessage = 'The source component of the logged event')]
        [ValidateSet('*', 'SHARING', 'PORTAL ADMIN', 'PORTAL')]
        [System.String] $Source, #>

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

        # CREATE LOG ENTRY LIST
        $logEntries = [System.Collections.Generic.List[System.Object]]::new()
    }
    Process {
        # BUILD TIME BOUNDS — Portal expects epoch milliseconds. An empty string is treated
        # by the API as "use the default" (start = now, end = beginning). The keys must always
        # be present; omitting them returns no results.
        $startTimeValue = if ($PSBoundParameters.ContainsKey('StartTime')) { [System.DateTimeOffset]::new($StartTime).ToUnixTimeMilliseconds() } else { '' }
        $endTimeValue = if ($PSBoundParameters.ContainsKey('EndTime')) { [System.DateTimeOffset]::new($EndTime).ToUnixTimeMilliseconds() } else { '' }

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri     = '{0}/portaladmin/logs/query' -f $Context
            Method  = 'GET'
            Body    = @{
                level      = $Level
                startTime  = $startTimeValue
                endTime    = $endTimeValue
                filterType = 'json'
                filter     = @{
                    codes = if ($PSBoundParameters.ContainsKey('Code')) { @($Code) } else { $null }
                    users = if ($PSBoundParameters.ContainsKey('UserName')) { @($UserName) } else { $null }
                    # NOTE: the 'source' key is required even when null; omitting it returns no results.
                    source = $null
                } | ConvertTo-Json -Compress -Depth 4
                pageSize   = $PageSize
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

        # COLLECT LOG ENTRIES ACROSS ALL PAGES
        # Portal paginates by time: the response 'endTime' is the oldest (epoch ms) record in the
        # page. Setting the next request 'startTime' to that value returns the next, older page.
        # The bound is inclusive, so each subsequent page repeats the previous page's last record;
        # that leading duplicate is dropped. The window not advancing is a safety stop.
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

        $logEntries
    }
}
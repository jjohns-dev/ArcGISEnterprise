function Get-PortalLog {
    <#
    .SYNOPSIS
        Get Portal for ArcGIS logs
    .DESCRIPTION
        Get Portal for ArcGIS logs by using the logs query endpoint
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
        PS C:\> Get-PortalLog @commonParams -EndTime (Get-Date).AddDays(-7)
        Get all portal logs from the last 7 days
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/portal/query-logs.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Logging level to return')]
        [ValidateSet('SEVERE', 'WARNING', 'INFO', 'FINE', 'VERBOSE', 'DEBUG')]
        [System.String] $Level = 'WARNING',

        [Parameter(Mandatory = $false, HelpMessage = 'The most recent time to query')]
        [System.DateTime] $StartTime,

        [Parameter(Mandatory = $false, HelpMessage = 'The oldest time to include in the result set')]
        [System.DateTime] $EndTime,

        [Parameter(Mandatory = $false, HelpMessage = 'Log code')]
        [ValidateRange(200000, 9999999)]
        [System.String[]] $Code,

        [Parameter(Mandatory = $false, HelpMessage = 'Organization member usernames')]
        [System.String[]] $UserName,

        <# # THIS DOESN'T SEEM TO WORK
        [Parameter(Mandatory = $false, HelpMessage = 'The source component of the logged event')]
        [ValidateSet('*', 'SHARING', 'PORTAL ADMIN', 'PORTAL')]
        [System.String] $Source, #>

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
            Uri    = '{0}/portaladmin/logs/query' -f $Context
            Method = 'GET'
            Body    = @{
                level      = $Level
                filterType = 'json'
                #filter     = '{"codes":[""],"users":[""],"source":[""]}'
                filter     = @{
                    codes  = $Code
                    users  = $UserName
                    source = $Source
                } | ConvertTo-Json -Compress
                startTime  = '{0:yyyy-MM-ddTHH:mm:ss}' -f $StartTime
                endTime    = '{0:yyyy-MM-ddTHH:mm:ss}' -f $EndTime
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
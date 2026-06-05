function Add-ServerUsageReport {
    <#
    .SYNOPSIS
        Creates a new usage report
    .DESCRIPTION
        Add a new report to the usage reports in ArcGIS Server.
    .PARAMETER ReportName
        Report name
    .PARAMETER Since
        Report time frame
    .PARAMETER From
        Start time
    .PARAMETER To
        End time
    .PARAMETER ResourceURI
        Resource URI(s)
    .PARAMETER Metric
        Desired metric(s)
    .PARAMETER Metadata
        Report metadata
    .PARAMETER AggregationInterval
        Aggregation interval in minutes
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
        PS C:\> $reportParams = @{
            ReportName  = 'Make_Me_Cry'
            Since       = 'LAST_DAY'
            ResourceURI = 'services/Hosted/make_me_cry.FeatureServer'
            Metric      = @('RequestCount', 'RequestsFailed', 'RequestsTimedOut', 'RequestAvgResponseTime', 'RequestMaxResponseTime')
            Metadata    = 'Usage report for "Make_Me_Cry" service'
        }
        PS C:\> Add-ServerUsageReport @commonParams @reportParams
        Creates a new usage report for the 'Make_Me_Cry' service.
    .EXAMPLE
        PS C:\> $reportParams = @{
            ReportName          = 'Make_Me_Cry'
            From                = Get-Date -Date '2024-12-11'
            To                  = Get-Date -Date '2025-02-04'
            AggregationInterval = 60
            ResourceURI         = 'services/Hosted/make_me_cry.FeatureServer'
            Metric              = @('RequestCount', 'RequestsFailed', 'RequestsTimedOut', 'RequestAvgResponseTime', 'RequestMaxResponseTime')
            Metadata            = 'Usage report for "Make_Me_Cry" service'
        }
        PS C:\> Add-ServerUsageReport @cmnParams @reportParams
        Creates a new usage report for the 'Make_Me_Cry' service with 1 hour aggregation interval from Dec 11 to Feb 4.
    .NOTES
        Name:     Add-ServerUsageReport
        Author:   Justin Johns
        Version:  0.1.2 | Last Edit: 2025-02-06
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/createusagereport/
    #>
    [CmdletBinding(DefaultParameterSetName = '__cnnd')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Report name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ReportName,

        [Parameter(Mandatory = $true, HelpMessage = 'Report time frame', ParameterSetName = '__cnnd')]
        [ValidateSet('LAST_DAY', 'LAST_WEEK', 'LAST_MONTH')] #, 'CUSTOM'
        [System.String] $Since,

        [Parameter(Mandatory = $true, HelpMessage = 'Start time', ParameterSetName = '__cstm')]
        [ValidateNotNullOrEmpty()]
        [System.DateTime] $From,

        [Parameter(Mandatory = $true, HelpMessage = 'End time', ParameterSetName = '__cstm')]
        [ValidateNotNullOrEmpty()]
        [System.DateTime] $To,

        [Parameter(Mandatory = $true, HelpMessage = 'Resource URI')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $ResourceURI,

        [Parameter(Mandatory = $true, HelpMessage = 'Metrics')]
        [ValidateSet(
            'RequestCount',
            'RequestsFailed',
            'RequestsTimedOut', # NOT APPLICABLE TO HOSTED FEATURE SERVICES
            'RequestAvgResponseTime',
            'RequestMaxResponseTime',
            'ServiceRunningInstancesMax', # NOT APPLICABLE TO HOSTED FEATURE SERVICES
            'RequestAvgWaitTime',
            'RequestMaxWaitTime',
            'RequestMinWaitTime'
        )]
        [System.String[]] $Metric,

        [Parameter(Mandatory = $false, HelpMessage = 'Report metadata')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Metadata,

        [Parameter(Mandatory = $false, HelpMessage = 'Aggregation interval in minutes')]
        [ValidateNotNullOrEmpty()]
        [System.Int32] $AggregationInterval, # DEFAULT IS 30

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
            Uri     = '{0}/admin/usagereports/add' -f $Context
            Method  = 'POST'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
            Body    = @{
                f           = 'json'
                token       = $Token
                usagereport = @{
                    reportname = $ReportName
                    since      = if ($PSCmdlet.ParameterSetName -eq '__cstm') { 'CUSTOM' } else { $Since }
                    metadata   = $Metadata
                    queries    = @(
                        [PSCustomObject] @{
                            resourceURIs = @( $ResourceURI ) #if ($ResourceURI -is [System.Array]) { $ResourceURI } else { @( $ResourceURI ) }
                            metrics      = @( $Metric ) #if ($Metric -is [System.Array]) { $Metric } else { @( $Metric ) }
                        }
                    )
                }
            }
        }

        # ADD CUSTOM TIME FRAME IF PROVIDED
        if ($PSCmdlet.ParameterSetName -eq '__cstm') {
            $restParams['Body'].usagereport.Add('from', [System.DateTimeOffset]::new($From).ToUnixTimeMilliseconds())
            $restParams['Body'].usagereport.Add('to', [System.DateTimeOffset]::new($To).ToUnixTimeMilliseconds())
        }

        # ADD AGGREGATION INTERVAL IF PROVIDED
        if ($PSBoundParameters.ContainsKey('AggregationInterval')) { $restParams['Body'].usagereport.Add('aggregationInterval', $AggregationInterval) }

        # CONVERT USAGE REPORT TO JSON
        $restParams['Body'].usagereport = $restParams['Body'].usagereport | ConvertTo-Json -Depth 4

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Usage report JSON: {0}' -f $restParams.Body.usagereport)

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
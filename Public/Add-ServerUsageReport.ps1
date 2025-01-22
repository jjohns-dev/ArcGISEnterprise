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
    .PARAMETER ResourceURI
        Resource URI(s)
    .PARAMETER Metric
        Desired metric(s)
    .PARAMETER Dimension
        Report dimension
    .PARAMETER Metadata
        Report metadata
    .PARAMETER AggregationInterval
        Aggregation interval
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
        PS C:\> $dim = [PSCustomObject] @{
            resourceURIs = @('services/Hosted/make_me_cry.FeatureServer')
            metrics      = @('RequestCount', 'RequestsFailed', 'RequestsTimedOut', 'RequestAvgResponseTime', 'RequestMaxResponseTime')
        }
        PS C:\> Add-ServerUsageReport -ReportName 'Make_Me_Cry' -Since 'LAST_DAY' -Dimension $dim -Metadata 'Usage report for "Make_Me_Cry" service' @commonParams
        The first command creates a dimension object for the report. The second command creates a new usage report for the 'Make_Me_Cry' service.
    .EXAMPLE
        PS C:\> Add-ServerUsageReport -ReportName 'Make_Me_Cry' -Since 'LAST_DAY' -ResourceURI 'services/Hosted/make_me_cry.FeatureServer' -Metrics 'RequestCount', 'RequestsFailed', 'RequestsTimedOut', 'RequestAvgResponseTime', 'RequestMaxResponseTime' -Metadata 'Usage report for "Make_Me_Cry" service' @commonParams
        Creates a new usage report for the 'Make_Me_Cry' service.
    .NOTES
        Name:     Add-ServerUsageReport
        Author:   Justin Johns
        Version:  0.1.1 | Last Edit: 2025-01-21
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/createusagereport/
    #>
    [CmdletBinding(DefaultParameterSetName = '__smpl')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Report name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ReportName,

        [Parameter(Mandatory = $true, HelpMessage = 'Report time frame')]
        [ValidateSet('LAST_DAY', 'LAST_WEEK', 'LAST_MONTH'<# , 'CUSTOM' #>)]
        [System.String] $Since,

        [Parameter(Mandatory = $true, HelpMessage = 'Resource URI', ParameterSetName = '__smpl')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $ResourceURI,

        [Parameter(Mandatory = $true, HelpMessage = 'Metrics', ParameterSetName = '__smpl')]
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

        [Parameter(Mandatory = $true, HelpMessage = 'Report dimension', ParameterSetName = '__dmsn')]
        [ValidateScript({
            $_.psobject.Properties.Name -contains 'resourceURIs' -and $_.resourceURIs -is [System.Array] -and `
            $_.psobject.Properties.Name -contains 'metrics' -and $_.metrics -is [System.Array]
        })]
        [System.Object] $Dimension,

        [Parameter(Mandatory = $false, HelpMessage = 'Report metadata')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Metadata,

        [Parameter(Mandatory = $false, HelpMessage = 'Aggregation interval')]
        [ValidateNotNullOrEmpty()]
        [System.Int32] $AggregationInterval,

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

        # CREATE DIMENSION OBJECT
        if ($PSCmdlet.ParameterSetName -eq '__smpl') {
            $dim = [PSCustomObject] @{
                resourceURIs = @( $ResourceURI ) #if ($ResourceURI -is [System.Array]) { $ResourceURI } else { @( $ResourceURI ) }
                metrics      = @( $Metric ) #if ($Metric -is [System.Array]) { $Metric } else { @( $Metric ) }
            }
        }
        else {
            $dim = $Dimension
        }
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
                    since      = $Since
                    #from       = [System.DateTimeOffset]::new((Get-Date -Date '2025-01-16 14:00:00')).ToUnixTimeMilliseconds()
                    #to         = [System.DateTimeOffset]::new((Get-Date -Date '2025-01-16 15:00:00')).ToUnixTimeMilliseconds()
                    #aggregationInterval = 30 # IN MINUTES
                    queries    = @( $dim )
                    metadata   = $Metadata
                }
            }
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
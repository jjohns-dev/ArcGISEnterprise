function Get-ServerUsageReportData {
    <#
    .SYNOPSIS
        Retrieves server usage data for the report.
    .DESCRIPTION
        This operation aggregates and filters server usage statistics for the entire ArcGIS Server site.
    .PARAMETER ReportName
        Name of the report to retrieve
    .PARAMETER MachineName
        Machine name
    .PARAMETER ReportFormat
        Report format
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
        PS C:\> Get-ServerUsageReportData -ReportName 'Make_Me_Cry' @commonParams
        Retrieves the usage data for the 'Make_Me_Cry' report.
    .NOTES
        Name:     Get-ServerUsageReportData
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-01-17
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/queryreportdata/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Report name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ReportName,

        [Parameter(Mandatory = $false, HelpMessage = 'Machine name')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $MachineName = '*',

        [Parameter(Mandatory = $false, HelpMessage = 'Report format')]
        [ValidateSet('json', 'csv', 'html')]
        [System.String] $ReportFormat = 'json',

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
            Uri     = '{0}/admin/usagereports/{1}/data' -f $Context, $ReportName
            Method  = 'POST'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
            Body    = @{
                f      = $ReportFormat
                token  = $Token
                filter = @{
                    machines = if ($MachineName -is [System.Array]) { @( $MachineName ) } else { $MachineName }
                } | ConvertTo-Json -Compress
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
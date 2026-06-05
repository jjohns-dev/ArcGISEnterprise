function Get-ServerUsageReport {
    <#
    .SYNOPSIS
        Get Server usage report
    .DESCRIPTION
        Returns a Server usage report
    .PARAMETER ReportName
        Name of the report to retrieve
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
        PS C:\> Get-ServerUsageReport @cmnParams -ReportName 'Test'
        Returns the 'Test' usage report.
    .EXAMPLE
        PS C:\> Get-ServerUsageReport @cmnParams
        Returns all usage reports.
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/usagereports/
        https://developers.arcgis.com/rest/enterprise-administration/server/usagereport/
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Report name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ReportName,

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
            Uri     = if ($PSBoundParameters.ContainsKey('ReportName')) {
                '{0}/admin/usagereports/{1}' -f $Context, $ReportName
            }
            else {
                '{0}/admin/usagereports' -f $Context
            }
            Method  = 'GET'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
            Body    = @{ f = 'json'; token = $Token }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REMOVE REQUEST
        Invoke-RestMethod @restParams
    }
}
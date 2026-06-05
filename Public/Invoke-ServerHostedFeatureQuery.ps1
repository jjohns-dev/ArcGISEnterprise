function Invoke-ServerHostedFeatureQuery {
    <#
    .SYNOPSIS
        Invoke query against a Hosted Feature Service
    .DESCRIPTION
        Invoke query against a Hosted Feature Service layer
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
    .PARAMETER LayerId
        Service Layer ID
    .PARAMETER Where
        Query where clause
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Invoke-ServerHostedFeatureQuery -Where 'ObjectId=1001' -ServiceName MyService -layerId 0 @commonParams
        Query MyServer LayerId 0 for a record with ObjectId 1001
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/services-reference/enterprise/query-feature-service-layer-.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal Hosted Feature Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $false, HelpMessage = 'Service Layer ID')]
        [ValidateNotNullOrEmpty()]
        [Alias('Layer')]
        [System.Int32] $LayerId = 0,

        [Parameter(Mandatory = $false, HelpMessage = 'Query where clause')]
        [ValidatePattern('^[\w\*=]+$')]
        [System.String] $Where = '1=1',

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        # SET PARAMETERS FOR QUERYING FEATURE SERVICE LAYER
        $restParams = @{
            Uri    = '{0}/rest/services/Hosted/{1}/FeatureServer/{2}/query' -f $Context, $ServiceName, $LayerId
            Method = 'GET'
            Body   = @{
                f         = 'json'
                token     = $Token
                where     = $Where
                outFields = '*'
                #returnGeometry     = $true
                #returnIdsOnly      = $false
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE QUERY
        Invoke-RestMethod @restParams
    }
}
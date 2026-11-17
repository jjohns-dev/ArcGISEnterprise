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
        Query where clause. Quote string literals (status='open'). If a value comes from user input, double any single quotes in it (O'Brien -> O''Brien) so it cannot change the clause
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object. Stops with an error when the service returns an error (e.g., an unknown field).
    .EXAMPLE
        PS C:\> Invoke-ServerHostedFeatureQuery -Where 'ObjectId=1001' -ServiceName MyService -layerId 0 @commonParams
        Query MyServer LayerId 0 for a record with ObjectId 1001
    .EXAMPLE
        PS C:\> Invoke-ServerHostedFeatureQuery -Where "status = 'open' AND amount > 2.5" -ServiceName MyService @commonParams
        Query for records by a string field and a decimal comparison
    .EXAMPLE
        PS C:\> Invoke-ServerHostedFeatureQuery -Where "status IN ('open','pending') OR name LIKE 'abc%'" -ServiceName MyService @commonParams
        Query using IN and LIKE
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
        [ValidateScript({ $_ -match $where_regex }, ErrorMessage = 'Where clause [{0}] contains unsupported characters.')]
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
            Headers = @{ 'X-Esri-Authorization' = 'Bearer {0}' -f $Token }
            Body   = @{
                f         = 'json'
                where     = $Where
                outFields = '*'
                #returnGeometry     = $true
                #returnIdsOnly      = $false
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE QUERY
        $response = Invoke-RestMethod @restParams

        # THE SERVICE REPORTS QUERY ERRORS IN AN HTTP 200 BODY, SO INVOKE-RESTMETHOD DOES NOT THROW
        if ($response.error) {
            Write-Error -Message ('Query failed for [{0}] layer [{1}]: {2} {3}' -f $ServiceName, $LayerId, $response.error.code, $response.error.message) -ErrorAction Stop
        }
        $response
    }
}
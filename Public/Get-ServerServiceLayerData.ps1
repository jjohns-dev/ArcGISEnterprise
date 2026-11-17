function Get-ServerServiceLayerData {
    <#
    .SYNOPSIS
        Find data in an ArcGIS Server service layer
    .DESCRIPTION
        Query an ArcGIS Server service layer for data. This queries all data and returns all fields.
    .PARAMETER LayerId
        Service Layer ID
    .PARAMETER ServiceName
        Name of service
    .PARAMETER Where
        Where clause for the query filter. Quote string literals (status='open'). If a value comes from user input, double any single quotes in it (O'Brien -> O''Brien) so it cannot change the clause
    .PARAMETER FolderName
        Folder name in ArcGIS Server
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Porta token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object. Stops with an error when the service returns an error (e.g., an unknown field).
    .EXAMPLE
        PS C:\> Get-ServerServiceLayerData @cmnParams -ServiceName 'Geology' -LayerId 0
        Returns all data for the first layer of the 'Geology' service
    .EXAMPLE
        PS C:\> Get-ServerServiceLayerData @cmnParams -ServiceName 'Geology' -FolderName 'Hosted' -LayerId 0 -Where "rocktype IN ('basalt','granite') AND depth > 2.5"
        Returns features matching a string list and a decimal comparison
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/services-reference/enterprise/query-feature-service-layer/
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    [Alias('Find-ServerServiceLayerData')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Service Layer ID')]
        [ValidateNotNullOrEmpty()]
        [Alias('Layer')]
        [System.Int32] $LayerId,

        [Parameter(Mandatory = $true, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $false, HelpMessage = 'Where clause for the query filter')]
        [ValidateScript({ $_ -match $where_regex }, ErrorMessage = 'Where clause [{0}] contains unsupported characters.')]
        [System.String] $Where = 'objectid >= 0', #'globalid >= 0' '1=1'

        [Parameter(Mandatory = $false, HelpMessage = 'Folder name')]
        [ValidateNotNullOrEmpty()]
        [Alias('Folder')]
        [System.String] $FolderName,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Server context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal token')]
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
            Uri     = if ($PSBoundParameters.ContainsKey('FolderName')) {
                '{0}/rest/services/{1}/{2}/FeatureServer/{3}/query' -f $Context, $FolderName, $ServiceName, $LayerId
            }
            else {
                '{0}/rest/services/{1}/FeatureServer/{2}/query' -f $Context, $ServiceName, $LayerId
            }
            Method  = 'GET'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
            Body    = @{
                f         = 'json'
                where     = $Where
                outFields = '*'
            }
        }

        # SEND THE TOKEN IN A HEADER, NOT THE URL
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams['Headers']['X-Esri-Authorization'] = 'Bearer {0}' -f $Token }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Query parameters: [{0}]' -f ($restParams['Body'] | ConvertTo-Json -Compress))

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        $response = Invoke-RestMethod @restParams

        # THE SERVICE REPORTS QUERY ERRORS IN AN HTTP 200 BODY, SO INVOKE-RESTMETHOD DOES NOT THROW
        if ($response.error) {
            Write-Error -Message ('Query failed for [{0}] layer [{1}]: {2} {3}' -f $ServiceName, $LayerId, $response.error.code, $response.error.message) -ErrorAction Stop
        }
        $response
    }
}
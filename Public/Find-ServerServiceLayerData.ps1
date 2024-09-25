function Find-ServerServiceLayerData {
    <#
    .SYNOPSIS
        Find data in an ArcGIS Server service layer
    .DESCRIPTION
        Query an ArcGIS Server service layer for data. This queries all data and returns all fields.
    .PARAMETER LayerId
        Service Layer ID
    .PARAMETER ServiceName
        Name of service
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
        System.Object.
    .EXAMPLE
        PS C:\> Find-ServerServiceLayerData @cmnParams -ServiceName 'Geology' -LayerId 0
        Returns data for the first layer of the 'Geology' service
    .NOTES
        Name:     Find-ServerServiceLayerData
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-09-25
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/services-reference/enterprise/query-feature-service-layer/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Service Layer ID')]
        [ValidateNotNullOrEmpty()]
        [Alias('Layer')]
        [System.Int32] $LayerId,

        [Parameter(Mandatory = $true, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

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
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
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
            Method  = 'POST'
            Body    = @{
                f         = 'json'
                token     = $Token
                where     = 'objectid >= 0'
                outFields = '*'
            }
            Headers = @{
                referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
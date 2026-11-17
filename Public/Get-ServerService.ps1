function Get-ServerService {
    <#
    .SYNOPSIS
        Get ArcGIS Server service metadata
    .DESCRIPTION
        Get ArcGIS Server service metadata
    .PARAMETER ServiceName
        Name of service
    .PARAMETER ServiceType
        Type of service (e.g., FeatureServer or MapServer)
    .PARAMETER FolderName
        Folder name in ArcGIS Server
    .PARAMETER Admin
        Use admin endpoint
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
        PS C:\> Get-ServerService @cmnParams -Folder 'Energy' -ServiceName 'Geology' -ServiceType 'FeatureServer'
        Returns service metadata for the 'Geology' FeatureServer in the 'Energy' folder
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/service/
        https://developers.arcgis.com/rest/services-reference/enterprise/get-started-with-the-services-directory/
        Performance Testing:
        Using custom properties instead of custom objects for output appears to be slightly faster, but only slightly.
        Below is the code used to test performance. The cmdlet "Test-Performance" requires the SecurityTools modules.
        Test-Performance -Runs 100 -ScriptBlock {
            $params = @{
                Context     = 'https://sampleserver6.arcgisonline.com/arcgis'
                ServiceName = 'DamageAssessment'
                ServiceType = 'FeatureServer'
            }
            Get-ServerService @params | Out-Null
        }
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $true, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        #[ValidateSet('FeatureServer', 'MapServer')]
        [System.String] $ServiceType,

        [Parameter(Mandatory = $false, HelpMessage = 'Folder name')]
        [ValidateNotNullOrEmpty()]
        [Alias('Folder')]
        [System.String] $FolderName,

        [Parameter(Mandatory = $false, HelpMessage = 'Use admin endpoint')]
        [System.Management.Automation.SwitchParameter] $Admin,

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
            Uri     = if ($PSBoundParameters.ContainsKey('Admin')) {
                if ($PSBoundParameters.ContainsKey('FolderName')) {
                    '{0}/admin/services/{1}/{2}.{3}' -f $Context, $FolderName, $ServiceName, $ServiceType
                }
                else {
                    '{0}/admin/services/{1}.{2}' -f $Context, $ServiceName, $ServiceType
                }
            }
            else {
                if ($PSBoundParameters.ContainsKey('FolderName')) {
                    '{0}/rest/services/{1}/{2}/{3}' -f $Context, $FolderName, $ServiceName, $ServiceType
                }
                else {
                    '{0}/rest/services/{1}/{2}' -f $Context, $ServiceName, $ServiceType
                }
            }
            Method  = 'GET'
            Body    = @{ f = 'json' }
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
        }

        # SEND THE TOKEN IN A HEADER, NOT THE URL
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams['Headers']['X-Esri-Authorization'] = 'Bearer {0}' -f $Token }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Requesting service [{0}]' -f $restParams.Uri)

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
function Get-ServerHostedFeatureService {
    <#
    .SYNOPSIS
        Get Hosted Feature Service
    .DESCRIPTION
        Get Hosted Feature Service from ArcGIS Server
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
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
        PS C:\> Get-ServerHostedFeatureService -Context 'https://arcgis.com/arcgis' -ServiceName myFeatureService
        Returns the Feature Service with name 'myFeatureService'
    .NOTES
        Name:     Get-ServerHostedFeatureService
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-06
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/services-reference/enterprise/layer-feature-service-.htm
    #>
    [CmdletBinding()]
    [Alias('Get-ServerHostedFeatureServer')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal Hosted Feature Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

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
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/rest/services/Hosted/{1}/FeatureServer' -f $Context, $ServiceName
            Method = 'GET'
            Body   = @{ token = $Token; f = 'json' }
        }

        # WRITE VERBOSE MESSAGE
        Write-Verbose -Message ('Endpoint URI: [{0}]' -f $restParams['Uri'])

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
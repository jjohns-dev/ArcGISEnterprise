function Get-PortalGroupItemJobStatus {
    <#
    .SYNOPSIS
        Get job status for Portal Group export job
    .DESCRIPTION
        Get job status for Portal Group export job
    .PARAMETER JobId
        Portal group export job ID
    .PARAMETER Key
        Portal group export job key (only required for non-admin users)
    .PARAMETER PortalId
        Portal application ID
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
        PS C:\> Get-PortalGroupItemJobStatus @cmnParams -ItemId 0123456789ABCDEF
        Returns the job status information for the Portal Group export job with the ID 0123456789ABCDEF
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/export-group-content/
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal job ID')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $JobId,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal group export job key')]
        [ValidatePattern('[A-Za-z0-9]{43}')]
        [System.String] $Key,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal application ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF',

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
            Uri     = '{0}/sharing/rest/portals/{1}/jobs/{2}' -f $Context, $PortalId, $JobId
            Method  = 'GET'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority; 'X-Esri-Authorization' = 'Bearer {0}' -f $Token }
            Body    = @{ f = 'json' }
        }

        # ADD KEY IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Key')) { $restParams['Uri'] += ('?key={0}' -f $Key) }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
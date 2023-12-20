function Get-ServerServiceInfo {
    <# =========================================================================
    .SYNOPSIS
        Get ArcGIS Server service info
    .DESCRIPTION
        Get ArcGIS Server service info including folder(s)
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Get-ServerServiceFolder
        Returns an service info including folders from ArcGIS Server
    .NOTES
        Name:     Get-ServerServiceFolder
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2023-12-20
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
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

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/rest/services' -f $Context
            Method = 'GET'
            Body   = @{ f = 'json' }
        }

        # ADD TOKEN IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams.Body['token'] = $Token }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
    }
    Process {
        # GET FOLDERS
        Invoke-RestMethod @restParams
    }
}
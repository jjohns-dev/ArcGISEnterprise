function Set-PortalConnection {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .PARAMETER Context
        Portal for ArcGIS context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Enterprise token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Set-PortalConnection
        Sets the default Portal for ArcGIS connection parameters for subsequent cmdlet calls.
    .NOTES
        Name:     Set-PortalConnection
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-11-25
        - Version history is captured in repository commit history
        Comments:
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal for ArcGIS context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Enterprise token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # SET DEFAULT PARAMETERS
        $PSDefaultParameterValues['*-Portal*:Token'] = $Token
        $PSDefaultParameterValues['*-Portal*:Context'] = $Context
    }
}
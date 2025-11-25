function Set-GeoEventConnection {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .PARAMETER Context
        GeoEvent context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Enterprise token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Set-GeoEventConnection
        Sets the default GeoEvent connection parameters for subsequent cmdlet calls.
    .NOTES
        Name:     Set-GeoEventConnection
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-11-25
        - Version history is captured in repository commit history
        Comments:
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Target ArcGIS GeoEvent context')]
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
        $PSDefaultParameterValues['*-GeoEventServer*:Token'] = $Token
        $PSDefaultParameterValues['*-GeoEventServer*:Context'] = $Context
    }
}
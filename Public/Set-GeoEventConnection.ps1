[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Intentionally writes to $PSDefaultParameterValues to set default connection parameters for downstream cmdlets.')]
function Set-GeoEventConnection {
    <#
    .SYNOPSIS
        Set default GeoEvent connection parameters
    .DESCRIPTION
        Set default GeoEvent connection parameters for subsequent cmdlet calls.
    .PARAMETER Context
        GeoEvent context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Enterprise token
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Set-GeoEventConnection
        Sets the default GeoEvent connection parameters for subsequent cmdlet calls.
    .NOTES
        Name:     Set-GeoEventConnection
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-11-26
        - Version history is captured in repository commit history
        Comments:
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Target ArcGIS GeoEvent context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Enterprise token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($Context, 'Create default connection')) {
            # SET DEFAULT PARAMETERS
            $PSDefaultParameterValues['*-GeoEventServer*:Token'] = $Token
            $PSDefaultParameterValues['*-GeoEventServer*:Context'] = $Context

            # OUTPUT SUCCESS MESSAGE
            if ($LASTEXITCODE -eq 0) { Write-Verbose -Message ('GeoEvent connection set to: {0}' -f $Context) }
        }
    }
}
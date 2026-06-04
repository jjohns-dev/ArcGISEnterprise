function Set-ServerConnection {
    <#
    .SYNOPSIS
        Set default ArcGIS Server connection parameters
    .DESCRIPTION
        Set default ArcGIS Server connection parameters for subsequent cmdlet calls.
    .PARAMETER Context
        ArcGIS Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Enterprise token
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Set-ServerConnection
        Sets the default ArcGIS Server connection parameters for subsequent cmdlet calls.
    .NOTES
        Name:     Set-ServerConnection
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-11-26
        - Version history is captured in repository commit history
        Comments:
    #>
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Intentionally writes to $PSDefaultParameterValues to set default connection parameters for downstream cmdlets.')]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Target ArcGIS Server context')]
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
            $PSDefaultParameterValues['*-Server*:Token'] = $Token
            $PSDefaultParameterValues['*-Server*:Context'] = $Context

            # OUTPUT SUCCESS MESSAGE
            if ($LASTEXITCODE -eq 0) { Write-Verbose -Message ('Server connection set to: {0}' -f $Context) }
        }
    }
}
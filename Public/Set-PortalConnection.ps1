function Set-PortalConnection {
    <#
    .SYNOPSIS
        Set default Portal for ArcGIS connection parameters
    .DESCRIPTION
        Set default Portal for ArcGIS connection parameters for subsequent cmdlet calls.
    .PARAMETER Context
        Portal for ArcGIS context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Enterprise token
    .INPUTS
        None.
    .OUTPUTS
        None.
    .EXAMPLE
        PS C:\> Set-PortalConnection
        Sets the default Portal for ArcGIS connection parameters for subsequent cmdlet calls.
    .NOTES
        Name:     Set-PortalConnection
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-11-26
        - Version history is captured in repository commit history
        Comments:
    #>
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Intentionally writes to $PSDefaultParameterValues to set default connection parameters for downstream cmdlets.')]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal for ArcGIS context')]
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
            $PSDefaultParameterValues['*-Portal*:Token'] = $Token
            $PSDefaultParameterValues['*-Portal*:Context'] = $Context

            # OUTPUT SUCCESS MESSAGE
            Write-Verbose -Message ('Portal connection set to: {0}' -f $Context)
        }
    }
}
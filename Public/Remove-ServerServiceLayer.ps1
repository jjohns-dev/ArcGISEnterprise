function Remove-ServerServiceLayer {
    <# =========================================================================
    .SYNOPSIS
        Delete ArcGIS Server Service layer
    .DESCRIPTION
        Delete ArcGIS Server Service layer
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
    .PARAMETER LayerId
        Service layer ID
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
        PS C:\> Remove-ServerServiceLayer
        Explanation of what the example does
    .NOTES
        Name:     Remove-ServerServiceLayer
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-07
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/services-reference/online/delete-from-definition-feature-service-.htm
    ========================================================================= #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal Hosted Feature Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $true, HelpMessage = 'Layer ID')]
        [ValidateNotNullOrEmpty()]
        [System.Int32] $LayerId,

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
        # UPDATE NAME PROPERTY IN TEMPLATE
        $restParams = @{
            Uri    = '{0}/rest/admin/services/Hosted/{1}/FeatureServer/deleteFromDefinition' -f $Context, $ServiceName
            Method = 'POST'
            Body   = @{
                f                    = 'json'
                token                = $Token
                deleteFromDefinition = @{ layers = @( @{ id = $LayerId } ) } | ConvertTo-Json -Compress
            }
        }

        # WRITE VERBOSE MESSAGE
        Write-Verbose -Message ('Endpoint URI: [{0}]' -f $restParams['Uri'])

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($ServiceName, ('Delete Portal item layer [{0}]' -f $LayerId))) {

            Write-Verbose -Message 'Invoking REST API endpoint "deleteFromDefinition"'

            # INVOKE TRUNCATE PROCESS
            Invoke-RestMethod @restParams
        }
    }
}
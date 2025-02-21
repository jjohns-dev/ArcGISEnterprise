function Clear-ServerFeatureLayer {
    <#
    .SYNOPSIS
        Truncate Feature Service Layer features and attachments.
    .DESCRIPTION
        The truncate operation supports deleting all features or attachments in a hosted feature service layer.
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
    .PARAMETER LayerId
        Service Layer ID
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
        PS C:\> Clear-ServerFeatureLayer
        Explanation of what the example does
    .NOTES
        Name:     Clear-ServerFeatureLayer
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-02-20
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/services-reference/online/truncate-feature-layer-.htm
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Feature Service name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $true, HelpMessage = 'Layer index')]
        [ValidateNotNullOrEmpty()]
        [System.Int32] $LayerId,

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
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/admin/services/{1}/FeatureServer/{2}/truncate' -f $Context, $ServiceName, $LayerId
            Method  = 'POST'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
            Body    = @{
                f              = 'json'
                token          = $Token
                attachmentOnly = $false
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($ServiceName, ('Truncate service layer ID [{0}]' -f $LayerId))) {

            Write-Verbose -Message 'Invoking REST API endpoint "truncate"'

            # INVOKE TRUNCATE PROCESS
            Invoke-RestMethod @restParams
        }
    }
}
function Remove-PortalItem {
    <#
    .SYNOPSIS
        Delete Portal Item
    .DESCRIPTION
        Delete Portal Item. Use this to delete Hosted Feature Services.
    .PARAMETER UserName
        Owner of Hosted Feature Service
    .PARAMETER ItemId
        Id of Portal item
    .PARAMETER Force
        Use "Force" to remove orphaned items
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
        PS C:\> Remove-PortalItem
        Explanation of what the example does
    .NOTES
        Name:     Remove-PortalItem
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-07
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/delete-item.htm
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Owner of Hosted Feature Service')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

        [Parameter(Mandatory = $true, HelpMessage = 'Id of Portal item')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ItemId,

        [Parameter(Mandatory = $false, HelpMessage = 'Use "Force" to remove orphaned items')]
        [System.Boolean] $Force = $false,

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
            Uri    = '{0}/sharing/rest/content/users/{1}/items/{2}/delete' -f $Context, $UserName, $ItemId
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
                force = $Force
            }
        }

        # WRITE VERBOSE MESSAGE
        Write-Verbose -Message ('Endpoint URI: [{0}]' -f $restParams['Uri'])

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($ItemId, ('Delete Portal item from user [{0}]' -f $UserName))) {

            Write-Verbose -Message 'Invoking REST API endpoint "deleteFromDefinition"'

            # INVOKE TRUNCATE PROCESS
            Invoke-RestMethod @restParams
        }
    }
}
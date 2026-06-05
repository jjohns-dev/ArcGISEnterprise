function Export-PortalGroupItem {
    <#
    .SYNOPSIS
        Exports all exportable content from a Portal group.
    .DESCRIPTION
        Extracts all supported items, or a set of supported items, from a group and exports
        them into an export package (.epk) that can be uploaded and imported into a separate
        ArcGIS Enterprise organization.
    .PARAMETER GroupID
        Portal Group ID
    .PARAMETER Synchronous
        Execute job synchronously
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
        PS C:\> Export-PortalGroupItem -GroupId 'ad46a0e1a74742aeb4314250c3ea90e4'
        Starts and asynchronous job to export of all content from the group with ID 'ad46a0e1a74742aeb4314250c3ea90e4'
    .NOTES
        Name:     Export-PortalGroupItem
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-01-15
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/export-group-content/
        https://www.esri.com/arcgis-blog/products/arcgis-enterprise/administration/moving-content-across-tiered-arcgis-enterprise-environments/
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal Group ID')]
        [ValidatePattern('^[A-Za-z0-9]{32}$')]
        [System.String] $GroupID,

        [Parameter(Mandatory = $false, HelpMessage = 'Execute job synchronously')]
        [System.Management.Automation.SwitchParameter] $Synchronous,

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
            Uri     = '{0}/sharing/rest/community/groups/{1}/export' -f $Context, $GroupID
            Method  = 'POST'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
            Form    = @{
                f              = 'json'
                token          = $Token
                async          = $true
                itemIdList     = ''
                outputFilename = ''
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # ADD ASYNC IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Synchronous')) {
            # THIS DOES NOT SEEM TO WORK AS DOCUMENTED IN THE API. MULTIPLE ATTEMPTS HAVE BEEN MADE
            # TO MIMIC THE UI BEHAVIOR, BUT THE JOB ALWAYS RETURNS HTML INSTEAD OF AN OCTET STREAM
            # AS DOCUMENTED.

            # REMOVE JSON FORMAT
            $restParams['Form']['f'] = 'html'

            # SET ASYNC TO TRUE
            $restParams['Form']['async'] = $false

            # OUTPUT VERBOSE
            Write-Verbose -Message ('Request body: {0}' -f ($restParams['Form'] | ConvertTo-Json))

            # INVOKE REQUEST AS WEB REQUEST
            Invoke-WebRequest @restParams
        }
        else {
            # INVOKE REQUEST
            Invoke-RestMethod @restParams
        }
    }
}
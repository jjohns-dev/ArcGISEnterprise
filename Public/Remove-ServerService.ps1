function Remove-ServerService {
    <#
    .SYNOPSIS
        Delete Feature Service from ArcGIS Server
    .DESCRIPTION
        Delete Feature Service from ArcGIS Server
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
    .PARAMETER Folder
        Service folder (use "Hosted" for Hosted Feature Service)
    .PARAMETER Type
        Service type
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
        PS C:\> Remove-ServerService
        Explanation of what the example does
    .NOTES
        Name:     Remove-ServerService
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-07
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/enterprise-administration/server/deleteservices.htm
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal Hosted Feature Service Name')]
        [ValidatePattern('^[\w]+$')]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $false, HelpMessage = 'Service folder (use "Hosted" for Hosted Feature Service)')]
        [ValidatePattern('^[\w]+$')]
        [System.String] $Folder,

        [Parameter(Mandatory = $true, HelpMessage = 'Service type')]
        [ValidateSet('FeatureServer', 'MapServer')]
        [System.String] $Type,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Server context')]
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
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/admin/services/deleteServices' -f $Context
            Method = 'POST'
            Body   = @{
                f        = 'json'
                token    = $Token
                services = @{ services = @(@{folderName = $Folder; serviceName = $ServiceName; type = $Type}) } | ConvertTo-Json -Compress
            }
        }

        # WRITE VERBOSE MESSAGE
        Write-Verbose -Message ('Endpoint URI: [{0}]' -f $restParams['Uri'])

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($ServiceName, ('Delete service type [{0}] from folder [{1}]' -f $Type, $Folder))) {

            Write-Verbose -Message 'Invoking REST API endpoint "deleteServices"'

            # INVOKE TRUNCATE PROCESS
            Invoke-RestMethod @restParams
        }
    }
}
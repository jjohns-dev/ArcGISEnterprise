function Remove-ServerFolder {
    <#
    .SYNOPSIS
        Removes folder in ArcGIS Server
    .DESCRIPTION
        Removes folder in ArcGIS Server and all servers within the folder
    .PARAMETER FolderName
        ArcGIS Server folder name
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Remove-ServerFolder -FolderName 'my_test_folder' @commonParams
        Removes ArcGIS Server folder named 'my_test_folder' and all services within the folder
    .NOTES
        Name:     Remove-ServerFolder
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-21
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/enterprise-administration/server/deletefolder.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'New ArcGIS Server folder name')]
        [ValidatePattern('^\w{1,30}$')]
        [System.String] $FolderName,

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
            Uri    = '{0}/admin/services/{1}/deleteFolder' -f $Context, $FolderName
            Method = 'POST'
            Body   = @{ f = 'json'; token = $Token }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
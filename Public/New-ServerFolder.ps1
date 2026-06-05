function New-ServerFolder {
    <#
    .SYNOPSIS
        Create new folder in ArcGIS Server
    .DESCRIPTION
        Create new folder in ArcGIS Server
    .PARAMETER FolderName
        New ArcGIS Server folder name
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
        PS C:\> New-ServerFolder -FolderName 'my_test_folder' @commonParams
        Creates a new folder named 'my_test_folder' in ArcGIS Server
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/enterprise/create-folder.htm
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([System.Management.Automation.PSCustomObject])]
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
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/admin/services/createFolder' -f $Context
            Method = 'POST'
            Body   = @{
                f          = 'json'
                token      = $Token
                folderName = $FolderName
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        if ($PSCmdlet.ShouldProcess($FolderName, 'Create ArcGIS Server folder')) {
            Invoke-RestMethod @restParams
        }
    }
}
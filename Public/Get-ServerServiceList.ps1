function Get-ServerServiceList {
    <#
    .SYNOPSIS
        Get ArcGIS Server service information
    .DESCRIPTION
        Get ArcGIS Server service information including folder(s)
    .PARAMETER FolderName
        Target folder to retrieve service info
    .PARAMETER Admin
        Use admin API endpoint
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> Get-ServerServiceList
        Returns an service info including folders from ArcGIS Server
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/services-reference/enterprise/get-started-with-the-services-directory.htm (REST endpoint)
        https://developers.arcgis.com/rest/enterprise-administration/server/services.htm (Admin endpoint)
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    [Alias('Get-ServerServiceInfo')]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Target folder to retrieve service info')]
        [ValidateNotNullOrEmpty()]
        [Alias('Folder')]
        [System.String] $FolderName,

        [Parameter(Mandatory = $false, HelpMessage = 'Use admin API endpoint')]
        [System.Management.Automation.SwitchParameter] $Admin,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal token')]
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
            Uri    = '{0}/rest/services' -f $Context
            Method = 'GET'
            Body   = @{ f = 'json' }
        }

        # CHECK FOR ADMIN
        if ($PSBoundParameters.ContainsKey('Admin')) {
            # CHECK FOR FOLDER
            if ($PSBoundParameters.ContainsKey('FolderName')) {
                # SET URI WITH FOLDER
                $restParams['Uri'] = '{0}/admin/services/{1}' -f $Context, $FolderName
            }
            else {
                # SET URI WITHOUT FOLDER
                $restParams['Uri'] = '{0}/admin/services' -f $Context
            }
        }
        else {
            # CHECK FOR FOLDER NAME PARAMETER
            if ($PSBoundParameters.ContainsKey('FolderName')) {
                # UPDATE URI WITH FOLDER PATH
                $restParams['Uri'] = '{0}/rest/services/{1}' -f $Context, $FolderName
            }
        }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Target URI [{0}]' -f $restParams.Uri)

        # ADD TOKEN IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams['Headers'] = @{ 'X-Esri-Authorization' = 'Bearer {0}' -f $Token } }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # GET FOLDERS
        Invoke-RestMethod @restParams
    }
}
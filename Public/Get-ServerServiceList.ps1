function Get-ServerServiceList {
    <#
    .SYNOPSIS
        Get ArcGIS Server service information
    .DESCRIPTION
        Get ArcGIS Server service information including folder(s)
    .PARAMETER FolderName
        Target folder to retrieve service info
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
        Name:     Get-ServerServiceList
        Author:   Justin Johns
        Version:  0.1.1 | Last Edit: 2024-03-20
        - 0.1.1 - (2024-03-20) Changed name, added ability to get service information for services in specified folder
        - 0.1.0 - (2023-12-20) Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/services-reference/enterprise/get-started-with-the-services-directory.htm
    #>
    [CmdletBinding()]
    [Alias('Get-ServerServiceInfo')]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Target folder to retrieve service info')]
        [ValidateNotNullOrEmpty()]
        [Alias('Folder')]
        [System.String] $FolderName,

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
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/rest/services' -f $Context
            Method = 'GET'
            Body   = @{ f = 'json' }
        }

        # CHECK FOR FOLDER NAME PARAMETER
        if ($PSBoundParameters.ContainsKey('FolderName')) {
            # UPDATE URI WITH FOLDER PATH
            $restParams['Uri'] = '{0}/rest/services/{1}' -f $Context, $FolderName
        }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Target URI [{0}]' -f $restParams.Uri)

        # ADD TOKEN IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams.Body['token'] = $Token }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # GET FOLDERS
        Invoke-RestMethod @restParams
    }
}
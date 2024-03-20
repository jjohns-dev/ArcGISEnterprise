function Get-ServerServiceList {
    <#
    .SYNOPSIS
        Get list of services from ArcGIS Server
    .DESCRIPTION
        Get list of services and info from ArcGIS Server
    .PARAMETER FolderName
        Name of folder in ArcGIS Server
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
        PS C:\> Get-ServerServiceList -Context 'https://arcgis.com/arcgis' -Token $token
        Returns all services in ArcGIS Server
    .NOTES
        General notes:
        https://developers.arcgis.com/rest/enterprise-administration/server/services.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Name of folder in ArcGIS Server')]
        [ValidateNotNullOrEmpty()]
        [Alias('Folder')]
        [System.String] $FolderName,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/admin/services' -f $Context
            Method = 'GET'
            Body   = @{ f = 'json' }
        }

        # CHECK FOR FOLDER NAME PARAMETER
        if ($PSBoundParameters.ContainsKey('FolderName')) {
            # ADD FOLDER TO URI
            $restParams['Uri'] = '{0}/admin/services/{1}' -f $Context, $FolderName
        }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Target URI [{0}]' -f $restParams.Uri)

        # ADD TOKEN IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams.Body['token'] = $Token }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
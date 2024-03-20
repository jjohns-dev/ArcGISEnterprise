function Get-ServerServiceItemInfo {
    <#
    .SYNOPSIS
        Get ArcGIS Server service item information
    .DESCRIPTION
        Get ArcGIS Server service item information/details
    .PARAMETER Service
        Service object returned from Get-ServerServiceList or Get-ServerAdminServiceList
    .PARAMETER Folder
        Folder in ArcGIS Server
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
        PS C:\> Get-ServerServiceItemInfo -Context 'https://arcgis.com/arcgis' -Token $token -Service $s
        Returns the service item info for service $s
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Service object returned from Get-ServerServiceList or Get-ServerAdminServiceList')]
        [ValidateScript({ $_.serviceName -and $_.type })]
        [System.Object] $Service,

        [Parameter(HelpMessage = 'Folder')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Folder,

        [Parameter(Mandatory, Position = 0, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        # SET URI PATH
        if ($PSBoundParameters.ContainsKey('Folder')) {
            $uri = '{0}/admin/services/{1}/{2}.{3}/iteminfo' -f $Context, $Folder, $Service.serviceName, $Service.type
        }
        else {
            $uri = '{0}/admin/services/{1}.{2}/iteminfo' -f $Context, $Service.serviceName, $Service.type
        }

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = $uri
            Method = 'GET'
            Body   = @{ f = 'json' }
        }

        # ADD TOKEN IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams.Body['token'] = $Token }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
function Invoke-PortalItemAnalysis {
    <#
    .SYNOPSIS
        Invoke Portal item analysis
    .DESCRIPTION
        Invoke API endpoint "analyze." Analysis file prior to publishing
    .PARAMETER ItemId
        Id of Portal item
    .PARAMETER FileType
        File type to be analyzed
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
        PS C:\> Invoke-PortalItemAnalysis -ItemId ea42cab6e3654405b54f0b2b50a0041b -FileType CSV @commonParams
        Analyzes the CSV item with ID ea42cab6e3654405b54f0b2b50a0041b
    .NOTES
        Name:     Invoke-PortalItemAnalysis
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-19
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/analyze.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Id of Portal item')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $ItemId,

        [Parameter(Mandatory = $true, HelpMessage = 'File type to be analyzed')]
        [ValidateSet('shapefile', 'csv', 'excel', 'geoPackage')]
        [System.String] $FileType,

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
        # SET PARAMETERS FOR ANALYSIS JOB
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/features/analyze' -f $Context
            Method = 'POST'
            Body   = @{
                f        = 'json'
                token    = $Token
                itemId   = $ItemId
                filetype = $FileType
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE UPLOAD
        Invoke-RestMethod @restParams
    }
}
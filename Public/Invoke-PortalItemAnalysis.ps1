function Invoke-PortalItemAnalysis {
    <#
    .SYNOPSIS
        Invoke Portal item analysis
    .DESCRIPTION
        Invoke API endpoint "analyze." Analysis file prior to publishing
    .PARAMETER ItemId
        Id of previously uploaded Portal item
    .PARAMETER File
        System.IO.FileInfo object to POST and analyze
    .PARAMETER FileType
        File type
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
    .EXAMPLE
        PS C:\> Invoke-PortalItemAnalysis -File C:\file.csv -FileType CSV @commonParams
        Analyzes the CSV file C:\file.csv
    .NOTES
        Name:     Invoke-PortalItemAnalysis
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-19
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/analyze.htm
    #>
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Analyze is a read-only operation; it does not change any server state.')]
    [CmdletBinding(DefaultParameterSetName = '_itid')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = '_itid', HelpMessage = 'Id of previously uploaded Portal item')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $ItemId,

        [Parameter(Mandatory = $true, ParameterSetName = '_post', HelpMessage = 'System.IO.FileInfo object to POST and analyze')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [System.IO.FileInfo] $File,

        [Parameter(Mandatory = $true, HelpMessage = 'File type')]
        [ValidateSet('shapefile', 'csv', 'excel', 'geoPackage')]
        [System.String] $FileType,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
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
        # SET PARAMETERS FOR ANALYSIS JOB
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/features/analyze' -f $Context
            Method = 'POST'
        }

        # SET QUERY PARAMS
        $qParams = @{ f = 'json'; token = $Token; fileType = $FileType }

        # WRITE VERBOSE PARAMETER SET
        Write-Verbose -Message ('Parameter set [{0}]' -f $PSCmdlet.ParameterSetName)

        # CHECK PARAMETER GROUP
        if ($PSCmdlet.ParameterSetName -EQ '_itid') {
            # ADD APPROPRIATE PARAMETERS FOR PORTAL ITEM ANALYZE
            $qParams.Add('itemId', $ItemId)
            $restParams.Add('Body', $qParams)
        }
        elseif ($PSCmdlet.ParameterSetName -EQ '_post') {
            # ADD APPROPRIATE PARAMETERS FOR POST AND ANALYZE
            $qParams.Add('file', $File)
            $restParams.Add('Form', $qParams)
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE UPLOAD
        Invoke-RestMethod @restParams
    }
}
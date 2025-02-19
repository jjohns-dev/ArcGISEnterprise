function Edit-ServerFeature {
    <#
    .SYNOPSIS
        Edit Feature Service
    .DESCRIPTION
        Edit Feature Service using the /applyEdits endpoint. This allows for adding, updating, or deleting features.
    .PARAMETER Add
        Feature to add to the Feature Service
    .PARAMETER Update
        Feature to update
    .PARAMETER DeleteObjectId
        ObjectId of feature to delete
    .PARAMETER DeleteGlobalId
        GlobalId of feature to delete
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
    .PARAMETER LayerId
        Service Layer ID
    .PARAMETER FolderName
        Server Service Folder Name
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
        PS C:\> $feature = @{ attributes = @{ countyname = 'Fairfax'; countyid = 596; us_county_fips = 59; stateid = 39; us_state_fips = 51; us_full_fips = 51059 } }
        PS C:\> Edit-ServerFeature @cmnParams -Add $feature
        Adds a new feature to the Feature Service
    .EXAMPLE
        PS C:\> $feature = @{ attributes = @{ PointName = 'test'; Field2 = 'test2' }; geometry = @{ x = -77.306373; y = 38.855747; spatialReference = @{ wkid = 4326 } } }
        PS C:\> Edit-ServerFeature @cmnParams -Add $feature
        Adds a new feature with geometry to the Feature Service
    .EXAMPLE
        PS C:\> Edit-ServerFeature @cmnParams -DeleteObjectId @(1, 2, 3)
        Deletes features with IDs 1, 2, and 3
    .NOTES
        Name:     Edit-ServerFeature
        Author:   Justin Johns
        Version:  0.2.0 | Last Edit: 2025-02-19
        - See commit history for version changes
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/services-reference/enterprise/apply-edits-feature-service-layer-.htm
    #>
    [CmdletBinding(DefaultParameterSetName = '_add')]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = '_add', HelpMessage = 'Record/feature to add')]
        [ValidateScript({ $_.psobject.Properties.Name -contains 'attributes' })] # FEATURE MAY ALSO CONTAIN "geometry"
        [ValidateNotNullOrEmpty()]
        [System.Object[]] $Add,

        [Parameter(Mandatory = $true, ParameterSetName = '_upd', HelpMessage = 'Record/feature to update')]
        [ValidateScript({ $_.psobject.Members.Name -contains 'attributes' })]
        [System.Object[]] $Update,

        [Parameter(Mandatory = $true, ParameterSetName = '_doi', HelpMessage = 'ObjectId of record/feature to delete')]
        [ValidateNotNullOrEmpty()]
        [System.Int32[]] $DeleteObjectId,

        [Parameter(Mandatory = $true, ParameterSetName = '_dgi', HelpMessage = 'ObjectId of record/feature to delete')]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^\{[a-f0-9]{8}(-[a-f0-9]{4}){3}-[a-f0-9]{12}\}$')] # {1A9F8368-F9BB-428B-BB03-F45724362DB5}
        [System.String[]] $DeleteGlobalId, # GlobalId DOES NOT APPEAR TO WORK AS DOCUMENTED

        [Parameter(Mandatory = $true, HelpMessage = 'Portal Hosted Feature Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $false, HelpMessage = 'Service Layer ID')]
        [ValidateNotNullOrEmpty()]
        [Alias('Layer')]
        [System.Int32] $LayerId = 0,

        [Parameter(Mandatory = $false, HelpMessage = 'Folder name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $FolderName = 'Hosted',

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
        # SET PARAMETERS FOR ADDING DATA
        $restParams = @{
            Uri    = '{0}/rest/services/{1}/{2}/FeatureServer/{3}/applyEdits' -f $Context, $FolderName, $ServiceName, $LayerId
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
                #async = $true
            }
        }

        # CHECK FOR ADDS, UPDATES, OR DELETES
        if ($PSBoundParameters.ContainsKey('Record')) {
            $restParams.Body['adds'] = $Add | ConvertTo-Json -Depth 10 -Compress -AsArray
        }
        elseif ($PSBoundParameters.ContainsKey('Update')) {
            $restParams.Body['updates'] = $Update | ConvertTo-Json -Depth 10 -Compress -AsArray
        }
        elseif ($PSBoundParameters.ContainsKey('DeleteObjectId')) {
            $restParams.Body['deletes'] = $DeleteObjectId -join ','
        }
        elseif ($PSBoundParameters.ContainsKey('DeleteGlobalId')) {
            Write-Error -Message 'Deletion using GlobalId does not currently work.' -ErrorAction Stop
            $restParams.Body['deletes'] = $DeleteGlobalId -join ','
        }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Request body: {0}' -f ($restParams.Body | ConvertTo-Json -Depth 5 -Compress))

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE DATA ADD
        Invoke-RestMethod @restParams
    }
}
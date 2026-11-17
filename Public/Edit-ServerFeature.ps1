function Edit-ServerFeature {
    <#
    .SYNOPSIS
        Edit Feature Service
    .DESCRIPTION
        Edit Feature Service using the /applyEdits endpoint. This allows for adding, updating, or deleting features.
    .PARAMETER Add
        Feature to add to the Feature Service. A hashtable or object with an 'attributes' key (and optional 'geometry')
    .PARAMETER Update
        Feature to update. A hashtable or object with an 'attributes' key (and optional 'geometry')
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
        PS C:\> $feature = @{ attributes = @{ objectid = 1001; status = 'input_complete' } }
        PS C:\> Edit-ServerFeature @cmnParams -Update $feature
        Updates the status field of the feature with objectid 1001
    .EXAMPLE
        PS C:\> Edit-ServerFeature @cmnParams -DeleteObjectId @(1, 2, 3)
        Deletes features with IDs 1, 2, and 3
    .NOTES
        Status: Stable
        - See commit history for version changes
        Comments:
        https://developers.arcgis.com/rest/services-reference/enterprise/apply-edits-feature-service-layer-.htm
    #>
    [CmdletBinding(DefaultParameterSetName = '_add')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = '_add', HelpMessage = 'Feature to add')]
        [ValidateScript({ ($_ -is [System.Collections.IDictionary] -and $_.Contains('attributes')) -or $_.psobject.Properties.Name -contains 'attributes' })] # FEATURE MAY ALSO CONTAIN "geometry"
        [ValidateNotNullOrEmpty()]
        [System.Object[]] $Add,

        [Parameter(Mandatory = $true, ParameterSetName = '_upd', HelpMessage = 'Feature to update')]
        [ValidateScript({ ($_ -is [System.Collections.IDictionary] -and $_.Contains('attributes')) -or $_.psobject.Properties.Name -contains 'attributes' })]
        [System.Object[]] $Update,

        [Parameter(Mandatory = $true, ParameterSetName = '_doi', HelpMessage = 'ObjectId of feature to delete')]
        [ValidateNotNullOrEmpty()]
        [Alias('Delete')]
        [System.Int32[]] $DeleteObjectId,

        [Parameter(Mandatory = $true, ParameterSetName = '_dgi', HelpMessage = 'ObjectId of feature to delete')]
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
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
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
        if ($PSBoundParameters.ContainsKey('Add')) {
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
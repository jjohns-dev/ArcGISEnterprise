function Remove-ServerServiceFeature {
    <#
    .SYNOPSIS
        Remove ArcGIS Server Feature Service feature
    .DESCRIPTION
        This operation deletes features in a feature layer or table. The operation is performed on a feature service layer resource.
        If no object IDs or where clause is provided, all features in the layer or table will be deleted.
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
    .PARAMETER LayerId
        Service Layer ID
    .PARAMETER ObjectId
        Object IDs of the layer or table to be deleted
    .PARAMETER Where
        Where clause for the query filter
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
        PS C:\> Remove-ServerServiceFeature @commonParams -ServiceName dashboard -LayerId 0
        Delete all data from the "dashboard" Hosted Feature Service layer ID 0
    .EXAMPLE
        PS C:\> Remove-ServerServiceFeature @commonParams -ServiceName dashboard -LayerId 0 -ObjectId @(1, 2, 3)
        Delete features with IDs 1, 2, and 3 from the "dashboard" Hosted Feature Service layer ID 0
    .NOTES
        Name:     Remove-ServerServiceFeature
        Author:   Justin Johns
        Version:  0.2.0 | Last Edit: 2025-02-21
        - see commit history for version changes
        Comments: <Comment(s)>
        - https://developers.arcgis.com/rest/services-reference/enterprise/delete-features/
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [Alias('Clear-ServerHostedFeatureService')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal Hosted Feature Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $true, HelpMessage = 'Layer index')]
        [ValidateNotNullOrEmpty()]
        [Alias('Layer')]
        [System.Int32] $LayerId,

        [Parameter(Mandatory = $false, HelpMessage = 'Object IDs of the layer or table to be deleted')]
        [ValidateNotNullOrEmpty()]
        [System.Int32[]] $ObjectId,

        [Parameter(Mandatory = $false, HelpMessage = 'Where clause for the query filter')]
        [ValidatePattern('^[\w\*\s=<>]+$')]
        [System.String] $Where = 'objectid >= 0',

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
        # SET TRUNCATE PARAMETERS
        $restParams = @{
            Uri    = '{0}/rest/services/{1}/{2}/FeatureServer/{3}/deleteFeatures' -f $Context, $FolderName, $ServiceName, $LayerId
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
                where = $Where
            }
        }

        # ADD OBJECT IDS IF PROVIDED
        if ($PSBoundParameters.ContainsKey('ObjectId')) { $restParams['Body']['objectIds'] = $ObjectId -join ', ' }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Query parameters: [{0}]' -f ($restParams['Body'] | ConvertTo-Json -Compress -Depth 4))

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($ServiceName, ('Purge records from service layer ID [{0}]' -f $LayerId))) {

            Write-Verbose -Message 'Invoking REST API endpoint "deleteFeatures"'

            # INVOKE TRUNCATE PROCESS
            Invoke-RestMethod @restParams
        }
    }
}
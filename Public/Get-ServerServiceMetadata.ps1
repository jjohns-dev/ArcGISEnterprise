function Get-ServerServiceMetadata {
    <#
    .SYNOPSIS
        Get ArcGIS Server service metadata
    .DESCRIPTION
        Get ArcGIS Server service metadata
    .PARAMETER ServiceName
        Name of service
    .PARAMETER ServiceType
        Type of service (e.g., FeatureServer or MapServer)
    .PARAMETER FolderName
        Folder name in ArcGIS Server
    .PARAMETER ReportData
        Return report data
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Porta token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServerServiceMetadata @cmnParams -Folder 'Energy' -ServiceName 'Geology' -ServiceType 'FeatureServer'
        Returns service metadata for the 'Geology' FeatureServer in the 'Energy' folder
    .NOTES
        Name:     Get-ServerServiceMetadata
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-09-20
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/services-reference/enterprise/get-started-with-the-services-directory/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $true, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        #[ValidateSet('FeatureServer', 'MapServer')]
        [System.String] $ServiceType,

        [Parameter(Mandatory = $false, HelpMessage = 'Folder name')]
        [ValidateNotNullOrEmpty()]
        [Alias('Folder')]
        [System.String] $FolderName,

        [Parameter(Mandatory = $false, HelpMessage = 'Return report data')]
        [System.Management.Automation.SwitchParameter] $ReportData,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Server context')]
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
            Uri     = if ($PSBoundParameters.ContainsKey('FolderName')) {
                '{0}/rest/services/{1}/{2}/{3}' -f $Context, $FolderName, $ServiceName, $ServiceType
            }
            else {
                '{0}/rest/services/{1}/{2}' -f $Context, $ServiceName, $ServiceType
            }
            Method  = 'POST'
            Body    = @{
                f     = 'json'
                token = $Token
            }
            Headers = @{
                referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # ADD REPORT DATA IF REQUESTED
        if ($PSBoundParameters.ContainsKey('ReportData')) {
            # INVOKE REQUEST
            $sm = Invoke-RestMethod @restParams

            # CHECK FOR ERRORS
            if ($sm.error) {
                Write-Error -Message $sm.error.message -ErrorAction Stop
            }
            else {
                # OUTPUT REPORT DATA
                [PSCustomObject] @{
                    ServiceName                          = if ($PSBoundParameters.ContainsKey('FolderName')) {
                        '{0}/{1}' -f $FolderName, $ServiceName
                    }
                    else {
                        $ServiceName
                    }
                    ServiceType                          = $ServiceType
                    HasVersionedData                     = $sm.hasVersionedData
                    SupportsDisconnectedEditing          = $sm.supportsDisconnectedEditing
                    SupportsQueryDataElements            = $sm.supportsQueryDataElements
                    SupportsRelationshipsResource        = $sm.supportsRelationshipsResource
                    SyncEnabled                          = $sm.syncEnabled
                    SupportedExportFormats               = $sm.supportedExportFormats
                    SupportedQueryFormats                = $sm.supportedQueryFormats
                    MaxRecordCount                       = $sm.maxRecordCount
                    Capabilities                         = $sm.capabilities
                    Description                          = $sm.description
                    SupportsSplit                        = $sm.advancedEditingCapabilities.supportsSplit
                    SupportsReturnServiceEditsInSourceSR = $sm.advancedEditingCapabilities.supportsReturnServiceEditsInSourceSR
                    SupportsAsyncApplyEdits              = $sm.advancedEditingCapabilities.supportsAsyncApplyEdits
                    WKID                                 = $sm.spatialReference.wkid
                    XYTolerance                          = $sm.spatialReference.xyTolerance
                    ZTolerance                           = $sm.spatialReference.zTolerance
                    MTolderance                          = $sm.spatialReference.mTolerance
                    XMin                                 = $sm.initialExtent.xmin
                    YMin                                 = $sm.initialExtent.ymin
                    XMax                                 = $sm.initialExtent.xmax
                    YMax                                 = $sm.initialExtent.ymax
                    AllowGeometryUpdates                 = $sm.allowGeometryUpdates
                    SupportsApplyEditsWithGlobalIds      = $sm.supportsApplyEditsWithGlobalIds
                    Units                                = $sm.units
                    SupportsQueryDomains                 = $sm.supportsQueryDomains
                    LayerNames                           = $sm.layers.name -join ', ' # {@{id=x; name=y; parentLayerId=z...}}
                    TableNames                           = $sm.tables.name -join ', ' # {@{id=x; name=y}}
                    RelationshipNames                    = $sm.relationships.name -join ', ' # {@{id=x; name=y}}
                    EnableZDefaults                      = $sm.enableZDefaults
                    ReferenceScale                       = $sm.referenceScale
                }

                <# $props = @(
                    @{ N = 'ServiceName'; E = { $service.name } }
                    @{ N = ''; E = { $_ } }
                    @{ N = 'ServiceType'; E = { $service.type } }
                    @{ N = 'HasVersionedData'; E = { $_.hasVersionedData } }
                    @{ N = 'SupportsDisconnectedEditing'; E = { $_.supportsDisconnectedEditing } }
                    @{ N = 'SupportsQueryDataElements'; E = { $_.supportsQueryDataElements } }
                    @{ N = 'SupportsRelationshipsResource'; E = { $_.supportsRelationshipsResource } }
                    @{ N = 'SyncEnabled'; E = { $_.syncEnabled } }
                    @{ N = 'SupportedExportFormats'; E = { $_.supportedExportFormats } }
                    @{ N = 'SupportedQueryFormats'; E = { $_.supportedQueryFormats } }
                    @{ N = 'MaxRecordCount'; E = { $_.maxRecordCount } }
                    @{ N = 'Capabilities'; E = { $_.capabilities } }
                    @{ N = 'Description'; E = { $_.description } }
                    @{ N = 'SupportsSplit'; E = { $_.advancedEditingCapabilities.supportsSplit } }
                    @{ N = 'SupportsReturnServiceEditsInSourceSR'; E = { $_.advancedEditingCapabilities.supportsReturnServiceEditsInSourceSR } }
                    @{ N = 'SupportsAsyncApplyEdits'; E = { $_.advancedEditingCapabilities.supportsAsyncApplyEdits } }
                    @{ N = 'WKID'; E = { $_.spatialReference.wkid } }
                    @{ N = 'XYTolerance'; E = { $_.spatialReference.xyTolerance } }
                    @{ N = 'ZTolerance'; E = { $_.spatialReference.zTolerance } }
                    @{ N = 'MTolderance'; E = { $_.spatialReference.mTolerance } }
                    @{ N = 'XMin'; E = { $_.initialExtent.xmin } }
                    @{ N = 'YMin'; E = { $_.initialExtent.ymin } }
                    @{ N = 'XMax'; E = { $_.initialExtent.xmax } }
                    @{ N = 'YMax'; E = { $_.initialExtent.ymax } }
                    @{ N = 'AllowGeometryUpdates'; E = { $_.allowGeometryUpdates } }
                    @{ N = 'SupportsApplyEditsWithGlobalIds'; E = { $_.supportsApplyEditsWithGlobalIds } }
                    @{ N = 'Units'; E = { $_.units } }
                    @{ N = 'SupportsQueryDomains'; E = { $_.supportsQueryDomains } }
                    @{ N = 'LayerNames'; E = { $_.layers.name -join ', ' } } # {@{id=x; name=y; parentLayerId=z...}}
                    @{ N = 'TableNames'; E = { $_.tables.name -join ', ' } } # {@{id=x; name=y}}
                    @{ N = 'RelationshipNames'; E = { $_.relationships.name -join ', ' } } # {@{id=x; name=y}}
                    @{ N = 'EnableZDefaults'; E = { $_.enableZDefaults } }
                    @{ N = 'ReferenceScale'; E = { $_.referenceScale } }
                ) #>
            }
        }
        else {
            # INVOKE REQUEST
            Invoke-RestMethod @restParams
        }
    }
}
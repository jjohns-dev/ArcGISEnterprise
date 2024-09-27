function Format-ServerServiceMetadata {
    <#
    .SYNOPSIS
        Format ArcGIS Server service metadata
    .DESCRIPTION
        Format ArcGIS Server service metadata for reporting
    .PARAMETER ServiceMetadata
        ArcGIS Server service metatadata object
    .PARAMETER FieldData
        Output service field data
    .PARAMETER ReportData
        Format and output report data
    .INPUTS
        System.Object.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Format-ServerServiceMetadata -ServiceMetadata $sm -ReportData
        Formats and outputs the service metadata object for reporting
    .NOTES
        Name:     Format-ServerServiceMetadata
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-09-27
        - Version history is capture in repository commit history
        Comments:
        The reason for this function is to provide a consistent output format for service metadata.
        When using ArcGIS Enterprise data in reporting, it is more efficient to make a single call
        to the server and then format the data as needed. Making multiple calls to the server is
        time consuming and inefficient.
        Attempting to use type extensions to add custom properties to the service metadata object
        yielded errors and inconsistent results.
    #>
    [CmdletBinding(DefaultParameterSetName = '__rd')]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'ArcGIS Server service metatadata object')]
        [ValidateNotNullOrEmpty()]
        [System.Object[]] $ServiceMetadata,

        [Parameter(Mandatory = $true, ParameterSetName = '__fd', HelpMessage = 'Output service field data')]
        [System.Management.Automation.SwitchParameter] $FieldData,

        [Parameter(Mandatory = $true, ParameterSetName = '__rd', HelpMessage = 'Format and output report data')]
        [System.Management.Automation.SwitchParameter] $ReportData
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET REPORT PROPERTIES
        $reportProps = @(
            'ServiceName'
            'ServiceType'
            @{ N = 'HasVersionedData'; E = { $_.hasVersionedData } }
            @{ N = 'SupportsDynamicLayers'; E = { if ($_.supportsDynamicLayers) { $_.supportsDynamicLayers } else { $false } } }
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
            #@{ N = 'Layers'; E = { $_.layers } }
            @{ N = 'TableNames'; E = { $_.tables.name -join ', ' } } # {@{id=x; name=y}}
            @{ N = 'RelationshipNames'; E = { $_.relationships.name -join ', ' } } # {@{id=x; name=y}}
            @{ N = 'EnableZDefaults'; E = { $_.enableZDefaults } }
            @{ N = 'ReferenceScale'; E = { $_.referenceScale } }
        )

        # SET FIELD PROPERTIES
        $fieldProps = @(
            @{ N = 'ServiceName'; E = { $sm.ServiceName } }
            @{ N = 'ServiceNameLength'; E = { $sm.ServiceName.Length } }
            @{ N = 'ServiceType'; E = { $sm.ServiceType } }
            @{ N = 'SupportsDynamicLayers'; E = { if ($sm.supportsDynamicLayers) { $sm.supportsDynamicLayers } else { $false } } }
            @{ N = 'LayerId'; E = { $null } }
            @{ N = 'LayerName'; E = { $null } }
            @{ N = 'LayerType'; E = { $null } }
            @{ N = 'LayerHasSpecialChars'; E = { $null } }
            @{ N = 'LayerNameLength'; E = { $null } }
            @{ N = 'GeometryType'; E = { $null } }
            @{ N = 'UniqueSymbology'; E = { $null } }
            @{ N = 'FieldName'; E = { $_.name } }
            @{ N = 'FieldHasSpecialChars'; E = { if ($_.name -match '\W') { $true } else { $false } } }
            @{ N = 'FieldNameLength'; E = { $_.name.length } }
            @{ N = 'FieldType'; E = { $_.type } }
            @{ N = 'FieldLength'; E = { if ($_.type -EQ 'esriFieldTypeString') { $_.length } else { $null } } }
        )
    }
    Process {
        # EVALUATE EACH SERVICE METADATA OBJECT
        foreach ($sm in $ServiceMetadata) {

            # DETERMINE PARAMETER SET
            if ($PSBoundParameters.ContainsKey('FieldData')) {

                # EVALUATE EACH FIELD
                foreach ($field in $sm.fields) {

                    <# # CREATE NEW FIELD OBJECT
                    [PSCustomObject] @{
                        ServiceName           = $serviceMetadata.ServiceName
                        ServiceNameLength     = $serviceMetadata.ServiceName.Length
                        ServiceType           = $serviceMetadata.ServiceType
                        SupportsDynamicLayers = if ($serviceMetadata.supportsDynamicLayers) { $serviceMetadata.supportsDynamicLayers } else { $false }
                        LayerId               = $null
                        LayerName             = $null
                        LayerType             = $null
                        LayerHasSpecialChars  = $null
                        LayerNameLength       = $null
                        GeometryType          = $null
                        UniqueSymbology       = $null
                        FieldName             = $field.name
                        FieldHasSpecialChars  = if ($field.name -match '\W') { $true } else { $false }
                        FieldNameLength       = $field.name.length
                        FieldType             = $field.type
                        FieldLength           = if ($field.type -EQ 'esriFieldTypeString') { $field.length } else { $null }
                    } #>

                    # OUTPUT FIELD DATA
                    $field | Select-Object -Property $fieldProps
                }
            }
            elseif ($PSCmdlet.ParameterSetName -EQ '__rd') {
                <# # OUTPUT REPORT DATA
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
                    Layers                               = $sm.layers
                    TableNames                           = $sm.tables.name -join ', ' # {@{id=x; name=y}}
                    RelationshipNames                    = $sm.relationships.name -join ', ' # {@{id=x; name=y}}
                    EnableZDefaults                      = $sm.enableZDefaults
                    ReferenceScale                       = $sm.referenceScale
                } #>

                # OUTPUT REPORT DATA
                $sm | Select-Object -Property $reportProps
            }
        }
    }
}
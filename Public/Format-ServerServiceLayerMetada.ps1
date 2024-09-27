function Format-ServerServiceLayerMetadata {
    <#
    .SYNOPSIS
        Format ArcGIS Server service layer metadata
    .DESCRIPTION
        Format ArcGIS Server service layer metadata for reporting or field data
    .PARAMETER LayerMetadata
        ArcGIS Server service layer metatadata object
    .PARAMETER FieldData
        Output service field data
    .PARAMETER ReportData
        Format and output report data
    .INPUTS
        System.Object.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Format-ServerServiceLayerMetadata -LayerMetadata $layerMetadata -FieldData
        Returns field data for the service layer metadata for reporting
    .NOTES
        Name:     Format-ServerServiceLayerMetadata
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
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'ArcGIS Server service layer metatadata object')]
        [ValidateNotNullOrEmpty()]
        [System.Object[]] $LayerMetadata,

        [Parameter(Mandatory = $false, ParameterSetName = '__fd', HelpMessage = 'Output service field data')]
        [System.Management.Automation.SwitchParameter] $FieldData,

        [Parameter(Mandatory = $false, ParameterSetName = '__rd', HelpMessage = 'Format and output report data')]
        [System.Management.Automation.SwitchParameter] $ReportData
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET REPORT PROPERTIES
        $reportProps = @(
            'LayerName'
            @{ N = 'Id'; E = { $_.id } }
            'ServiceType'
            @{ N = 'LayerType'; E = { $_.type } }
            @{ N = 'ParentLayer'; E = { $_.parentLayer } }
            @{ N = 'DefaultVisibility'; E = { $_.defaultVisibility } }
            @{ N = 'MinScale'; E = { $_.minScale } }
            @{ N = 'MaxScale'; E = { $_.maxScale } }
            @{ N = 'CanScaleSymbols'; E = { $_.canScaleSymbols } }
            @{ N = 'GeometryType'; E = { $_.geometryType } }
            @{ N = 'Description'; E = { $_.description } }
            @{ N = 'RelationshipNames'; E = { $_.relationships.name -join ', ' } }
            @{ N = 'SupportsAdvancedQueries'; E = { $_.supportsAdvancedQueries } }
            @{ N = 'SupportsPagination'; E = { $_.advancedQueryCapabilities.supportsPagination } }
            @{ N = 'SupportsQueryAttachments'; E = { $_.advancedQueryCapabilities.supportsQueryAttachments } }
            @{ N = 'HasMetadata'; E = { $_.hasMetadata } }
            @{ N = 'XMin'; E = { $_.extent.xmin } }
            @{ N = 'YMin'; E = { $_.extent.ymin } }
            @{ N = 'XMax'; E = { $_.extent.xmax } }
            @{ N = 'YMax'; E = { $_.extent.ymax } }
            @{ N = 'WKId'; E = { $_.extent.spatialReference.wkid } }
            @{ N = 'RendererType'; E = { $_.drawingInfo.renderer.type } }
            @{ N = 'RendererField1'; E = { $_.drawingInfo.renderer.field1 } }
            @{ N = 'RendererScaleSymbols'; E = { $_.drawingInfo.scaleSymbols } }
            @{ N = 'RendererTransparency'; E = { $_.drawingInfo.transparency } }
            @{ N = 'RendererLabelingInfo'; E = { $_.drawingInfo.labelingInfo } }
            @{ N = 'HasM'; E = { $_.hasM } }
            @{ N = 'HasZ'; E = { $_.hasZ } }
            @{ N = 'AllowGeometryUpdates'; E = { $_.allowGeometryUpdates } }
            @{ N = 'HasAttachments'; E = { $_.hasAttachments } }
            @{ N = 'SupportsApplyEditsWithGlobalIds'; E = { $_.supportsApplyEditsWithGlobalIds } }
            @{ N = 'ObjectIdField'; E = { $_.objectIdField } }
            @{ N = 'GlobalIdField'; E = { $_.globalIdField } }
            @{ N = 'DisplayField'; E = { $_.displayField } }
            @{ N = 'TypeIdField'; E = { $_.typeIdField } }
            @{ N = 'SubtypeField'; E = { $_.subtypeField } }
            @{ N = 'IndexNames'; E = { $_.indexes.name -join ', ' } }
            @{ N = 'DatesInUnknownTimezone'; E = { $_.datesInUnknownTimeZone } }
            @{ N = 'TimeZone'; E = { $_.DateFieldsTimeReference.timeZone } }
            @{ N = 'RespectsDaylightSaving'; E = { $_.DateFieldsTimeReference.respectsDaylightSaving } }
            @{ N = 'StandardMaxRecordCount'; E = { $_.standardMaxRecordCount } }
            @{ N = 'TileMaxRecordCount'; E = { $_.tileMaxRecordCount } }
            @{ N = 'StandardMaxRecordCountNoGeometry'; E = { $_.standardMaxRecordCountNoGeometry } }
            @{ N = 'MaxRecordCountFactor'; E = { $_.maxRecordCountFactor } }
        )

        # SET FIELD PROPERTIES
        $fieldProps = @(
            @{ N = 'ServiceName'; E = { $lm.LayerName } }
            @{ N = 'ServiceNameLength'; E = { $lm.LayerName.Length } }
            @{ N = 'ServiceType'; E = { $lm.ServiceType } }
            @{ N = 'SupportsDynamicLayers'; E = { $null } } # THIS NEEDS TO BE PULLED FROM THE SERVICE METADATA
            @{ N = 'LayerId'; E = { $lm.id } }
            @{ N = 'LayerName'; E = { $lm.name } }
            @{ N = 'LayerType'; E = { $lm.type } }
            @{ N = 'LayerHasSpecialChars'; E = { if ($lm.name -match '\W') { $true } else { $false } } }
            @{ N = 'LayerNameLength'; E = { $lm.name.length } }
            @{ N = 'GeometryType'; E = { $lm.geometryType } }
            @{ N = 'UniqueSymbology'; E = { $lm.drawingInfo.renderer.uniqueValueInfos.Count } }
            @{ N = 'FieldName'; E = { $_.name } }
            @{ N = 'FieldHasSpecialChars'; E = { if ($_.name -match '\W') { $true } else { $false } } }
            @{ N = 'FieldNameLength'; E = { $_.name.length } }
            @{ N = 'FieldType'; E = { $_.type } }
            @{ N = 'FieldLength'; E = { if ($_.type -EQ 'esriFieldTypeString') { $_.length } else { $null } } }
        )
    }
    Process {
        # EVALUATE EACH SERVICE METADATA OBJECT
        foreach ($lm in $LayerMetadata) {

            # DETERMINE PARAMETER SET
            if ($PSBoundParameters.ContainsKey('FieldData')) {

                # EVALUATE EACH FIELD
                foreach ($field in $lm.fields) {

                    <# # CREATE NEW FIELD OBJECT
                    [PSCustomObject] @{
                        #Folder                = $fldr
                        ServiceName           = $service.name
                        ServiceNameLength     = $service.name.Length
                        ServiceType           = $service.type
                        SupportsDynamicLayers = if ($serviceData.supportsDynamicLayers) { $serviceData.supportsDynamicLayers } else { $false }
                        LayerId               = $layer.id
                        LayerName             = $layer.name
                        LayerType             = $layerData.type
                        LayerHasSpecialChars  = if ($layer.name -match '\W') { $true } else { $false }
                        LayerNameLength       = $layer.name.Length
                        GeometryType          = $layerData.geometryType
                        UniqueSymbology       = $layerData.drawingInfo.renderer.uniqueValueInfos.Count
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
                    LayerName                        = if ($PSBoundParameters.ContainsKey('FolderName')) {
                        '{0}/{1}/{2}' -f $FolderName, $ServiceName, $layerMetadata.name
                    }
                    else {
                        '{0}/{1}' -f $ServiceName, $layerMetadata.name
                    }
                    Id                               = $layerMetadata.id
                    ServiceType                      = $ServiceType
                    LayerType                        = $layerMetadata.type
                    ParentLayer                      = $layerMetadata.parentLayer
                    DefaultVisibility                = $layerMetadata.defaultVisibility
                    MinScale                         = $layerMetadata.minScale
                    MaxScale                         = $layerMetadata.maxScale
                    CanScaleSymbols                  = $layerMetadata.canScaleSymbols
                    GeometryType                     = $layerMetadata.geometryType
                    Description                      = $layerMetadata.description
                    #EditFieldsInfo                   = $layerMetadata.editFieldsInfo # {@{editDateField=x; editorField=y; creationDateField=z; creatorField=a...}}
                    RelationshipNames                = $layerMetadata.relationships.name -join ', ' # {@{id=x; name=y, relatedTableId=z...}}
                    SupportsAdvancedQueries          = $layerMetadata.supportsAdvancedQueries
                    SupportsPagination               = $layerMetadata.advancedQueryCapabilities.supportsPagination
                    SupportsQueryAttachments         = $layerMetadata.advancedQueryCapabilities.supportsQueryAttachments
                    HasMetadata                      = $layerMetadata.hasMetadata
                    XMin                             = $layerMetadata.extent.xmin
                    YMin                             = $layerMetadata.extent.ymin
                    XMax                             = $layerMetadata.extent.xmax
                    YMax                             = $layerMetadata.extent.ymax
                    WKId                             = $layerMetadata.extent.spatialReference.wkid
                    RendererType                     = $layerMetadata.drawingInfo.renderer.type
                    RendererField1                   = $layerMetadata.drawingInfo.renderer.field1
                    RendererScaleSymbols             = $layerMetadata.drawingInfo.scaleSymbols
                    RendererTransparency             = $layerMetadata.drawingInfo.transparency
                    RendererLabelingInfo             = $layerMetadata.drawingInfo.labelingInfo
                    HasM                             = $layerMetadata.hasM
                    HasZ                             = $layerMetadata.hasZ
                    AllowGeometryUpdates             = $layerMetadata.allowGeometryUpdates
                    HasAttachments                   = $layerMetadata.hasAttachments # PROPERTY OF INTEREST
                    SupportsApplyEditsWithGlobalIds  = $layerMetadata.supportsApplyEditsWithGlobalIds
                    ObjectIdField                    = $layerMetadata.objectIdField
                    GlobalIdField                    = $layerMetadata.globalIdField
                    DisplayField                     = $layerMetadata.displayField
                    TypeIdField                      = $layerMetadata.typeIdField
                    SubtypeField                     = $layerMetadata.subtypeField
                    IndexNames                       = $layerMetadata.indexes.name -join ', ' # {@{fields=x; isAscending=y...}}
                    DatesInUnknownTimezone           = $layerMetadata.datesInUnknownTimeZone
                    TimeZone                         = $layerMetadata.DateFieldsTimeReference.timeZone
                    RespectsDaylightSaving           = $layerMetadata.DateFieldsTimeReference.respectsDaylightSaving
                    StandardMaxRecordCount           = $layerMetadata.standardMaxRecordCount
                    TileMaxRecordCount               = $layerMetadata.tileMaxRecordCount
                    StandardMaxRecordCountNoGeometry = $layerMetadata.standardMaxRecordCountNoGeometry
                    MaxRecordCountFactor             = $layerMetadata.maxRecordCountFactor
                } #>

                # OUTPUT REPORT DATA
                $lm | Select-Object -Property $reportProps
            }
        }
    }
}
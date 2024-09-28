function Get-ServerServiceReport {
    <#
    .SYNOPSIS
        Get ArcGIS Server service and layer information
    .DESCRIPTION
        Get ArcGIS Server service and layer information and output in report format
    .PARAMETER FolderName
        Target folder
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
        PS C:\> Get-ServerServiceReport -Context https://myServer.arcgis.com/arcgis -Folder Gas
        Returns an array of fields metadata for service and layer properties
    .NOTES
        Name:     Get-ServerServiceReport
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-09-28
        - Version history is capture in repository commit history
        Comments: <Comment(s)>
        - This function does not consider items in the root, meaning itesm that are not in one of the folders in ArcGIS Server.
        - The function only supports the following service types: MapServer, ImageServer, FeatureServer
    #>
    [CmdletBinding()]
    [Alias('Get-ServerServiceFieldInfo')]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Target folder')]
        [ValidateNotNullOrEmpty()]
        [Alias('Folder')]
        [System.String] $FolderName,

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

        # SET COMMON PARAMETERS
        $cmnParams = $PSBoundParameters

        # VALIDATE FOLDER PARAMETER
        if ($PSBoundParameters.ContainsKey('FolderName')) {
            # REMOVE FOLDER PARAMETER
            $cmnParams.Remove('FolderName') | Out-Null

            # GET SERVICE INFO INCLUDING FOLDERS
            $serviceInfo = Get-ServerServiceList @cmnParams

            # VALIDATE THE FOLDER EXISTS
            if ($FolderName -notin $serviceInfo.folders) {
                # TERMINATE WITH ERROR
                Write-Error -Message ('Folder [{0}] not found.' -f $FolderName) -Exception ([System.IO.FileNotFoundException]::new()) -ErrorAction Stop
            }
            else {
                # ADD FOLDER BACK TO PARAMETERS
                $cmnParams['FolderName'] = $FolderName
            }
        }

        # SET REPORT SERVICE PROPERTIES
        $reportPropsService = @(
            @{ N = 'ServiceName'; E = { $service.name } } # COMES FROM SERVICE LOOP
            @{ N = 'ServiceType'; E = { $service.type } } # COMES FROM SERVICE LOOP
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

        # SET REPORT LAYER PROPERTIES
        $reportPropsLayer = @(
            @{ N = 'LayerName'; E = { '{0}/{1}' -f $service.name, $layer.name } } # COMES FROM BOTH SERVICE AND LAYER LOOPS
            @{ N = 'Id'; E = { $_.id } }
            @{ N = 'ServiceType'; E = { $service.type } } # COMES FROM SERVICE LOOP
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

        # SET REPORT ATTACHMENT PROPERTIES
        $reportPropsAttachment = @(
            @{ N = 'LayerName'; E = { '{0}/{1}' -f $service.name, $layer.name } } # 'ServiceName'? COMES FROM SERVICE AND LAYER LOOPS
            @{ N = 'LayerId'; E = { $layer.id } } # COMES FROM LAYER LOOP
            @{ N = 'AttachmentId'; E = { $_.attachmentid } }
            @{ N = 'Name'; E = { $_.name } }
            @{ N = 'ContentType'; E = { $_.contentType } }
            @{ N = 'Size'; E = { $_.size } }
            @{ N = 'Size(MB)'; E = { $_.size / 1MB } }
        )

        # CREATE SERVICE AND LAYER ARRAYS
        $serviceArray = @()
        $layerArray = @()
        $attachArray = @()
    }
    Process {
        # GET SERVICES IN FOLDER
        $serviceList = Get-ServerServiceList @cmnParams

        # OUTPUT VERBOSE SERVICES IN FOLDER
        Write-Verbose -Message ("Services:`n{0}" -f ($serviceList.services | Out-String))

        # LOOP ALL SERVICES IN FOLDER
        foreach ($service in $serviceList.services) {

            # OUTPUT VERBOSE
            Write-Verbose -Message ('Evaluating service [{0}]' -f $service.name)

            # SET SERVICE INFO
            $serviceParams = @{
                ServiceName = $service.name.split('/')[-1]
                ServiceType = $service.type
            }

            # GET LAYERS IN SERVICE
            $serviceData = Get-ServerService @cmnParams @serviceParams

            # CHECK FOR ERRORS -- should we build an error handler function (check for code and throw proper error)?
            if ($serviceData.error) {
                if ($serviceData.error.code -eq 404) {
                    Write-Error -Message $serviceData.error.message -Exception ([System.IO.FileNotFoundException]::new()) -ErrorAction Stop
                }
                else {
                    Write-Error -Message ($serviceData.error | ConvertTo-Json) -ErrorAction Stop
                }
            }

            <# # CREATE CUSTOM OBJECT FOR SERVER SERVICE
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

            # ADD SERVICE DATA TO ARRAY
            $serviceArray += $serviceData | Select-Object -Property $reportPropsService

            # LOOK FOR LAYERS
            if ($null -NE $serviceData.layers) {

                # EVALUATE EACH LAYER
                foreach ($layer in $serviceData.layers) {

                    # GET LAYER DATA
                    $layerData = Get-ServerServiceLayer @cmnParams @serviceParams -LayerId $layer.id

                    <# # CREATE CUSTOM OJECT FOR LAYER DATA
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

                    # ADD LAYER DATA TO ARRAY
                    $layerArray += $layerData | Select-Object -Property $reportPropsLayer

                    # GET ATTACHMENTS
                    if ($service.type -EQ 'FeatureServer' -and $layerData.HasAttachments -EQ $true) {

                        # SET SERVICE LAYER ATTACHMENT PARAMS
                        $layerParams = @{
                            ServiceName = $serviceParams.ServiceName
                            LayerId     = $layer.id
                        }

                        # GET LAYER DATA
                        $data = Find-ServerServiceLayerData @cmnParams @layerParams

                        # EVALUATE FEATURES
                        if ($data.features.attributes) {

                            # SET SERVICE LAYER ATTACHMENT PARAMS
                            $layerParams['ObjectId'] = $data.features.attributes.objectid

                            # GET ATTACHMENTS
                            $attachments = Get-ServerServiceLayerAttachment @cmnParams @layerParams -ReportData

                            <# # CREATE CUSTOM OBJECT FOR ATTACHMENTS
                            [PSCustomObject] @{
                                ServiceName  = if ($PSBoundParameters.ContainsKey('FolderName')) {
                                    '{0}/{1}' -f $FolderName, $ServiceName
                                }
                                else {
                                    '{0}' -f $ServiceName
                                }
                                LayerId      = $LayerId
                                #ObjectId     = if ($PSBoundParameters.ContainsKey('ObjectId')) { $ObjectId -join ', ' } else { $null }
                                #GlobalId     = if ($PSBoundParameters.ContainsKey('GlobalId')) { $GlobalId -join ', ' } else { $null }
                                AttachmentId = $att.attachmentid
                                Name         = $att.name
                                ContentType  = $att.contentType
                                Size         = $att.size
                                'Size(MB)'   = $att.size / 1MB
                            } #>

                            $attachArray += $attachments | Select-Object -Property $reportPropsAttachment
                        }
                    }
                }
            }
        }
    }
    End {
        # RETURN SERVIEC AND LAYER ARRAYS
        [PSCustomObject] @{
            Context     = $Context
            Folder      = $FolderName
            Services    = $serviceArray
            Layers      = $layerArray
            Attachments = $attachArray
        }
    }
}
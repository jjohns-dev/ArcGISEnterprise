function Get-ServerServiceReport {
    <#
    .SYNOPSIS
        Get ArcGIS Server service and layer information
    .DESCRIPTION
        Get ArcGIS Server service and layer information and output in report format
    .PARAMETER FolderName
        Target folder
    .PARAMETER IncludeFieldData
        Include service and layer field metadata
    .PARAMETER OnlyFieldData
        Return only service and layer field metadata
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
        PS C:\> Get-ServerServiceReport -Context https://arcgis.com/arcgis -Folder Gas
        Returns an object with arrays for service, layer, and attachment properties for content in the "Gas" folder
    .EXAMPLE
        PS C:\> Get-ServerServiceReport -Context https://arcgis.com/arcgis -IncludeFieldData
        Returns an object with arrays for service, layer, attachment, and field properties
    .EXAMPLE
        PS C:\> Get-ServerServiceReport -Context https://arcgis.com/arcgis -OnlyFieldData
        Returns an object with array for only field properties
    .NOTES
        Name:     Get-ServerServiceReport
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-09-30
        - Version history is capture in repository commit history
        Comments: <Comment(s)>
        - This function does not consider items in the root, meaning itesm that are not in one of the folders in ArcGIS Server.
        - The function only supports the following service types: MapServer, ImageServer, FeatureServer
    #>
    [CmdletBinding(DefaultParameterSetName = '__svc')]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Target folder', ParameterSetName = '__svc')]
        [Parameter(Mandatory = $false, HelpMessage = 'Target folder', ParameterSetName = '__ifd')]
        [Parameter(Mandatory = $false, HelpMessage = 'Target folder', ParameterSetName = '__fdo')]
        [ValidateNotNullOrEmpty()]
        [System.String] $FolderName,

        [Parameter(Mandatory = $false, HelpMessage = 'Include service and layer field metadata', ParameterSetName = '__ifd')]
        [System.Management.Automation.SwitchParameter] $IncludeFieldData,

        [Parameter(Mandatory = $false, HelpMessage = 'Return only service and layer field metadata', ParameterSetName = '__fdo')]
        [System.Management.Automation.SwitchParameter] $OnlyFieldData,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Server context', ParameterSetName = '__svc')]
        [Parameter(Mandatory = $true, HelpMessage = 'Target Server context', ParameterSetName = '__ifd')]
        [Parameter(Mandatory = $true, HelpMessage = 'Target Server context', ParameterSetName = '__fdo')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal token', ParameterSetName = '__svc')]
        [Parameter(Mandatory = $false, HelpMessage = 'Portal token', ParameterSetName = '__ifd')]
        [Parameter(Mandatory = $false, HelpMessage = 'Portal token', ParameterSetName = '__fdo')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(Mandatory = $false, HelpMessage = 'Skip SSL certificate check', ParameterSetName = '__svc')]
        [Parameter(Mandatory = $false, HelpMessage = 'Skip SSL certificate check', ParameterSetName = '__ifd')]
        [Parameter(Mandatory = $false, HelpMessage = 'Skip SSL certificate check', ParameterSetName = '__fdo')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Parameter set: [{0}]' -f $PSCmdlet.ParameterSetName)
        Write-Verbose -Message ("Parameters:`n[{0}]" -f ($PSBoundParameters | Out-String))

        # SET COMMON PARAMETERS
        $cmnParams = $PSBoundParameters

        # SET PARAMETER SET SPECIFIC VALUES
        switch ($PSCmdlet.ParameterSetName) {
            '__svc' {
                # CREATE REPORT HASHTABLE
                $report = @{
                    Context     = $Context
                    FolderName  = $FolderName
                    Services    = @()
                    Layers      = @()
                    Attachments = @()
                }
            }
            '__ifd' {
                # REMOVE PARAMTER FROM COMMON PARAMETERS
                $cmnParams.Remove('IncludeFieldData') | Out-Null

                # CREATE REPORT HASHTABLE
                $report = @{
                    Context     = $Context
                    FolderName  = $FolderName
                    Services    = @()
                    Layers      = @()
                    Attachments = @()
                    Fields      = @()
                }
            }
            '__fdo' {
                # REMOVE PARAMTER FROM COMMON PARAMETERS
                $cmnParams.Remove('OnlyFieldData') | Out-Null

                # CREATE REPORT HASHTABLE
                $report = @{
                    Context     = $Context
                    FolderName  = $FolderName
                    Fields      = @()
                }
            }
        }

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
        else {
            # SET FOLDER NAME TO ROOT
            $report['FolderName'] = '(root)'
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
            #@{ N = 'ParentLayer'; E = { $_.parentLayer } }
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

        # SET SERVICE FIELD PROPERTIES
        $reportPropsServiceFields = @(
            @{ N = 'ServiceName'; E = { $service.name } }
            @{ N = 'ServiceNameLength'; E = { $service.name.Length } }
            @{ N = 'ServiceType'; E = { $service.type } }
            @{ N = 'SupportsDynamicLayers'; E = { if ($serviceData.supportsDynamicLayers) { $serviceData.supportsDynamicLayers } else { $false } } }
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

        # SET LAYER FIELD PROPERTIES
        $reportPropsLayerFields = @(
            @{ N = 'ServiceName'; E = { $service.name } }
            @{ N = 'ServiceNameLength'; E = { $service.name.Length } }
            @{ N = 'ServiceType'; E = { $service.type } }
            @{ N = 'SupportsDynamicLayers'; E = { if ($serviceData.supportsDynamicLayers) { $serviceData.supportsDynamicLayers } else { $false } } }
            @{ N = 'LayerId'; E = { $layer.id } }
            @{ N = 'LayerName'; E = { $layer.name } }
            @{ N = 'LayerType'; E = { $layerData.type } }
            @{ N = 'LayerHasSpecialChars'; E = { if ($layer.name -match '\W') { $true } else { $false } } }
            @{ N = 'LayerNameLength'; E = { $layer.name.Length } }
            @{ N = 'GeometryType'; E = { $layerData.geometryType } }
            @{ N = 'UniqueSymbology'; E = { $layerData.drawingInfo.renderer.uniqueValueInfos.Count } }
            @{ N = 'FieldName'; E = { $_.name } }
            @{ N = 'FieldHasSpecialChars'; E = { if ($_.name -match '\W') { $true } else { $false } } }
            @{ N = 'FieldNameLength'; E = { $_.name.length } }
            @{ N = 'FieldType'; E = { $_.type } }
            @{ N = 'FieldLength'; E = { if ($_.type -EQ 'esriFieldTypeString') { $_.length } else { $null } } }
        )
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

            # CHECK FOR FIELDS ONLY PARAMETER
            if ($PSCmdlet.ParameterSetName -NE '__fdo') {
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
                $report['Services'] += $serviceData | Select-Object -Property $reportPropsService
            }

            # CHECK FOR FIELD PARAMETERS
            if ($PSCmdlet.ParameterSetName -IN @('__ifd', '__fdo')) {

                # VALIDATE SERVICE FIELD PROPERTY
                if ($null -NE $serviceData.fields) {

                    # EVALUATE EACH FIELD
                    foreach ($field in $serviceData.fields) {

                        <# # CREATE NEW FIELD OBJECT
                        [PSCustomObject] @{
                            #Folder                = $fldr
                            ServiceName           = $service.name
                            ServiceNameLength     = $service.name.Length
                            ServiceType           = $service.type
                            SupportsDynamicLayers = if ($serviceData.supportsDynamicLayers) { $serviceData.supportsDynamicLayers } else { $false }
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

                        # ADD FIELD PROPERTIES TO REPORT
                        $report['Fields'] += $field | Select-Object -Property $reportPropsServiceFields
                    }
                }
            }

            # LOOK FOR LAYERS
            if ($null -NE $serviceData.layers) {

                # EVALUATE EACH LAYER
                foreach ($layer in $serviceData.layers) {

                    # GET LAYER DATA
                    $layerData = Get-ServerServiceLayer @cmnParams @serviceParams -LayerId $layer.id

                    # CHECK FOR FIELD PARAMETERS
                    if ($PSCmdlet.ParameterSetName -IN @('__ifd', '__fdo')) {

                        # LOOP ALL FIELDS
                        foreach ($field in $layerData.fields) {

                            <# # CREATE CUSTOM OBJECT
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

                            # ADD FIELD PROPERTIES TO REPORT
                            $report['Fields'] += $field | Select-Object -Property $reportPropsLayerFields
                        }
                    }

                    # CHECK FOR FIELDS ONLY PARAMETER
                    if ($PSCmdlet.ParameterSetName -NE '__fdo') {
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
                        $report['Layers'] += $layerData | Select-Object -Property $reportPropsLayer

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

                                # SET LAYER NAME VAR
                                $verLayer = '{0}/{1}' -f $service.name, $layer.name

                                # CHECK FOR ID TYPE
                                if ($data.features.attributes[0].GlobalID) {
                                    # SET SERVICE LAYER ATTACHMENT GLOBAL IDS
                                    $layerParams['GlobalId'] = $data.features.attributes.GlobalID | ForEach-Object -Process { $_.TrimStart('{').TrimEnd('}') }

                                    # OUTPUT VERBOSE
                                    Write-Verbose -Message ('Evaluating attachments for layer [{0}] and globalid [{1}]' -f $verLayer, ($layerParams['GlobalId'] -join ', '))
                                }
                                elseif ($data.features.attributes[0].objectid) {
                                    # SET SERVICE LAYER ATTACHMENT OBJECT IDS
                                    $layerParams['ObjectId'] = $data.features.attributes.objectid

                                    # OUTPUT VERBOSE
                                    Write-Verbose -Message ('Evaluating attachments for layer [{0}] and objectid [{1}]' -f $verLayer, ($layerParams['ObjectId'] -join ', '))
                                }
                                else {
                                    # OUTPUT WARNING
                                    Write-Warning -Message ('No objectid or GlobalID found in layer [{0}].' -f $verLayer)
                                }

                                # GET ATTACHMENTS
                                $attachments = Get-ServerServiceLayerAttachment @cmnParams @layerParams

                                # EVALUATE EACH ATTACHMENT
                                foreach ($att in $attachments.attachmentGroups.attachmentInfos) {

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

                                    # WHEN THE LAYER DATA INCLUDES AND ATTACHMENT USING OBJECT ID, IT RETURNS A PSCUSTOMOBJECT
                                    # HOWEVER, WHEN THE LAYER DATA INCLUDES AN ATTACHMENT USING GLOBAL ID, IT RETURNS AN ORDERED HASHTABLE
                                    if ($att.getType().FullName -EQ 'System.Management.Automation.OrderedHashtable') {

                                        # OUTPUT VERBOSE
                                        Write-Verbose -Message ('Converting attribute from hashtable to custom object...')

                                        # CONVERT TO CUSTOM OBJECT
                                        $att = [PSCustomObject] $att
                                    }
                                    elseif ($att.getType().FullName -NE 'System.Management.Automation.PSCustomObject') {

                                        # OUTPUT WARNING
                                        Write-Warning -Message ('Attachment is not of a known type [{0}]' -f $att.getType().FullName)
                                    }

                                    # ADD ATTACHMENTS TO ARRAY
                                    $report['Attachments'] += $att | Select-Object -Property $reportPropsAttachment
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    End {
        # RETURN SERVIEC AND LAYER ARRAYS
        [PSCustomObject] $report
    }
}
function Get-ServerServiceLayer {
    <#
    .SYNOPSIS
        Get ArcGIS Server service layer metadata
    .DESCRIPTION
        Get ArcGIS Server service layer metadata
    .PARAMETER LayerId
        Service Layer ID
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
        PS C:\> Get-ServerServiceLayer @cmnParams -Folder 'Energy' -ServiceName 'Geology' -ServiceType 'FeatureServer' -LayerId 0
        Returns service layer metadata for the first layer of the 'Geology' FeatureServer in the 'Energy' folder
    .NOTES
        Name:     Get-ServerServiceLayer
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-09-26
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/services-reference/enterprise/get-started-with-the-services-directory/

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
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Service Layer ID')]
        [ValidateNotNullOrEmpty()]
        [Alias('Layer')]
        [System.Int32] $LayerId,

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
                '{0}/rest/services/{1}/{2}/{3}/{4}' -f $Context, $FolderName, $ServiceName, $ServiceType, $LayerId
            }
            else {
                '{0}/rest/services/{1}/{2}/{3}' -f $Context, $ServiceName, $ServiceType, $LayerId
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

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Request URI: {0}' -f $restParams['Uri'])

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        $layerMetadata = Invoke-RestMethod @restParams

        # VALIDATE RESPONSE - THE VALIDATION IS DUE TO THE DESIGN ISSUE DESCRIBED BELOW
        if ($layerMetadata.error) {
            Write-Error -Message $layerMetadata.error -ErrorAction Stop
        }
        else {
            # CHECK FOR SCENARIO WHERE LAYER IS ATTACHMENT
            # THIS IS DUE TO A POOR DESIGN CHOICE TO HAVE MULTIPLE PROPERTIES WITH THE SAME NAME BUT DIFFERENT CASING
            # THE PROPERTIES ARE 'supportsValidateSql' AND 'supportsValidateSQL'
            if ($layerMetadata.getType().FullName -EQ 'System.String') {
                # CREATE CUSTOM HASHTABLE
                $layerMetadata = $layerMetadata | ConvertFrom-Json -AsHashtable

                # REMOVE DUPLICATE PROPERTY WITH DIFFERENT NAME CASING
                $layerMetadata.Remove('supportsValidateSQL')

                # CONVERT TO CUSTOM OBJECT
                $layerMetadata = [PSCustomObject] $layerMetadata
            }
            else {
                # ADD NECESSARY PROPERTIES
                if ($PSBoundParameters.ContainsKey('FolderName')) {
                    $lName = '{0}/{1}/{2}' -f $FolderName, $ServiceName, $layerMetadata.name
                }
                else {
                    $lName = '{0}/{1}' -f $ServiceName, $layerMetadata.name
                }
                Add-Member -InputObject $layerMetadata -NotePropertyMembers @{ LayerName = $lName; ServiceType = $ServiceType }

                # OUTPUT LAYER METADATA
                $layerMetadata
            }
        }
    }
}
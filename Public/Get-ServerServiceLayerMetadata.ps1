function Get-ServerServiceLayerMetadata {
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
        PS C:\> Get-ServerServiceLayerMetadata @cmnParams -Folder 'Energy' -ServiceName 'Geology' -ServiceType 'FeatureServer' -LayerId 0
        Returns service layer metadata for the first layer of the 'Geology' FeatureServer in the 'Energy' folder
    .NOTES
        Name:     Get-ServerServiceLayerMetadata
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-09-26
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/services-reference/enterprise/get-started-with-the-services-directory/
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

        # VALIDATE RESPONSE
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

            # OUTPUT REPORT DATA IF REQUESTED
            if ($PSBoundParameters.ContainsKey('ReportData')) {
                # OUTPUT REPORT DATA
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
                }
            }
            else {
                # OUTPUT LAYER METADATA
                $layerMetadata
            }
        }
    }
}
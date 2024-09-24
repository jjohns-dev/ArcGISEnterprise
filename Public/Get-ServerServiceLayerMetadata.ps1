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
        Version:  0.1.0 | Last Edit: 2024-09-20
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

        # ADD REPORT DATA IF REQUESTED
        if ($PSBoundParameters.ContainsKey('ReportData')) {
            # INVOKE REQUEST
            $lm = Invoke-RestMethod @restParams

            # CHECK FOR ERRORS
            if ($lm.error) {
                Write-Error -Message $lm.error.message -ErrorAction Stop
            }
            else {
                # OUTPUT REPORT DATA
                [PSCustomObject] @{
                    LayerName                        = if ($PSBoundParameters.ContainsKey('FolderName')) {
                        '{0}/{1}/{2}' -f $FolderName, $ServiceName, $lm.name
                    }
                    else {
                        '{0}/{1}' -f $ServiceName, $lm.name
                    }
                    Id                               = $lm.id
                    ServiceType                      = $ServiceType
                    LayerType                        = $lm.type
                    ParentLayer                      = $lm.parentLayer
                    DefaultVisibility                = $lm.defaultVisibility
                    MinScale                         = $lm.minScale
                    MaxScale                         = $lm.maxScale
                    CanScaleSymbols                  = $lm.canScaleSymbols
                    GeometryType                     = $lm.geometryType
                    Description                      = $lm.description
                    EditFieldsInfo                   = $lm.editFieldsInfo
                    RelationshipNames                = $lm.relationships.name -join ', ' # {@{id=x; name=y, relatedTableId=z...}}
                    SupportsAdvancedQueries          = $lm.supportsAdvancedQueries
                    SupportsPagination               = $lm.advancedQueryCapabilities.supportsPagination
                    SupportsQueryAttachments         = $lm.advancedQueryCapabilities.supportsQueryAttachments
                    HasMetadata                      = $lm.hasMetadata
                    XMin                             = $lm.extent.xmin
                    YMin                             = $lm.extent.ymin
                    XMax                             = $lm.extent.xmax
                    YMax                             = $lm.extent.ymax
                    WKId                             = $lm.extent.spatialReference.wkid
                    RendererType                     = $lm.drawingInfo.renderer.type
                    RendererField1                   = $lm.drawingInfo.renderer.field1
                    RendererScaleSymbols             = $lm.drawingInfo.scaleSymbols
                    RendererTransparency             = $lm.drawingInfo.transparency
                    RendererLabelingInfo             = $lm.drawingInfo.labelingInfo
                    HasM                             = $lm.hasM
                    HasZ                             = $lm.hasZ
                    AllowGeometryUpdates             = $lm.allowGeometryUpdates
                    HasAttachments                   = $lm.hasAttachments
                    SupportsApplyEditsWithGlobalIds  = $lm.supportsApplyEditsWithGlobalIds
                    ObjectIdField                    = $lm.objectIdField
                    GlobalIdField                    = $lm.globalIdField
                    DisplayField                     = $lm.displayField
                    TypeIdField                      = $lm.typeIdField
                    SubtypeField                     = $lm.subtypeField
                    IndexNames                       = $lm.indexes.name -join ', ' # {@{fields=x; isAscending=y...}}
                    DatesInUnknownTimezone           = $lm.datesInUnknownTimeZone
                    TimeZone                         = $lm.DateFieldsTimeReference.timeZone
                    RespectsDaylightSaving           = $lm.DateFieldsTimeReference.respectsDaylightSaving
                    StandardMaxRecordCount           = $lm.standardMaxRecordCount
                    TileMaxRecordCount               = $lm.tileMaxRecordCount
                    StandardMaxRecordCountNoGeometry = $lm.standardMaxRecordCountNoGeometry
                    MaxRecordCountFactor             = $lm.maxRecordCountFactor
                }
            }
        }
        else {
            # INVOKE REQUEST
            Invoke-RestMethod @restParams
        }
    }
}
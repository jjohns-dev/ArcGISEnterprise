function Publish-PortalCsvItemAsTable {
    <#
    .SYNOPSIS
        Publish a CSV file in Portal as a Hosted table
    .DESCRIPTION
        Publish a CSV file in Portal as a Hosted table. This takes and existing CSV file
        published to Portal and publishes it as a Hosted table.
    .PARAMETER ItemName
        Name of new Portal table
    .PARAMETER ItemId
        Id of Portal item
    .PARAMETER Field
        Table fields (i.e., schema)
    .PARAMETER UserName
        Username
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
        PS C:\> Publish-PortalCsvItemAsTable -ItemName SalesData -ItemId $iid -Field $schema @commonParams
        Uses the existing Portal item with ID $iid to publish a new Hosted table with name SalesData using the fields in $fields
    .NOTES
        Name:     Publish-PortalCsvItemAsTable
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-15
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/publish-item.htm
        https://developers.arcgis.com/documentation/mapping-apis-and-services/data-hosting/tutorials/tools/import-data-to-create-a-table/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Name of new Portal table')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ItemName,

        [Parameter(Mandatory = $true, HelpMessage = 'Id of Portal item')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $ItemId,

        [Parameter(Mandatory = $true, HelpMessage = 'Table fields (i.e., schema)')]
        #[ValidateNotNullOrEmpty()]
        [ValidateScript({
            $reqProps = @('nullable', 'editable', 'type', 'name', 'alias')
            $valid = foreach ($rp in $reqProps) { $rp -in $_[0].psobject.Properties.Name }
            $false -notin $valid
        })]
        [System.Object[]] $Field,

        [Parameter(Mandatory = $false, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

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

        # VALIDATE USER NAME
        if (-Not $PSBoundParameters.ContainsKey('UserName')) {
            try {
                # GET USER PORTAL INFO
                Write-Verbose -Message 'Getting user settings...'
                $userSettings = Get-PortalSettings -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck

                # SET USER NAME
                $UserName = $userSettings.user.username
            }
            catch {
                # PASS ERROR
                throw ('Unable to get user info with error: {0}' -f $_.Exception.Message)
            }
        }

        # SET TEMPLATE FOR CSV TABLE
        $CsvTable = '{"type":"csv","name":"[REPLACEME]","useBulkInserts":true,"sourceUrl":"","locationType":"none","maxRecordCount":1000,"geocodeServiceUrl":"https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer","sourceCountry":"US","sourceLocale":"en","standardizedFieldNames":{"Address":"Address or Place","Address2":"Address2","Address3":"Address3","City":"City","Subregion":"County","Region":"State","Postal":"ZIP","PostalExt":"ZIP4","CountryCode":"Country"},"columnDelimiter":",","qualifier":"''","targetSR":{"wkid":102100,"latestWkid":3857},"editorTrackingInfo":{"enableEditorTracking":false,"enableOwnershipAccessControl":false,"allowOthersToQuery":true,"allowOthersToUpdate":true,"allowOthersToDelete":false,"allowAnonymousToQuery":true,"allowAnonymousToUpdate":true,"allowAnonymousToDelete":true},"layerInfo":{"currentVersion":11.1,"id":0,"name":"[REPLACEME]","type":"Table","displayField":"","description":"","copyrightText":"","defaultVisibility":true,"relationships":[],"isDataVersioned":false,"supportsAppend":true,"supportsCalculate":true,"supportsASyncCalculate":true,"supportsTruncate":false,"supportsAttachmentsByUploadId":true,"supportsAttachmentsResizing":true,"supportsRollbackOnFailureParameter":true,"supportsStatistics":true,"supportsExceedsLimitStatistics":true,"supportsAdvancedQueries":true,"supportsValidateSql":true,"supportsCoordinatesQuantization":true,"supportsLayerOverrides":true,"supportsTilesAndBasicQueriesMode":true,"supportsFieldDescriptionProperty":true,"supportsQuantizationEditMode":true,"supportsApplyEditsWithGlobalIds":false,"advancedQueryCapabilities":{"supportsPagination":true,"supportsQueryAttachmentsCountOnly":true,"supportsPaginationOnAggregatedQueries":true,"supportsQueryRelatedPagination":true,"supportsQueryWithDistance":true,"supportsReturningQueryExtent":false,"supportsStatistics":true,"supportsOrderBy":true,"supportsDistinct":true,"supportsQueryWithResultType":true,"supportsSqlExpression":true,"supportsAdvancedQueryRelated":true,"supportsCountDistinct":true,"supportsPercentileStatistics":true,"supportsSpatialAggregationStatistics":true,"supportedSpatialAggregationStatistics":["EnvelopeAggregate","CentroidAggregate","ConvexHullAggregate"],"supportsReturningGeometryCentroid":false,"supportsQueryWithDatumTransformation":true,"supportsHavingClause":true,"supportsOutFieldSQLExpression":true,"supportsMaxRecordCountFactor":true,"supportsTopFeaturesQuery":true,"supportsQueryWithCacheHint":true,"supportedOperationsWithCacheHint":["query","queryTopFilter","queryAnalytics","queryAttachments","queryRelated"],"supportsQueryAnalytic":true,"supportsDefaultSR":true,"supportsFullTextSearch":true},"advancedQueryAnalyticCapabilities":{"supportsLinearRegression":true,"supportsAsync":true,"supportsPercentileAnalytic":true},"advancedEditingCapabilities":{"supportedSqlFormatsInCalculate":["standard"],"supportsAsyncApplyEdits":true,"supportsReturnEditResults":true,"supportsApplyEditsbyUploadID":true,"supportedApplyEditsUploadIDFormats":"JSON"},"infoInEstimates":["count"],"useStandardizedQueries":false,"geometryType":"esriGeometryPoint","drawingInfo":{"renderer":{"type":"simple","symbol":{"type":"esriPMS","url":"RedSphere.png","imageData":"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","contentType":"image/png","width":15,"height":15}}},"allowGeometryUpdates":true,"hasAttachments":false,"htmlPopupType":"","hasM":false,"hasZ":false,"globalIdField":"","typeIdField":"","estimatedRecordCount":19,"fields":[{"name":"situsfulla","type":"esriFieldTypeString","alias":"situsfulla","sqlType":"sqlTypeNVarchar","length":4000,"nullable":true,"editable":true,"domain":null,"defaultValue":null,"locationType":"unknown"}],"indexes":[],"dateFieldsTimeReference":{"timeZone":"UTC","respectsDaylightSaving":false},"preferredTimeReference":null,"types":[],"templates":[{"name":"New Feature","description":"","drawingTool":"esriFeatureEditToolPoint","prototype":{"attributes":{"situsfulla":null}}}],"supportedQueryFormats":"JSON, geoJSON, PBF","supportedAppendFormats":"sqlite, geoPackage, shapefile, filegdb, featureCollection, geojson, csv, excel, jsonl","supportedExportFormats":"csv, shapefile, sqlite, geoPackage, filegdb, featureCollection, geojson, excel","supportedContingentValuesFormats":"JSON, PBF","supportedSyncDataOptions":4,"hasStaticData":true,"maxRecordCount":-1,"standardMaxRecordCount":32000,"tileMaxRecordCount":8000,"maxRecordCountFactor":1,"capabilities":"Query"},"capabilities":"Query","hasStaticData":true,"persistErrorRecordsForReview":true,"dateFieldsTimeReference":{"timeZone":"UTC"}}'
    }
    Process {
        # CONVERT TEMPLATE TO OBJECT
        $publishParams = $CsvTable | ConvertFrom-Json

        # ADD ITEM NAME TO PUBLISH PARAMS
        $publishParams.name = $ItemName
        $publishParams.layerInfo.name = $ItemName

        # ADD FIELDS TO PUBLISH PARAMS - SCHEMA SHOULD NOT INCLUDE OBJECTID
        $publishParams.layerInfo.fields = $Field

        # CREATE AND POPULATE ATTRIBUTES
        $attributes = [Ordered] @{}
        foreach ($i in $Field) { $attributes.Add($i.name, $null) }

        # ADD ATTRIBUTES TO PUBLISH PARAMS
        $publishParams.layerInfo.templates[0].prototype.attributes = $attributes

        # SET PARAMETERS FOR JOB ID
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/users/{1}/publish' -f $Context, $UserName
            Method = 'POST'
            Body   = @{
                f                 = 'json'
                token             = $Token
                itemId            = $ItemId
                filetype          = 'csv'
                publishParameters = ConvertTo-Json -InputObject $publishParams -Depth 10 -Compress
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE UPLOAD
        Invoke-RestMethod @restParams
    }
}
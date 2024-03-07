# ==============================================================================
# Filename: ArcGISEnterprise.psm1
# Updated:  2023-10-05
# Author:   Justin Johns
# ==============================================================================

# IMPORT ALL FUNCTIONS
foreach ( $directory in @('Public', 'Private') ) {
    foreach ( $fn in (Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1") ) { . $fn.FullName }
}

# VARIABLES
# NOT VALIDATING CONTEXT URL STRUCTURE AS THIS IS DONE BY [SYSTEM.URI] OBJECT
# ONLY VALIDATE URI DOES NOT END WITH FORWARD SLASH. OLD REGEX: '^https?://[\w\/\.:-]+[^/]$'
New-Variable -Name 'context_regex' -Option Constant -Value '^.+[^/]$'
New-Variable -Name 'token_regex' -Option Constant -Value '^[\w\.=-]+$'

# FUNCTION VARIALBLES
New-Variable -Name 'NewHostedServiceTemplate' -Value @'
{
    "name": "ApiTestService",
    "serviceDescription": "This is the service description from the JSON template.",
    "hasStaticData": false,
    "maxRecordCount": 1000,
    "supportedQueryFormats": "JSON",
    "capabilities": "Create,Delete,Query,Update,Editing",
    "description": "This is the description from the JSON template.",
    "copyrightText": "This is the copyright text from the JSON template.",
    "spatialReference": {
        "wkid": 102100,
        "latestWkid": 3857
    },
    "initialExtent": {
        "xmin": -20037507.0671618,
        "ymin": -30240971.9583862,
        "xmax": 20037507.0671618,
        "ymax": 18398924.324645,
        "spatialReference": {
            "wkid": 102100,
            "latestWkid": 3857
        }
    },
    "allowGeometryUpdates": false,
    "units": "esriMeters"
}
'@

New-Variable -Name 'NewHostedTableTemplate' -Value @'
{
    "advancedEditingCapabilities": {
        "supportsAsyncApplyEdits": true,
        "supportsApplyEditsbyUploadID": true,
        "supportsReturnEditResults": true,
        "supportedSqlFormatsInCalculate": [
            "standard"
        ],
        "supportedApplyEditsUploadIDFormats": "JSON"
    },
    "advancedQueryAnalyticCapabilities": {
        "supportsAsync": true,
        "supportsLinearRegression": true,
        "supportsPercentileAnalytic": false
    },
    "advancedQueryCapabilities": {
        "supportsSqlExpression": true,
        "supportsStatistics": true,
        "supportsQueryWithResultType": true,
        "supportsOrderBy": true,
        "supportsQueryRelatedPagination": true,
        "supportsLod": false,
        "supportsQueryWithCacheHint": false,
        "supportsQueryWithDatumTransformation": true,
        "supportsQueryAttachmentsWithReturnUrl": true,
        "supportsQueryAttachments": true,
        "supportsQueryDateBins": false,
        "supportsQueryAttachmentsCountOnly": true,
        "supportsReturningQueryExtent": true,
        "supportsOrderByOnlyOnLayerFields": false,
        "supportsOutFieldSqlExpression": true,
        "supportsQueryWithLodSR": false,
        "supportsTopFeaturesQuery": true,
        "supportsPaginationOnAggregatedQueries": true,
        "supportsMaxRecordCountFactor": true,
        "supportsPagination": true,
        "supportsDistinct": true,
        "supportsQueryAnalytic": true,
        "supportsPercentileStatistics": true,
        "supportsHavingClause": true
    },
    "allowGeometryUpdates": true,
    "allowUpdateWithoutMValues": true,
    "capabilities": "Query,Create,Update,Delete,Editing,Uploads",
    "cimVersion": "3.1.0",
    "copyrightText": "",
    "currentVersion": 11.1,
    "dateFieldsTimeReference": {
        "respectsDaylightSaving": false,
        "timeZone": "UTC"
    },
    "datesInUnknownTimezone": false,
    "description": "",
    "displayField": "type_text",
    "editFieldsInfo": null,
    "enableZDefaults": true,
    "fields": [
        {
            "nullable": false,
            "defaultValue": null,
            "editable": false,
            "length": 4,
            "type": "esriFieldTypeOID",
            "modelName": "OBJECTID",
            "sqlType": "sqlTypeInteger",
            "domain": null,
            "name": "objectid",
            "alias": "OBJECTID"
        },
        {
            "modelName": "type_text",
            "sqlType": "sqlTypeVarchar",
            "nullable": true,
            "editable": true,
            "defaultValue": null,
            "domain": null,
            "name": "type_text",
            "length": 100,
            "alias": "TYPE_TEXT",
            "type": "esriFieldTypeString"
        },
        {
            "modelName": "type_double",
            "sqlType": "sqlTypeNumeric",
            "nullable": true,
            "editable": true,
            "defaultValue": null,
            "domain": null,
            "name": "type_double",
            "length": 38,
            "alias": "TYPE_DOUBLE",
            "type": "esriFieldTypeDouble"
        },
        {
            "modelName": "type_int_short",
            "sqlType": "sqlTypeSmallInt",
            "nullable": true,
            "editable": true,
            "defaultValue": null,
            "domain": null,
            "name": "type_int_short",
            "length": 5,
            "alias": "TYPE_INT_SHORT",
            "type": "esriFieldTypeSmallInteger"
        },
        {
            "modelName": "type_int_long",
            "sqlType": "sqlTypeInteger",
            "nullable": true,
            "editable": true,
            "defaultValue": null,
            "domain": null,
            "name": "type_int_long",
            "length": 10,
            "alias": "TYPE_INT_LONG",
            "type": "esriFieldTypeInteger"
        },
        {
            "modelName": "type_float",
            "sqlType": "sqlTypeNumeric",
            "nullable": true,
            "editable": true,
            "defaultValue": null,
            "domain": null,
            "name": "type_float",
            "length": 38,
            "alias": "TYPE_FLOAT",
            "type": "esriFieldTypeDouble"
        },
        {
            "modelName": "type_date",
            "sqlType": "sqlTypeTimestamp",
            "nullable": true,
            "editable": true,
            "defaultValue": null,
            "domain": null,
            "name": "type_date",
            "length": 29,
            "alias": "TYPE_DATE",
            "type": "esriFieldTypeDate"
        },
        {
            "modelName": "type_guid",
            "sqlType": "sqlTypeVarchar",
            "nullable": true,
            "editable": true,
            "defaultValue": null,
            "domain": null,
            "name": "type_guid",
            "length": 38,
            "alias": "TYPE_GUID",
            "type": "esriFieldTypeGUID"
        },
        {
            "modelName": "type_blob",
            "sqlType": "sqlTypeBinary",
            "nullable": true,
            "editable": true,
            "defaultValue": null,
            "domain": null,
            "name": "type_blob",
            "length": 2147483647,
            "alias": "TYPE_BLOB",
            "type": "esriFieldTypeBlob"
        }
    ],
    "globalIdField": null,
    "hasAttachments": false,
    "hasMetadata": true,
    "htmlPopupType": "esriServerHTMLPopupTypeNone",
    "indexes": [
        {
            "name": "r64_sde_rowid_uk",
            "isUnique": true,
            "description": "",
            "fields": "objectid",
            "isAscending": true
        }
    ],
    "infoInEstimates": [
        "extent",
        "count"
    ],
    "isCoGoEnabled": false,
    "isDataArchived": false,
    "isDataBranchVersioned": false,
    "isDataReplicaTracked": false,
    "isDataVersioned": false,
    "layerAdminOperationsOptions": {
        "deleteFromDefinition": [
            "xssTrustedFields",
            "fields",
            "indexes",
            "relationships",
            "lodInfoIndexes"
        ],
        "addToDefiniton": [
            "fields",
            "indexes"
        ],
        "updateDefinition": [
            "name",
            "displayField",
            "description",
            "copyrightText",
            "editFieldsInfo",
            "minScale",
            "maxScale",
            "fields",
            "maxRecordCount",
            "drawingInfo",
            "types",
            "templates",
            "indexes",
            "defaultVisibility",
            "hasAttachments",
            "typeIdField",
            "timeInfo",
            "xssTrustedFields",
            "allowUpdateWithoutMValues",
            "maxResultWindow",
            "maxRecordCountFactor",
            "tableMetadata",
            "propagateVisibleFields",
            "hasGeometryProperties",
            "layerCache",
            "attachmentProperties",
            "lodInfos",
            "lastEditDate",
            "capabilities",
            "allowGeometryUpdates",
            "ownershipBasedAccessControlForFeatures",
            "definitionQuery"
        ]
    },
    "maxRecordCount": 2000,
    "maxRecordCountFactor": 1,
    "name": "DataTable",
    "objectIdField": "objectid",
    "relationships": [],
    "sqlParserVersion": "PG_10.9.1",
    "standardMaxRecordCount": 16000,
    "supportedAppendFormats": "shapefile,geojson,csv,featureCollection,excel",
    "supportedExportFormats": "sqlite,filegdb,shapefile,csv,geojson",
    "supportedQueryFormats": "JSON, geoJSON, PBF",
    "supportedSpatialRelationships": [
        "esriSpatialRelIntersects",
        "esriSpatialRelContains",
        "esriSpatialRelCrosses",
        "esriSpatialRelEnvelopeIntersects",
        "esriSpatialRelOverlaps",
        "esriSpatialRelTouches",
        "esriSpatialRelWithin"
    ],
    "supportsAdvancedQueries": true,
    "supportsAppend": true,
    "supportsApplyEditsWithGlobalIds": false,
    "supportsASyncCalculate": true,
    "supportsAsyncDelete": true,
    "supportsAttachmentsByUploadId": true,
    "supportsAttachmentsResizing": true,
    "supportsCalculate": true,
    "supportsCoordinatesQuantization": true,
    "supportsExceedsLimitStatistics": true,
    "supportsFieldDescriptionProperty": true,
    "supportsLayerOverrides": true,
    "supportsQuantizationEditMode": true,
    "supportsRollbackOnFailureParameter": true,
    "supportsStatistics": true,
    "supportsValidateSQL": true,
    "syncCanReturnChanges": true,
    "templates": [
        {
            "name": "DataTable",
            "description": "",
            "drawingTool": "esriFeatureEditToolNone",
            "prototype": {
                "attributes": {
                    "type_double": null,
                    "type_guid": null,
                    "type_float": null,
                    "type_text": null,
                    "type_int_long": null,
                    "type_blob": null,
                    "type_date": null,
                    "type_int_short": null
                }
            }
        }
    ],
    "tileMaxRecordCount": 4000,
    "type": "Table",
    "typeIdField": "",
    "types": [],
    "useStandardizedQueries": true,
    "zDefault": 0
}
'@

# EXPORT MEMBERS
# THESE ARE SPECIFIED IN THE MODULE MANIFEST AND THEREFORE DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
#Export-ModuleMember -Variable *
#Export-ModuleMember -Alias *
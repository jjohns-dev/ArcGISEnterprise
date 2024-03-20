function Get-ServerServiceFieldInfo {
    <#
    .SYNOPSIS
        Get ArcGIS Server service field information
    .DESCRIPTION
        Get ArcGIS Server service field information for fields belonging to services and service layers
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
        PS C:\> Get-ServerServiceFieldInfo -Context https://myServer.arcgis.com/arcgis -Folder Gas
        Returns an array of fields with accompanying service and layer properties
    .EXAMPLE
        PS C:\> Get-ServerServiceFieldInfo -Context https://myServer.arcgis.com/arcgis -Folder Gas, Traffic
        Returns an array of fields with length for "esriFieldTypeString" types
    .NOTES
        Name:     Get-ServerServiceFieldInfo
        Author:   Justin Johns
        Version:  0.1.3 | Last Edit: 2024-03-20
        - 0.1.3 - (2024-03-20) Updated parameter name for consistency
        - 0.1.2 - (2024-01-18) Added more properties to report
        - 0.1.1 - (2024-01-03) Adjusted default behavior and removed parameters for targeting "esriFieldTypeString"
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        - This function does not consider items in the root, meaning itesm that are not in one of the folders in ArcGIS Server.
        - The function only supports the following service types: MapServer, ImageServer, FeatureServer
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Target folder')]
        [ValidateNotNullOrEmpty()]
        [Alias('Folder')]
        [System.String[]] $FolderName,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
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

        # SET BASE URI
        $baseUri = '{0}/rest/services' -f $Context

        # SET REQUEST PARAMETERS
        $restParams = @{ Method = 'GET'; Body = @{ f = 'json' } }

        # ADD TOKEN IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams.Body['token'] = $Token }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
    }
    Process {
        # SET PARAMETERS FOR SERVICE INFO
        $servicInfoParams = $PSBoundParameters
        $servicInfoParams.Remove('Folder') | Out-Null

        # GET SERVICE INFO INCLUDING FOLDERS
        $servicInfo = Get-ServerServiceList @servicInfoParams

        # EVALUATE EACH FOLDER
        foreach ($fldr in $FolderName) {
            # VALIDATE FOLDER EXISTS
            if ($fldr -notin $servicInfo.folders) {
                throw ('Folder [{0}] not found.' -f $fldr)
            }
        }

        # EVALUATE EACH FOLDER
        foreach ($fldr in $FolderName) {

            # RESET URI
            $restParams['Uri'] = '{0}/{1}' -f $baseUri, $fldr

            # GET SERVICES IN FOLDER
            $folderData = Invoke-RestMethod @restParams

            # LOOP ALL SERVICES IN FOLDER
            foreach ($service in $folderData.services) {

                # RESET URI
                $restParams['Uri'] = '{0}/{1}/{2}' -f $baseUri, $service.name, $service.type

                # GET LAYERS IN SERVICE
                $serviceData = Invoke-RestMethod @restParams

                # ACCOUNT FOR SERVICES THAT DO NOT HAVE LAYERS BUT DO HAVE FIELDS
                if ($null -EQ $serviceData.layers) {

                    # EVALUATE EACH FIELD
                    foreach ($field in $serviceData.fields) {

                        # CREATE NEW FIELD OBJECT
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
                        }
                    }
                }
                else {
                    # LOOP ALL LAYERS IN SERVICE
                    foreach ($layer in $serviceData.layers) {

                        # RESET URI
                        $restParams['Uri'] = '{0}/{1}/{2}/{3}' -f $baseUri, $service.name, $service.type, $layer.id

                        # GET LAYER DATA
                        $layerData = Invoke-RestMethod @restParams

                        # LOOP ALL FIELDS
                        foreach ($field in $layerData.fields) {

                            # CREATE CUSTOM OBJECT
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
                            }
                        }
                    }
                }
            }
        }
    }
}
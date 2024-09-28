function Get-ServerServiceReport {
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
        PS C:\> Get-ServerServiceReport -Context https://myServer.arcgis.com/arcgis -Folder Gas
        Returns an array of fields with accompanying service and layer properties
    .EXAMPLE
        PS C:\> Get-ServerServiceReport -Context https://myServer.arcgis.com/arcgis -Folder Gas, Traffic
        Returns an array of fields with length for "esriFieldTypeString" types
    .NOTES
        Name:     Get-ServerServiceReport
        Author:   Justin Johns
        Version:  0.1.4 | Last Edit: 2024-09-23
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
        $cmnParms = $PSBoundParameters

        # VALIDATE FOLDER PARAMETER
        if ($PSBoundParameters.ContainsKey('FolderName')) {
            # REMOVE FOLDER PARAMETER
            $cmnParms.Remove('FolderName') | Out-Null

            # GET SERVICE INFO INCLUDING FOLDERS
            $serviceInfo = Get-ServerServiceList @cmnParms

            # VALIDATE THE FOLDER EXISTS
            if ($FolderName -notin $serviceInfo.folders) {
                # TERMINATE WITH ERROR
                Write-Error -Message ('Folder [{0}] not found.' -f $FolderName) -Exception ([System.IO.FileNotFoundException]::new()) -ErrorAction Stop
            }
            else {
                # ADD FOLDER BACK TO PARAMETERS
                $cmnParms['FolderName'] = $FolderName
            }
        }
    }
    Process {
        # GET SERVICES IN FOLDER
        $serviceList = Get-ServerServiceList @cmnParms

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
            $serviceData = Get-ServerServiceMetadata @cmnParms @serviceParams

            # CHECK FOR ERRORS -- should we build an error handler function (check for code and throw proper error)?
            if ($serviceData.error) {
                if ($serviceData.error.code -eq 404) {
                    Write-Error -Message $serviceData.error.message -Exception ([System.IO.FileNotFoundException]::new()) -ErrorAction Stop
                }
                else {
                    Write-Error -Message ($serviceData.error | ConvertTo-Json) -ErrorAction Stop
                }
            }

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

                    # GET LAYER DATA
                    $layerData = Get-ServerServiceLayer @cmnParms @serviceParams -LayerId $layer.id

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
function Get-ServerServiceFieldInfo {
    <#
    .SYNOPSIS
        Get ArcGIS Server service filed information
    .DESCRIPTION
        Get ArcGIS Server service filed information for "esriFieldTypeString" longer than a given threshold
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Folder
        Get folder(s)
    .PARAMETER FieldLength
        Field length threshold (default is greater than 254)
    .PARAMETER AllFields
        Get all fields
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServerServiceFieldInfo -Context https://myServer.arcgis.com/arcgis -Folder Gas, Traffic
        Returns an array of "esriFieldTypeString" fields with length larger than 254 characters
    .NOTES
        Name:     Get-ServerServiceFieldInfo
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2023-12-20
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        This function does not consider items in the root, meaning itesm that are not
        in one of the folders in ArcGIS Server.
    #>
    [CmdletBinding(DefaultParameterSetName = '_fltr')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Get folder')]
        [System.String[]] $Folder,

        [Parameter(Mandatory = $false, HelpMessage = 'Field length threshold (default is greater than 254)', ParameterSetName = '_fltr')]
        [System.Int32] $FieldLength = 254,

        [Parameter(Mandatory = $true, HelpMessage = 'Get all fields', ParameterSetName = '_all')]
        [System.Management.Automation.SwitchParameter] $AllFields,

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
        if ($servicInfoParams.ContainsKey('Folder')) { $servicInfoParams.Remove('Folder') | Out-Null }
        if ($servicInfoParams.ContainsKey('AllFields')) { $servicInfoParams.Remove('AllFields') | Out-Null }

        # GET SERVICE INFO INCLUDING FOLDERS
        $servicInfo = Get-ServerServiceInfo @servicInfoParams

        # EVALUATE EACH FOLDER
        foreach ($fldr in $Folder) {
            # VALIDATE FOLDER EXISTS
            if ($fldr -notin $servicInfo.folders) {
                throw ('Folder [{0}] not found.' -f $fldr)
            }
        }

        # EVALUATE EACH FOLDER
        foreach ($fldr in $Folder) {

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

                # LOOP ALL LAYERS IN SERVICE
                foreach ($layer in $serviceData.layers) {

                    # RESET URI
                    $restParams['Uri'] = '{0}/{1}/{2}/{3}' -f $baseUri, $service.name, $service.type, $layer.id

                    # GET LAYER DATA
                    $layerData = Invoke-RestMethod @restParams

                    # LOOP ALL FIELDS
                    foreach ($field in $layerData.fields) {

                        # CHECK FOR "AllFields" PARAMETER
                        if ($PSCmdlet.ParameterSetName -eq '_all') {

                            # CREATE CUSTOM OBJECT
                            [PSCustomObject] @{
                                ServiceName           = $service.name
                                ServiceNameLength     = $service.name.Length
                                ServiceType           = $service.type
                                SupportsDynamicLayers = $serviceData.supportsDynamicLayers
                                LayerId               = $layer.id
                                LayerName             = $layer.name
                                LayerHasSpecialChars  = if ($layer.name -match '\W') { $true } else { $false }
                                LayerNameLength       = $layer.name.Length
                                FieldName             = $field.name
                                FieldHasSpecialChars  = if ($field.name -match '\W') { $true } else { $false }
                                FieldNameLength       = $field.name.length
                                FieldType             = $field.type
                            }
                        }
                        else {

                            # FILTER STRING TYPE FILEDS WITH MORE THAN X LENGTH
                            if ($field.type -EQ 'esriFieldTypeString' -and $field.length -GT $FieldLength) {

                                # CREATE CUSTOM OBJECT
                                [PSCustomObject] @{
                                    #Folder            = $fldr
                                    ServiceName          = $service.name
                                    ServiceNameLength    = $service.name.Length
                                    ServiceType          = $service.type
                                    LayerId              = $layer.id
                                    LayerName            = $layer.name
                                    LayerHasSpecialChars = if ($layer.name -match '\W') { $true } else { $false }
                                    LayerNameLength      = $layer.name.Length
                                    FieldName            = $field.name
                                    FieldHasSpecialChars = if ($field.name -match '\W') { $true } else { $false }
                                    FieldNameLength      = $field.name.length
                                    FieldType            = $field.type
                                    FieldLength          = $field.length
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
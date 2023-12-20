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
    .PARAMETER AllFolders
        Get all folders
    .PARAMETER FieldLength
        Field length threshold (default is greater than 254)
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
        Name:     Get-ServiceFieldInfo
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2023-12-20
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        This function does not consider items in the root, meaning itesm that are not
        in one of the folders in ArcGIS Server.
    #>
    [CmdletBinding(DefaultParameterSetName = '_fldr')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Get folder', ParameterSetName = '_fldr')]
        [System.String[]] $Folder,

        [Parameter(Mandatory = $true, HelpMessage = 'Get all folders', ParameterSetName = '_all')]
        [System.Management.Automation.SwitchParameter] $AllFolders,

        [Parameter(Mandatory = $false, HelpMessage = 'Field length threshold (default is greater than 254)')]
        [System.Int32] $FieldLength = 254,

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
        if ($servicInfoParams.ContainsKey('AllFolders')) { $servicInfoParams.Remove('AllFolders') | Out-Null }

        # GET SERVICE INFO INCLUDING FOLDERS
        $servicInfo = Get-ServerServiceInfo @servicInfoParams

        # CHECK FOR FOLDER PARAMETER
        if ($PSCmdlet.ParameterSetName -EQ '_fldr') {
            # EVALUATE EACH FOLDER
            foreach ($fldr in $Folder) {
                # VALIDATE FOLDER EXISTS
                if ($fldr -notin $servicInfo.folders) {
                    throw ('Folder [{0}] not found.' -f $fldr)
                }
            }
        }
        else {
            # GET ALL FOLDERS
            $Folder = $servicInfo.folders
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

                        # FILTER STRING TYPE FILEDS WITH MORE THAN X LENGTH
                        if ($field.type -EQ 'esriFieldTypeString' -and $field.length -GT $FieldLength) {

                            # CREATE CUSTOM OBJECT
                            [PSCustomObject] @{
                                #Folder            = $fldr
                                ServiceName       = $service.name
                                ServiceNameLength = $service.name.Length
                                ServiceType       = $service.type
                                LayerId           = $layer.id
                                LayerName         = $layer.name
                                LHasSpecialChars  = if ($layer.name -match '\W') { $true } else { $false }
                                LayerNameLength   = $layer.name.Length
                                FieldName         = $field.name
                                FHasSpecialChars  = if ($field.name -match '\W') { $true } else { $false }
                                FieldType         = $field.type
                                FieldLength       = $field.length
                            }
                        }
                    }
                }
            }
        }
    }
}
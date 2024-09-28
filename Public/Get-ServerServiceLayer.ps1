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
        Version:  0.1.0 | Last Edit: 2024-09-28
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
                # OUTPUT LAYER METADATA
                $layerMetadata
            }
        }
    }
}
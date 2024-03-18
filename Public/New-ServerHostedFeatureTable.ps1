function New-ServerHostedFeatureTable {
    <#
    .SYNOPSIS
        Create new Hosted Feature Serivce table
    .DESCRIPTION
        Create new table "layer" in a Hosted Feature Serivce
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
    .PARAMETER TableName
        Hosted Feature Service Table Name
    .PARAMETER Field
        Table field (i.e., schema)
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
        PS C:\> New-ServerHostedFeatureTable -ServiceName myNewService -TableName 'DataTable' -Field $Field @commonParams
        Creates a new table "layer" in a Hosted Feature Service with the name DataTable
    .NOTES
        Name:     New-ServerHostedFeatureTable
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-16
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/services-reference/online/add-to-definition-feature-service-.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal Hosted Feature Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $false, HelpMessage = 'Hosted Feature Service Table Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $TableName = 'DataTable',

        [Parameter(Mandatory = $true, HelpMessage = 'Table field (i.e., schema)')]
        #[ValidateNotNullOrEmpty()]
        [ValidateScript({
            $reqProps = @('nullable', 'editable', 'type', 'name', 'alias')
            $valid = foreach ($rp in $reqProps) { $rp -in $_[0].psobject.Properties.Name }
            $false -notin $valid
        })]
        [Alias('Schema')]
        [System.Object[]] $Field,

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

        # GET HOSTED FEATURE SERVICE TABLE TEMPLATE AND CONVERT TO OBJECT
        Write-Verbose -Message 'Getting new table template...'
        $definition = Get-Content -Path "$ModulePrivate\hosted_feature_service_table.template" | ConvertFrom-Json

        # VALIDATE NUMBER OF FIELDS IN SCHEMA
        if ($Field.Count -GT 68) {
            # PRINT WARNING
            Write-Warning -Message 'Schemas containing more than 68 fields don''t appear to be support through the REST API'
            Write-Warning -Message 'Table creation may fail. Please use fewer columns.'
        }
    }
    Process {
        # UPDATE NAME PROPERTY IN TEMPLATE
        Write-Verbose -Message 'Updating template...'

        # UPDATE TABLE NAME
        $definition.layers[0].name = $TableName

        # ADD FIELD SCHEMA TO TEMPLATE
        $definition.layers[0].fields = $Field

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/rest/admin/services/Hosted/{1}/FeatureServer/addToDefinition' -f $Context, $ServiceName
            Method = 'POST'
            Body   = @{
                f               = 'json'
                token           = $Token
                addToDefinition = $definition | ConvertTo-Json -Depth 5 -Compress
            }
        }

        # WRITE VERBOSE MESSAGE
        Write-Verbose -Message ('Endpoint URI: [{0}]' -f $restParams['Uri'])

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}
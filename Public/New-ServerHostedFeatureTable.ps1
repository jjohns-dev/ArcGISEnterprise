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
        PS C:\> New-ServerHostedFeatureTable -ServiceName myNewService -TableName 'DataTable' -Field $schema @commonParams
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

        # SET TEMPLATE
        New-Variable -Name 'NewHostedTableTemplate' -Option ReadOnly -Value '{"layers":[{"fields":[{"nullable":false,"defaultValue":null,"editable":false,"length":4,"type":"esriFieldTypeOID","modelName":"OBJECTID","sqlType":"sqlTypeInteger","domain":null,"name":"objectid","alias":"OBJECTID"},{"modelName":"type_text","sqlType":"sqlTypeVarchar","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_text","length":100,"alias":"TYPE_TEXT","type":"esriFieldTypeString"},{"modelName":"type_double","sqlType":"sqlTypeNumeric","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_double","length":38,"alias":"TYPE_DOUBLE","type":"esriFieldTypeDouble"},{"modelName":"type_int_short","sqlType":"sqlTypeSmallInt","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_int_short","length":5,"alias":"TYPE_INT_SHORT","type":"esriFieldTypeSmallInteger"},{"modelName":"type_int_long","sqlType":"sqlTypeInteger","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_int_long","length":10,"alias":"TYPE_INT_LONG","type":"esriFieldTypeInteger"},{"modelName":"type_float","sqlType":"sqlTypeNumeric","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_float","length":38,"alias":"TYPE_FLOAT","type":"esriFieldTypeDouble"},{"modelName":"type_date","sqlType":"sqlTypeTimestamp","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_date","length":29,"alias":"TYPE_DATE","type":"esriFieldTypeDate"},{"modelName":"type_guid","sqlType":"sqlTypeVarchar","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_guid","length":38,"alias":"TYPE_GUID","type":"esriFieldTypeGUID"},{"modelName":"type_blob","sqlType":"sqlTypeBinary","nullable":true,"editable":true,"defaultValue":null,"domain":null,"name":"type_blob","length":2147483647,"alias":"TYPE_BLOB","type":"esriFieldTypeBlob"}],"name":"DataTable","objectIdField":"objectid","type":"Table"}]}'

        # SET VARIABLE FOR TABLE DATA TEMPLATE
        Write-Verbose -Message 'Getting new table template...'
        $definition = $NewHostedTableTemplate | ConvertFrom-Json

        # VALIDATE NUMBER OF FIELDS IN SCHEMA
        if ($Schema.Count -GT 68) {
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
        $definition.layers[0].fields = $Schema

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
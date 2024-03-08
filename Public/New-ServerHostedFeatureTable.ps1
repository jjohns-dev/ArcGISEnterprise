function New-ServerHostedFeatureTable {
    <#
    .SYNOPSIS
        Create new Hosted Feature Serivce table
    .DESCRIPTION
        Create new Hosted Feature Serivce table
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
    .PARAMETER Schema
        Table schema
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
        PS C:\> New-ServerHostedFeatureTable
        Explanation of what the example does
    .NOTES
        Name:     New-ServerHostedFeatureTable
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-07
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/services-reference/online/add-to-definition-feature-service-.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal Hosted Feature Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $false, HelpMessage = 'Table schema')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            $reqProps = 'nullable', 'editable', 'type', 'modelName', 'name', 'alias'
            $valid = foreach ($rp in $reqProps) { $rp -in $_[0].psobject.Properties.Name }
            $false -notin $valid
        })]
        [System.Object[]] $Schema,

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

        # SET VARIABLE FOR TABLE DATA TEMPLATE
        Write-Verbose -Message 'Getting new table template...'
        $template = $NewHostedTableTemplate | ConvertFrom-Json
    }
    Process {
        # UPDATE NAME PROPERTY IN TEMPLATE
        Write-Verbose -Message 'Updating template...'
        if ($PSBoundParameters.ContainsKey('Schema')) { $template.fields = $Schema } # need to change this

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/rest/admin/services/Hosted/{1}/FeatureServer/addToDefinition' -f $Context, $ServiceName
            Method = 'POST'
            Body   = @{
                addToDefinition = $template | ConvertTo-Json -Depth 5 -Compress
                f               = 'json'
                token           = $Token
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
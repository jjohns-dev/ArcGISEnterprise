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
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/publish-item.htm
        https://developers.arcgis.com/documentation/mapping-apis-and-services/data-hosting/tutorials/tools/import-data-to-create-a-table/
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([System.Management.Automation.PSCustomObject])]
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
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)

        # VALIDATE USER NAME
        if (-Not $PSBoundParameters.ContainsKey('UserName')) {
            try {
                # GET USER PORTAL INFO
                Write-Verbose -Message 'Getting user settings...'
                $userSettings = Get-PortalSetting -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck

                # SET USER NAME
                $UserName = $userSettings.user.username
            }
            catch {
                # PASS ERROR
                Write-Error -Message ('Unable to get user info with error: {0}' -f $PSItem.Exception.Message) -ErrorAction Stop
            }
        }

        # GET HOSTED TABLE TEMPLATE AND CONVERT TO OBJECT
        $publishParams = Get-Content -Path "$ModulePrivate\csv_hosted_table.template" | ConvertFrom-Json
    }
    Process {
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
        if ($PSCmdlet.ShouldProcess(('{0} (item [{1}])' -f $ItemName, $ItemId), 'Publish CSV item as hosted table')) {
            Invoke-RestMethod @restParams
        }
    }
}
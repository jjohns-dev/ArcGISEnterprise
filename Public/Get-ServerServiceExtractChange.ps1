function Get-ServerServiceExtractChange {
    <#
    .SYNOPSIS
        Return change history for ArcGIS Server service
    .DESCRIPTION
        Use the extractChanges endpoint to return change history for service
    .PARAMETER ServiceName
        Name of service
    .PARAMETER FolderName
        Folder name in ArcGIS Server (defaults to "Hosted")
    .PARAMETER IdsOnly
        Returns IDs only
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
        PS C:\> $request = Get-ServerServiceExtractChange @cmnParams -ServiceName 'MyService'
        $job = Invoke-RestMethod -Uri $request.statusUrl -Method Post -Body @{ f = 'json'; token = $token }
        $data = Invoke-RestMethod -Uri $job.resultUrl -Method Post -Body @{ f = 'json'; token = $token }
        The first line submits a job to generate the change data for service "MyService."
        Second line returns an object with the property "resultUrl" to retrieve the change data.
        Third line returns the change data for the service "MyService"
    .NOTES
        Name:     Get-ServerServiceExtractChange
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-10-25
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/services-reference/enterprise/extract-changes-feature-service/
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $false, HelpMessage = 'Folder name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $FolderName = 'Hosted',

        [Parameter(Mandatory = $false, HelpMessage = 'Return IDs only')]
        [System.Management.Automation.SwitchParameter] $IdsOnly,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Server context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(Mandatory = $false, HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/rest/services/{1}/{2}/FeatureServer/extractChanges' -f $Context, $FolderName, $ServiceName
            Method = 'POST'
            Body   = @{ f = 'json'; token = $Token }
            Headers = @{
                referer                    = '{0}://{1}' -f $Context.Scheme, $Context.Authority
                returnIdsOnly              = if ($PSBoundParameters.ContainsKey('IdsOnly')) { $true } else { $false }
                returnInserts              = $true
                returnUpdates              = $true
                returnDeletes              = $true
                returnHasGeometryUpdates   = $true
                returnDeletedFeatures      = $true # AVAILABLE IN AGOL AND EGDB
                returnAttachments          = $true
                returnAttachmentsDataByUrl = $true
                #returnExtentOnly           = $false
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # OUTPUT VERBOSE
        Write-Verbose -Message ("Request headers:`n{0}" -f ($restParams['Headers'].GetEnumerator() | Out-String) )

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
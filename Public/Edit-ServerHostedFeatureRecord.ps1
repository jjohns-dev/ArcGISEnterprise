function Edit-ServerHostedFeatureRecord {
    <#
    .SYNOPSIS
        Edit Hoste Feature Service
    .DESCRIPTION
        Edit Hoste Feature Service using the /applyEdits endpoint. This allows for
        adding, updating, or deleting records/features.
    .PARAMETER Record
        Record or data to add to the Portal Hosted Feature Service
    .PARAMETER Update
        Record/feature to update
    .PARAMETER Delete
        ObjectId of record/feature to delete
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
    .PARAMETER LayerId
        Service Layer ID
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
        PS C:\> Edit-ServerHostedFeatureRecord
        Explanation of what the example does
    .NOTES
        Name:     Edit-ServerHostedFeatureRecord
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-13
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/services-reference/enterprise/apply-edits-feature-service-layer-.htm
    #>
    [CmdletBinding(DefaultParameterSetName = '_adds')]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = '_adds', HelpMessage = 'Record/feature to add')]
        [ValidateScript({ $_.psobject.Members.Name -contains 'attributes' })]
        [System.Object[]] $Record,

        [Parameter(Mandatory = $true, ParameterSetName = '_updates', HelpMessage = 'Record/feature to update')]
        [ValidateScript({ $_.psobject.Members.Name -contains 'attributes' })]
        [System.Object[]] $Update,

        [Parameter(Mandatory = $true, ParameterSetName = '_deletes', HelpMessage = 'ObjectId of record/feature to delete')]
        [ValidateScript({ $_.psobject.Members.Name -contains 'attributes' })]
        [System.Int32[]] $Delete,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal Hosted Feature Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $false, HelpMessage = 'Service Layer ID')]
        [ValidateNotNullOrEmpty()]
        [Alias('Layer')]
        [System.Int32] $LayerId = 0,

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
    }
    Process {
        # SET PARAMETERS FOR ADDING DATA
        $restParams = @{
            Uri    = '{0}/rest/services/Hosted/{1}/FeatureServer/{2}/applyEdits' -f $Context, $ServiceName, $LayerId
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
                #async = $true
            }
        }

        # CHECK FOR ADDS, UPDATES, OR DELETES
        if ($PSBoundParameters.ContainsKey('Record')) {
            $restParams.Body['adds'] = $Record | ConvertTo-Json -Depth 10 -Compress -AsArray
        }
        elseif ($PSBoundParameters.ContainsKey('Update')) {
            $restParams.Body['updates'] = $Update | ConvertTo-Json -Depth 10 -Compress -AsArray
        }
        elseif ($PSBoundParameters.ContainsKey('Delete')) {
            $restParams.Body['deletes'] = $Delete -join ','
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE DATA ADD
        Invoke-RestMethod @restParams
    }
}
function Add-ServerFeature {
    <#
    .SYNOPSIS
        Add feature to Feature Service
    .DESCRIPTION
        Add feature to a Feature Service
    .PARAMETER Record
        Feature record or attributes to add
    .PARAMETER Feature
        Feature to add to the Feature Service
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
    .PARAMETER LayerId
        Service Layer ID
    .PARAMETER FolderName
        Server Service Folder Name
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
        PS C:\> Add-ServerFeature @commonParams -Record $rec -ServiceName "dashboard"
        Add records to a Hosted Feature Service named "dashboard"
    .NOTES
        Name:     Add-ServerFeature
        Author:   Justin Johns
        Version:  0.1.2 | Last Edit: 2024-02-19
        - See commit history for version changes
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/services-reference/enterprise/add-features.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Feature record or attributes to add', ParameterSetName = '__rcd')]
        [ValidateNotNullOrEmpty()]
        [System.Object[]] $Record,

        [Parameter(Mandatory = $true, HelpMessage = 'Feature to add', ParameterSetName = '__ftr')]
        [ValidateScript({ $_.psobject.Properties.Name -contains 'attributes' })] # FEATURE MAY ALSO CONTAIN "geometry"
        [ValidateNotNullOrEmpty()]
        [System.Object[]] $Feature,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal Hosted Feature Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $false, HelpMessage = 'Service Layer ID')]
        [ValidateNotNullOrEmpty()]
        [Alias('Layer')]
        [System.Int32] $LayerId = 0,

        [Parameter(Mandatory = $false, HelpMessage = 'Folder name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $FolderName = 'Hosted',

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
        # VALIDATE PARAMETER SET
        switch ($PSCmdlet.ParameterSetName) {
            '__rcd' {
                # SET COLLECTION FOR FEATURE RECORDS
                $features = [System.Collections.Generic.List[System.Object]]::new()

                # ADD RECORD TO COLLECTION
                foreach ($i in $Record) { $features.Add((@{ attributes = $i })) }
            }
            '__ftr' {
                # SET FEATURE COLLECTION
                $features = $Feature
            }
        }

        # SET PARAMETERS FOR ADDING DATA
        $restParams = @{
            Uri    = '{0}/rest/services/{1}/{2}/FeatureServer/{3}/addFeatures' -f $Context, $FolderName, $ServiceName, $LayerId
            Method = 'POST'
            Body   = @{
                features = $features | ConvertTo-Json -Depth 6 -Compress -AsArray
                f        = 'json'
                token    = $Token
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE DATA ADD
        Invoke-RestMethod @restParams
    }
}
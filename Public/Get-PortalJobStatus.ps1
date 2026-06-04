function Get-PortalJobStatus {
    <#
    .SYNOPSIS
        Get Portal job status
    .DESCRIPTION
        Gets the job status for a Portal job
    .PARAMETER JobId
        Portal job ID
    .PARAMETER ItemId
        Id of Portal item
    .PARAMETER JobType
        Portal job type
    .PARAMETER DataStoreId
        Id of the DataStore registered with Server
    .PARAMETER ServerId
        ID of the Server to which the DataStore is registered
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
        PS C:\> Get-PortalJobStatus -ItemId $iid -JobId j808b16d104894c8b8d9404555966eb6e @commonParams
        Gets the job status for a publish job with id j808b16d104894c8b8d9404555966eb6e and Item ID $iid
    .EXAMPLE
        PS C:\> Get-PortalJobStatus -JobId j59ec3a9893e840bda95d65136b99f2e2 -DataStoreId $dsId -ServerId $sId @commonParams
        Returns a job status object for a "publish all layers" job
    .NOTES
        Name:     Get-PortalJobStatus
        Author:   Justin Johns
        Version:  0.1.1 | Last Edit: 2024-03-25
        - 0.1.1 - (2024-03-25) Updates to include publishAllDatasets job
        - 0.1.0 - (2024-03-15) Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/status.htm
    #>
    [CmdletBinding(DefaultParameterSetName = '_item')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal job ID')]
        [ValidatePattern('j[a-f0-9]{32}')]
        [System.String] $JobId,

        [Parameter(Mandatory = $true, ParameterSetName = '_item', HelpMessage = 'Id of Portal item')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $ItemId,

        [Parameter(Mandatory = $false, ParameterSetName = '_item', HelpMessage = 'Portal job type')]
        [ValidateSet('publish', 'generateFeatures', 'export', 'createService', 'publishAllDatasets')]
        [System.String] $JobType = 'publish',

        [Parameter(Mandatory = $true, ParameterSetName = '_dtst', HelpMessage = 'Id of the DataStore registered with Server')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $DataStoreId,

        [Parameter(Mandatory = $true, ParameterSetName = '_dtst', HelpMessage = 'ID of the Server where the DataStore is registered')]
        [ValidatePattern('[a-z0-9]{16}')]
        [System.String] $ServerId,

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
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # VALIDATE USER NAME
        if (-Not $PSBoundParameters.ContainsKey('UserName')) {
            try {
                # GET USER PORTAL INFO
                Write-Verbose -Message 'Getting user settings...'
                $userSettings = Get-PortalSettings -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck

                # SET USER NAME
                $UserName = $userSettings.user.username
            }
            catch {
                # PASS ERROR
                Write-Error -Message ('Unable to get user info with error: {0}' -f $PSItem.Exception.Message) -ErrorAction Stop
            }
        }
    }
    Process {
        # SET REQUEST BODY
        $body = @{ f = 'json'; token = $Token }

        # CHECK PARAMETER SET
        switch ($PSCmdlet.ParameterSetName) {
            '_item' {
                # SET TARGET RESOURCE
                $targetId = $ItemId

                # ADD APPROPRIATE QUERY PARAMETERS
                $body.Add('jobType', $JobType)
                $body.Add('jobId', $JobId)
            }
            '_dtst' {
                # SET TARGET RESOURCE
                $targetId = $DataStoreId

                # ADD APPROPRIATE QUERY PARAMETERS
                $body.Add('serviceId', $ServerId)
            }
        }

        # SET PARAMETERS FOR JOB ID
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/users/{1}/items/{2}/status' -f $Context, $UserName, $targetId
            Method = 'GET'
            Body   = $body
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE UPLOAD
        Invoke-RestMethod @restParams
    }
}
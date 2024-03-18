function Get-PortalJobStatus {
    <#
    .SYNOPSIS
        Get Portal job status
    .DESCRIPTION
        Gets the job status for a Portal job
    .PARAMETER ItemId
        Id of Portal item
    .PARAMETER JobType
        Portal job type
    .PARAMETER JobId
        Portal job ID
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
    .NOTES
        Name:     Get-PortalJobStatus
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-15
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/status.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Id of Portal item')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $ItemId,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal job type')]
        [ValidateSet('publish', 'generateFeatures', 'export', 'createService')]
        [System.String] $JobType = 'publish',

        [Parameter(Mandatory = $true, HelpMessage = 'Portal job ID')]
        #[ValidatePattern('j[a-f0-9]{32}')] # jobId=j808b16d104894c8b8d9404555966eb6e;
        [ValidateNotNullOrEmpty()]
        [System.String] $JobId,

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
                throw ('Unable to get user info with error: {0}' -f $_.Exception.Message)
            }
        }
    }
    Process {
        # SET PARAMETERS FOR JOB ID
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/users/{1}/items/{2}/status' -f $Context, $UserName, $ItemId
            Method = 'GET'
            Body   = @{
                f       = 'json'
                token   = $Token
                jobType = $JobType
                jobId   = $JobId
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE UPLOAD
        Invoke-RestMethod @restParams
    }
}
function New-PortalHostedFeatureService {
    <#
    .SYNOPSIS
        Create new Hosted Feature Service
    .DESCRIPTION
        Create new Hosted Feature Service in ArcGIS Server
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
    .PARAMETER Description
        Hosted Feature Service description
    .PARAMETER Snippet
        Hosted Feature Service snippet (i.e., summary)
    .PARAMETER Tag
        Hosted Feature Service tag
    .PARAMETER UserName
        Owner of Hosted Feature Service
    .PARAMETER FolderId
        Destination Folder ID ofor Hosted Feature Service
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
        PS C:\> New-PortalHostedFeatureService -ServiceName myNewService -Description 'new' -Summary 'new' -Tag 'new', 'tag1'
        Creates a new Hosted Feature Service with the name myNewService
    .NOTES
        Name:     New-PortalHostedFeatureService
        Author:   Justin Johns
        Version:  0.1.1 | Last Edit: 2024-03-16
        - 0.1.1 - Added FolderId parameter
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/create-service.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal Hosted Feature Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $true, HelpMessage = 'Hosted Feature Service description')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Description,

        [Parameter(Mandatory = $false, HelpMessage = 'Hosted Feature Service snippet (i.e., summary)')]
        [ValidateNotNullOrEmpty()]
        [Alias('Summary')]
        [System.String] $Snippet,

        [Parameter(Mandatory = $true, HelpMessage = 'Hosted Feature Service tag')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $Tag,

        [Parameter(Mandatory = $false, HelpMessage = 'Owner of Hosted Feature Service')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

        [Parameter(Mandatory = $false, HelpMessage = 'Destination folder ID')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $FolderId,

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

        # GET HOSTED FEATURE SERVICE TEMPLATE AND CONVERT TO OBJECT
        Write-Verbose -Message 'Getting new hosted feature service template...'
        $template = Get-Content -Path "$ModulePrivate\hosted_feature_service.template" | ConvertFrom-Json

    }
    Process {
        # UPDATE NAME PROPERTY IN TEMPLATE
        Write-Verbose -Message 'Updating template...'
        $template.name = $ServiceName

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

        # CHECK FOR FOLDERID PARAMETER & SET REST URI
        if ($PSBoundParameters.ContainsKey('FolderId')) {
            $uri = '{0}/sharing/rest/content/users/{1}/{2}/createService' -f $Context, $UserName, $FolderId
        }
        else {
            $uri = '{0}/sharing/rest/content/users/{1}/createService' -f $Context, $UserName
        }

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = $uri
            Method = 'POST'
            Body   = @{
                createParameters = $template | ConvertTo-Json -Depth 4 -Compress
                outputType       = 'featureService'
                description      = $Description
                tags             = $Tag -join ', '
                snippet          = $Summary
                token            = $Token
                f                = 'json'
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
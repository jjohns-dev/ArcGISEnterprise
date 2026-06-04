function New-PortalUser {
    <#
    .SYNOPSIS
        Create new user
    .DESCRIPTION
        Create new Portal user
    .PARAMETER UserName
        Username
    .PARAMETER FirstName
        First name
    .PARAMETER LastName
        Last name
    .PARAMETER Email
        Email
    .PARAMETER Role
        User Role
    .PARAMETER UserType
        User type name
    .PARAMETER Password
        Password
    .PARAMETER IDPUserName
        IDP Username
    .PARAMETER Provider
        IDP Provider (e.g., oidc_<provider_id> for OIDC)
    .PARAMETER Description
        Description
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
        PS C:\> New-PortalUser -UserName joedoe -FirstName Joe -LastName Doe -Email joedoe@domain.com -UserType viewerUT -Password (Read-Host -AsSecureString)
        Creates a new user with username joedoe
    .EXAMPLE
        PS C:\> $oidc = Get-PortalOIDCList @cmnParams
        PS C:\> New-PortalUser -UserName joedoe -FirstName Joe -LastName Doe -Email joedoe@domain.com -IDPUserName joedoe -Provider $oidc[0].id @cmnParams
        Creates a new user with username joedoe using OIDC authentication from the first OIDC provider in the list
    .NOTES
        Name:     New-PortalUser
        Author:   Justin Johns
        Version:  0.1.1 | Last Edit: 2024-06-12
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/portal/create-user/
        https://community.esri.com/t5/arcgis-rest-apis-and-services-questions/invalid-token-for-portaladmin-security-users/td-p/303096
        https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods
    #>
    [CmdletBinding(DefaultParameterSetName = '_bltn', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

        [Parameter(Mandatory = $false, HelpMessage = 'First name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $FirstName,

        [Parameter(Mandatory = $false, HelpMessage = 'Last name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $LastName,

        [Parameter(Mandatory = $true, HelpMessage = 'Email address')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Email,

        [Parameter(Mandatory = $false, HelpMessage = 'User Role')]
        [ValidateNotNullOrEmpty()] # org_admin|org_publisher|org_user|iBBBBBBBBBBBBBBB (Data Editor)|iAAAAAAAAAAAAAAA (Viewer)
        [System.String] $Role = 'org_user',

        [Parameter(Mandatory = $true, HelpMessage = 'User type name')]
        # liteUT (Partner user type)|basicUT (Partner user type)|standardUT (Partner user type)
        [ValidateSet('creatorUT', 'editorUT', 'GISProfessionalAdvUT', 'GISProfessionalBasicUT', 'GISProfessionalStdUT', 'viewerUT', 'fieldWorkerUT')]
        [System.String] $UserType,

        [Parameter(Mandatory = $true, ParameterSetName = '_bltn', HelpMessage = 'Password (only requred for built-in users)')]
        [ValidateNotNullOrEmpty()]
        [System.Security.SecureString] $Password,

        <# [Parameter(Mandatory = $false, HelpMessage = '')]
        [ValidateSet('arcgis', 'enterprise')] # 'arcgis' is a built-in, forms user
        [System.String] $Provider = 'arcgis', #>

        [Parameter(Mandatory = $true, ParameterSetName = '_saml', HelpMessage = 'IDP Username')]
        [Parameter(Mandatory = $true, ParameterSetName = '_oidc', HelpMessage = 'IDP Username')]
        [System.String] $IDPUserName,

        [Parameter(Mandatory = $true, ParameterSetName = '_oidc', HelpMessage = 'IDP Provider')]
        [ValidatePattern('^oidc_\w+$')]
        [System.String] $Provider,

        [Parameter(Mandatory = $false, HelpMessage = 'User description')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Description,

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

        # SET PROVIDER
        $Provider = switch ($PSCmdlet.ParameterSetName) {
            '_bltn' { 'arcgis' }
            '_saml' { 'enterprise' }
            default { $Provider }
        }
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/portaladmin/security/users/createUser' -f $Context
            Method = 'POST'
            Body   = [Ordered] @{
                username          = $UserName
                email             = $Email
                role              = $Role
                userLicenseTypeId = $UserType
                provider          = $Provider
                idpUsername       = if ($PSCmdlet.ParameterSetName -ne '_bltn') { $IDPUserName } else { '' }
                firstname         = $FirstName
                lastname          = $LastName
                description       = $Description
                f                 = 'json'
                token             = $Token
            }
            Headers = @{
                # THIS HEADER IS REQUIRED FOR "createUser". WITHOUT IT THE ERROR MESSAGE BELOW IS RETURNED
                # {'error': {'code': 500, 'message': 'Invalid token.', 'details': None}}
                referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority
            }
        }

        # ADD NON-REQUIRED PARAMETERS
        if ($PSCmdlet.ParameterSetName -eq '_bltn') {
            # UNWIND SECURE STRING FOR PASSWORD
            $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
            $unsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

            # ADD PASSWORD TO QUERY PARAMETERS
            $restParams.Body['password'] = $unsecurePassword
        }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Provider: [{0}]' -f $restParams.Body['provider'])

        # BE SURE TO DELETE OR COMMENT THIS BEFORE MERGING PR
        #Write-Verbose -Message ('Request parameters: {0}' -f ($restParams.Body | Out-String))

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($UserName, ('Create new user with provider [{0}]' -f $Provider))) {

            # INVOKE REQUEST
            Invoke-RestMethod @restParams
        }
    }
    Clean {
        # REMOVE SECRETS
        Remove-Variable -Name 'bstr', 'unsecurePassword' -Force -Confirm:$false -ErrorAction Ignore
    }
}
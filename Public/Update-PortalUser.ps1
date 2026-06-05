function Update-PortalUser {
    <#
    .SYNOPSIS
        Update Portal user
    .DESCRIPTION
        Modify properties of Portal user (i.e., IDP type, name, email, etc.)
    .PARAMETER UserName
        Username
    .PARAMETER IDPUserName
        IDP Username
    .PARAMETER Password
        Password (for built-in users only)
    .PARAMETER FirstName
        First name
    .PARAMETER LastName
        Last name
    .PARAMETER FullName
        Full name
    .PARAMETER Email
        Email address
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
        PS C:\> Update-PortalUser -UserName joedoe -IDPUserName 'joedoe@esri.com' @commonParams
        Add the idpUsername property to enable the user for SAML authentication
    .EXAMPLE
        PS C:\> Update-PortalUser -Username joedoe -Password (Read-Host -AsSecureString) @commonParams
        Set a password for use joedoe. This also switches the user "provier" from enterprise to arcgis removing SAML authentication
    .EXAMPLE
        PS C:\> Update-PortalUser -UserName joedoe -IDPUserName 'joedoe123@esri.com' @commonParams
        PS C:\> Update-PortalUser -UserName joedoe -IDPUserName 'joedoe@esri.com' @commonParams
        Once the user's provider value has been set to "enterprise" and then reset to "arcgis," the only way
        to change it back to "enterprise" is to change the "idpUsername" value to something
        arbitrary and then change it again to the correct value. This resets the "provider" property
        to "enterprise."
    .NOTES
        Name:     Update-PortalUser
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-05-30
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/update-user/
        https://developers.arcgis.com/rest/users-groups-and-items/common-parameters/#user-parameters
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

        [Parameter(Mandatory = $false, HelpMessage = 'IDP Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $IDPUserName,

        [Parameter(Mandatory = $false, HelpMessage = 'Password (only requred for built-in users)')]
        [ValidateNotNullOrEmpty()]
        [System.Security.SecureString] $Password,

        [Parameter(Mandatory = $false, HelpMessage = 'First name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $FirstName,

        [Parameter(Mandatory = $false, HelpMessage = 'Last name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $LastName,

        [Parameter(Mandatory = $false, HelpMessage = 'Full name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $FullName,

        [Parameter(Mandatory = $false, HelpMessage = 'Email address')]
        [ValidateNotNull()]
        [System.String] $Email,

        <# [Parameter(Mandatory = $false, HelpMessage = '')]
        [ValidateSet('arcgis', 'enterprise')] # 'arcgis' is a built-in, forms user
        [System.String] $Provider = 'arcgis', #>

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

        # VALIDATE USER PROVIDER CHANGES
        if ($PSBoundParameters.ContainsKey('IDPUserName') -and $PSBoundParameters.ContainsKey('Password')) {
            # RETURN ERROR
            Write-Error -Message 'Update may not contain both "Password" and "IDPUserName"' -ErrorAction Stop
        }

        # VALIDATE USER NAME CHANGES
        if ($PSBoundParameters.ContainsKey('FirstName') -and -Not $PSBoundParameters.ContainsKey('LastName')) {
            # RETURN ERROR
            Write-Error -Message 'Update should contain both "FirstName" and "LastName"' -ErrorAction Stop
        }
        if (-Not $PSBoundParameters.ContainsKey('FirstName') -and $PSBoundParameters.ContainsKey('LastName')) {
            # RETURN ERROR
            Write-Error -Message 'Update should contain both "FirstName" and "LastName"' -ErrorAction Stop
        }
    }
    Process {
        # ADD NON-REQUIRED PARAMETERS
        if ($PSBoundParameters.ContainsKey('Password')) {
            # UNWIND SECURE STRING FOR PASSWORD
            $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
            $unsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
        }

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/community/users/{1}/update' -f $Context, $UserName
            Method = 'POST'
            Body    = @{
                clearEmptyFields = $true
                provider         = if ($PSBoundParameters.ContainsKey('IDPUserName')) { 'enterprise' } else { 'arcgis' }
                idpUsername      = if ($PSBoundParameters.ContainsKey('IDPUserName')) { $IDPUserName } else { '' }
                password         = if ($PSBoundParameters.ContainsKey('Password')) { $unsecurePassword } else { '' }
                f                = 'json'
                token            = $Token
            }
            Headers = @{
                referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority
            }
        }

        # CHECK FOR IDP CHANGE
        if (-Not $PSBoundParameters.ContainsKey('IDPUserName') -and -Not $PSBoundParameters.ContainsKey('Password')) {
            # REMOVE "provider" PARAMETER
            $restParams.Body['provider'] = ''
        }

        # UPDATE OTHER PROPERTIES
        switch ($PSBoundParameters.Keys) {
            'FirstName' { $restParams.Body['firstname'] = $FirstName }
            'LastName' { $restParams.Body['lastname'] = $LastName }
            'FullName' { $restParams.Body['fullname'] = $FullName }
            'Email' { $restParams.Body['email'] = $Email }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Set provider: [{0}]' -f $restParams.Body['provider'])

        # BE SURE TO DELETE OR COMMENT THIS BEFORE MERGING PR
        #Write-Verbose -Message ('Request parameters: {0}' -f ($restParams.Body | Out-String))

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($UserName, ('Update Portal user'))) {
            # INVOKE REQUEST
            Invoke-RestMethod @restParams
        }
    }
    Clean {
        # REMOVE SECRETS
        Remove-Variable -Name 'bstr', 'unsecurePassword' -Force -Confirm:$false -ErrorAction Ignore
    }
}
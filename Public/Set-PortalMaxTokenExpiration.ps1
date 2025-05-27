function Set-PortalMaxTokenExpiration {
    <#
    .SYNOPSIS
        Set the maximum validity in minutes of both OAuth and nonOAuth tokens issued for users of the organization.
    .DESCRIPTION
        Set the maximum validity in minutes of both OAuth and nonOAuth tokens issued for users of the organization.
    .PARAMETER Expiration
        The maximum validity in minutes of both OAuth and nonOAuth tokens issued for users of the organization.
    .PARAMETER PortalId
        Portal application ID
    .PARAMETER Context
        Target Portal context
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Set-PortalMaxTokenExpiration @cmnParams -Expiration 1440
        Set the maximum validity in minutes of both OAuth and nonOAuth tokens issued for users of the organization to 1440 minutes (24 hours).
    .NOTES
        Name:     Set-PortalMaxTokenExpiration
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-05-27
        - Version history is captured in repository commit history
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/update.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'The maximum validity in minutes of tokens issued for users.')]
        [ValidateNotNullOrEmpty()]
        [System.Int32] $Expiration,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal application ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF',

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
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # SET QUERY PARAMETERS
        $restParams = @{
            Uri     = '{0}/sharing/rest/portals/{1}/update' -f $Context, $PortalId
            Method  = 'POST'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
            Body    = @{
                f                         = 'json'
                token                     = $Token
                maxTokenExpirationMinutes = $Expiration
            }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE QUERY
        Invoke-RestMethod @restParams
    }
}
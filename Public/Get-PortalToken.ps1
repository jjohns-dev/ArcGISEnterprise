function Get-PortalToken {
    <#
    .DESCRIPTION
        Generate token for ArcGIS Portal
    .PARAMETER Context
        Portal URI including context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Credential
        PowerShell credential object containing username and password
    .PARAMETER Referer
        Referer
    .PARAMETER Expiration
        Token expiration time in minutes
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-PortalToken -Context https://mydomain.com/arcgis -Credential $creds
        Generate token for mydomain.com
    .NOTES
        Status: Stable
        https://developers.arcgis.com/rest/users-groups-and-items/generate-token.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal URI including context (e.g., https://arcgis.com/arcgis)')]
        [ValidateScript({ $_.OriginalString -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'PS Credential object containing username and password')]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential] $Credential,

        [Parameter(Mandatory = $false, HelpMessage = 'Referer')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Referer,

        [Parameter(Mandatory = $false, HelpMessage = 'Token expiration time in minutes')]
        [ValidateRange(1,900)]
        [System.Int32] $Expiration = 60,

        [Parameter(Mandatory = $false, HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        # SET REFERER IF NOT PROVIDED
        $Referer = if ($PSBoundParameters.ContainsKey('Referer')) { $Referer } else { '{0}://{1}' -f $Context.Scheme, $Context.Authority }

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/generateToken' -f $Context
            Method = 'POST'
            Body   = @{
                username   = $Credential.UserName
                password   = $Credential.GetNetworkCredential().password
                #client     = 'requestip'
                referer    = $Referer # 'http' IS REQUIRED FOR PYTHON API
                expiration = $Expiration #minutes
                f          = 'json'
            }
        }

        # ADD SKIP FOR TLS CERTIFICATE VERIFICATION
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Referer: {0}' -f $restParams['Body']['referer'])

        # TRY REQUEST
        try { $response = Invoke-RestMethod @restParams }
        catch { $response = $_.Exception.Response }

        # CHECK FOR ERRORS AND RETURN
        if ( -not $response.token ) {
            # CHECK FOR VALID JSON WITH ERROR DETAILS
            if ( $response.error.details ) {
                if ( $response.error.details.GetType().FullName -eq 'System.Object[]' ) { $details = $response.error.details -join "; " }
                else { $details = $response.error.details }

                $tokens = @($response.error.code, $response.error.message, $details)
                $msg = "Request failed with response:`n`tcode: {0}`n`tmessage: {1}`n`tdetails: {2}" -f $tokens
            }
            elseif ( $response.ReasonPhrase ) { $msg = $response.ReasonPhrase }
            else { $msg = "Request failed with unknown error. Username and/or password may be incorrect." }

            Write-Error -Message $msg -ErrorAction Stop
        }
        else {
            $response
        }
    }
}
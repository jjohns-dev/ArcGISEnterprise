function Set-ServerServicesDirectory {
    <#
    .SYNOPSIS
        Set ArcGIS Server services directory
    .DESCRIPTION
        Set ArcGIS Server services directory configuration data
    .PARAMETER CallbackFunctionsEnabled
        Callback functions enabled
    .PARAMETER ServicesDirectoryEnabled
        Services directory enabled
    .PARAMETER Origin
        Origin to be allowed
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
        PS C:\> Set-ServerServicesDirectory @cmnParams -CallbackFunctionsEnabled $false
        Set the Callback Functions enabled property to false.
    .NOTES
        Name:     Set-ServerServicesDirectory
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-04-15
        - Version history is captured in repository commit history
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/handlersrestservicesdirectoryedit/
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Callback functions enabled')]
        [System.Boolean] $CallbackFunctionsEnabled,

        [Parameter(Mandatory = $false, HelpMessage = 'Services directory enabled')]
        [System.Boolean] $ServicesDirectoryEnabled,

        [Parameter(Mandatory = $false, HelpMessage = 'Origin to be allowed')]
        [ValidatePattern('^(https?://.+[^/]|\*)$')]
        [System.String[]] $Origin,

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
        # GET SERVICES DIRECTORY DATA
        # DURING TESTING WE DISCOVERED THAT UPDATING THE SERVICES DIRECTORY HAS SEVERAL INCONSISTENCIES
        # WITH THE API DOCUMENTATION. ONE IS THAT ALL PROPERTIES MUST BE UPDATED TOGETHER AND THAT AN
        # INDIVIDUAL PROPERTY CANNOT BE UPDATED INDEPENDANTLY. ANOTHER IS THAT THE 'servicesDirEnabled'
        # PROPERTY IS STORED AS 'enabled' BUT MUST BE UPDATED AS 'servicesDirEnabled'.
        $config = Get-ServerServicesDirectory -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck

        # VALIDATE PREVIOUS CALL WAS SUCCESSFUL
        if (-NOT $config) { Write-Error -Message 'Unable to retrieve ArcGIS Server properties' -ErrorAction Stop }

        # CONVERT TO HASHTABLE
        $config = $config | ConvertTo-Json -Compress | ConvertFrom-Json -AsHashtable

        # RESET THE SERVICES DIRECTORY ENABLED PROPERTY
        if ($config.ContainsKey('enabled')) {
            # ADD THE CORRECT PROPERTY NAME
            $config['servicesDirEnabled'] = $config.enabled
            # REMOVE INCORRECT PROPERTY NAME
            $config.Remove('enabled')
        }

        # VALIDATE PARAMETERS
        if ($PSBoundParameters.ContainsKey('ServicesDirectoryEnabled')) {
            $config['servicesDirEnabled'] = $ServicesDirectoryEnabled.ToString().ToLower()
        }
        if ($PSBoundParameters.ContainsKey('CallbackFunctionsEnabled')) {
            $config['callbackFunctionsEnabled'] = $CallbackFunctionsEnabled.ToString().ToLower()
        }
        if ($PSBoundParameters.ContainsKey('Origin')) {
            $config['allowedOrigins'] = $Origin -join ','
        }

        # ADD TOKEN AND FORMAT FOR JSON
        $config['token'] = $Token; $config['f'] = 'json'

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri     = '{0}/admin/system/handlers/rest/servicesdirectory/edit' -f $Context
            Method  = 'POST'
            Body    = $config
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SET CHANGED PROPERTIES
        $changedProps = $config | ConvertTo-Json | ConvertFrom-Json -AsHashtable
        $changedProps.Remove('f'); $changedProps.Remove('token'); $changedProps = $changedProps | ConvertTo-Json -Compress

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($changedProps, 'Change Server services directory property')) {

            # INVOKE REQUEST
            Invoke-RestMethod @restParams
        }
    }
}
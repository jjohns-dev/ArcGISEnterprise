function Set-ServerSystemProperty {
    <#
    .SYNOPSIS
        Set the system properties of the ArcGIS Server.
    .DESCRIPTION
        This function sets the system properties of the server using the ArcGIS REST API.
    .PARAMETER WebContextURL
        Web context URL (e.g., https://example.com/arcgis)
    .PARAMETER FeatureServiceXSSFilter
        Feature service XSS filter (e.g., input, inputOutput)
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
        PS C:\> Set-ServerSystemProperty @cmnParams -FeatureServiceXSSFilter 'input'
        Set the Feature Service XSS filter to 'input'.
    .NOTES
        Name:     Set-ServerSystemProperty
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-04-15
        - Version history is captured in repository commit history
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/updateserverproperties/
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Web Context URL')]
        [ValidateNotNullOrEmpty()]
        [System.String] $WebContextURL,

        [Parameter(Mandatory = $false, HelpMessage = 'Feature service XSS filter')]
        [ValidateSet('input', 'inputOutput')]
        [System.String] $FeatureServiceXSSFilter,

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

        # GET EXISTING PROPERTIES
        $properties = Get-ServerSystemProperty -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck
    }
    Process {
        # VALIDATE REQUEST BY PARAMETER
        if ($PSBoundParameters.ContainsKey('WebContextURL')) {
            # SET PROPERTY
            $properties.WebContextURL = $WebContextURL
        }
        if ($PSBoundParameters.ContainsKey('FeatureServiceXSSFilter')) {
            # CHECK IF PROPERTY ALREADY EXISTS AND UPDATED OR ADD
            if ($properties.featureServiceXSSFilter) { $properties.featureServiceXSSFilter = $FeatureServiceXSSFilter }
            else { Add-Member -InputObject $properties -NotePropertyMembers @{ featureServiceXSSFilter = $FeatureServiceXSSFilter } }
        }

        # CONVERT PROPERTIES TO JSON
        $properties = $properties | ConvertTo-Json -Compress

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri     = '{0}/admin/system/properties/update' -f $Context
            Method  = 'POST'
            Body    = @{
                f          = 'json'
                token      = $Token
                properties = $properties
            }
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($properties, 'Set system property')) {

            # INVOKE REQUEST
            Invoke-RestMethod @restParams
        }
    }
}
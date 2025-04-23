function Set-PortalSystemProperty {
    <#
    .SYNOPSIS
        Sets the system properties for Portal for ArcGIS.
    .DESCRIPTION
        The update operation updates one or more system properties. All previously modified system
        properties must be included in the request. Only the properties that have been updated or
        added to the JSON object will be effected.
    .PARAMETER EnableRSS
        Enable/disable Enterprise to communicate with GeoRSS feeds
    .PARAMETER EnableKML
        Enable/disable Enterprise to communicate with the KML endpoint
    .PARAMETER EnablePrintService
        Enable/disable default print service in ArcGIS Enterprise Portal
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
        PS C:\> Set-PortalSystemProperty @cmnParams -EnablePrintService $false
        Set the Enable Print Service property to false.
    .NOTES
        Name:     Set-PortalSystemProperty
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-04-23
        - Version history is captured in repository commit history
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/portal/update-system-properties/
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Enable/disable Enterprise to communicate with GeoRSS feeds')]
        [ValidateNotNullOrEmpty()]
        [System.Boolean] $EnableRSS,

        [Parameter(Mandatory = $false, HelpMessage = 'Enable/disable Enterprise to communicate with the KML endpoint')]
        [ValidateNotNullOrEmpty()]
        [System.Boolean] $EnableKML,

        [Parameter(Mandatory = $false, HelpMessage = 'Enable/disable default print service in ArcGIS Enterprise Portal')]
        [ValidateNotNullOrEmpty()]
        [System.Boolean] $EnablePrintService,

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
        $properties = Get-PortalSystemProperty -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck

        # VALIDATE PROPERTIES VAR
        if ($properties) {
            # CONVERT PROPERTIES TO HASHTABLE
            $properties = $properties | ConvertTo-Json | ConvertFrom-Json -AsHashtable
        }
        else {
            Write-Error -Message 'Unable to get Portal system properties.' -ErrorAction Stop
        }
    }
    Process {
        # VALIDATE REQUEST BY PARAMETER
        if ($PSBoundParameters.ContainsKey('EnableRSS')) {
            $properties['enableRssService'] = $EnableRSS.toString().ToLower()
        }
        if ($PSBoundParameters.ContainsKey('EnableKML')) {
            $properties['enableKmlService'] = $EnableKML.toString().ToLower()
        }
        if ($PSBoundParameters.ContainsKey('EnablePrintService')) {
            $properties['enablePrintService'] = $EnablePrintService.toString().ToLower()
        }

        # CONVERT PROPERTIES TO JSON
        $properties = $properties | ConvertTo-Json -Compress

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri     = '{0}/portaladmin/system/properties/update' -f $Context
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
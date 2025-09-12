function Unregister-ServerDataItem {
    <#
    .SYNOPSIS
        Unregister a data item
    .DESCRIPTION
        Unregisters a data item that has been previously registered with the server's data store.
    .PARAMETER Context
        Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Enterprise token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .PARAMETER ItemPath
        The item path for the data item
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Unregister-ServerDataItem -ItemPath /nosqlDatabases/AGSDataStore_cache_cs_jbpc7nk
        unregisters the DataSTore cache store data item registered with the Server's data store.
    .NOTES
        Name:     Unregister-ServerDataItem
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-09-11
        - Version history is captured in repository commit history
        Comments:
        https://developers.arcgis.com/rest/enterprise-administration/server/unregisterdataitem/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'The item path for the data item')]
        [ValidatePattern('^[\w/]+$')]
        [System.String] $ItemPath,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Server context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Enterprise token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(Mandatory = $false, HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri     = '{0}/admin/data/unregisterItem' -f $Context
            Method  = 'POST'
            Body    = @{
                f        = 'json'
                token    = $Token
                itempath = $ItemPath
                force    = $true
            }
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
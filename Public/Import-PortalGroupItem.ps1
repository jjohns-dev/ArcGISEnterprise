function Import-PortalGroupItem {
    <#
    .SYNOPSIS
        THIS FUNCTION DOES NOT CURRENTLY WORK
    .DESCRIPTION
        Imports supported content items from an export package (generated using the export operation) into the selected group.
    .PARAMETER GroupID
        Portal Group ID
    .PARAMETER ItemId
        Portal item ID
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
        PS C:\> Import-PortalGroupItem -GroupId 'ad46a0e1a74742aeb4314250c3ea90e4' -ItemId '2b28061dc08d4834be808500ac2bd967' @commonParams
        Starts and asynchronous job to import of all content from item with ID '2b28061dc08d4834be808500ac2bd967' to group ID 'ad46a0e1a74742aeb4314250c3ea90e4'
    .NOTES
        Name:     Import-PortalGroupItem
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2025-01-14
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/import-group/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal Group ID')]
        [ValidatePattern('^[A-Za-z0-9]{32}$')]
        [System.String] $GroupID,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal item ID')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $ItemId,

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
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri     = '{0}/sharing/rest/community/groups/{1}/import' -f $Context, $GroupID
            Method  = 'POST'
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
            Body    = @{
                f                          = 'json'
                token                      = $Token
                async                      = $true
                itemId                     = $ItemId
                #itemIdList                 = '2b28061dc08d4834be808500ac2bd967'
                overwriteExistingItems     = $false
                keepPackageItemAfterImport = $true
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        Invoke-RestMethod @restParams
    }
}
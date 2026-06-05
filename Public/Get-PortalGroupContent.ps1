function Get-PortalGroupContent {
    <#
    .SYNOPSIS
        Get group content for Portal for ArcGIS group
    .DESCRIPTION
        A group's content resource provides access to the group's shared items. Group items are stored by reference
        and are not physically stored in a group. Rather, they are stored as links to the original item in the Item
        resource. This resource is only available to the group owner and users.
    .PARAMETER GroupID
        Group ID
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
        PS C:\> Get-PortalGroupContent @cmnParams -GroupID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6'
        Gets the content for the group with ID 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6' from Portal for ArcGIS
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/group-content/
        https://developers.arcgis.com/rest/users-groups-and-items/common-parameters/#paging-parameters
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Group ID')]
        [ValidatePattern('^[A-Za-z0-9]{32}$')]
        [System.String] $GroupID,

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

        # CREATE USER ARRAY
        $itemList = [System.Collections.Generic.List[System.Object]]::new()
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/groups/{1}' -f $Context, $GroupID
            Method = 'GET'
            Body   = @{
                f     = 'json'
                token = $Token
                start = 1
                num   = 100
            }
            Headers = @{ referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        $rest = Invoke-RestMethod @restParams

        # CHECK FOR ERRORS
        if ($rest.error) {
            # RETURN ANY ERRORS
            Write-Error -Message ($rest | ConvertTo-Json -Compress -Depth 6) -ErrorAction Stop
        }
        else {
            # ADD ITEMS TO ARRAY
            foreach ($i in $rest.items) { $itemList.Add($i) | Out-Null }

            # SET REMAINING ITEMS
            $remainingItems = $rest.total - 100
            Write-Verbose -Message ('Total Items: {0}' -f $rest.total)

            # GET REMAINING ITEMS
            if ($remainingItems -GT 0) {

                do {
                    # OUTPUT VERBOSE
                    Write-Verbose -Message ('Remaining items: {0}' -f $remainingItems)

                    # RESET START
                    $restParams.Body['start'] = $rest.nextStart

                    # SEND REQUEST
                    $rest = Invoke-RestMethod @restParams

                    # ADD USER TO ARRAY
                    foreach ($i in $rest.items) { $itemList.Add($i) | Out-Null }

                    # DECREMENT REMAINING ITEMS
                    $remainingItems -= 100
                }
                while ($remainingItems -GT 0)
            }

            # RETURN ITEMS
            $itemList
        }
    }
}
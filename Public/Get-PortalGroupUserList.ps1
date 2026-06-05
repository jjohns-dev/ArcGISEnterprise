function Get-PortalGroupUserList {
    <#
    .SYNOPSIS
        Get users from group in Portal for ArcGIS
    .DESCRIPTION
        Get users from group in Portal for ArcGIS
    .PARAMETER GroupID
        Group ID
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-PortalGroupUserList @commonParams -GroupID 'e24d7d38ce9646138fd4e5d6d17e5539'
        Explanation of what the example does
    .NOTES
        Name:     Get-PortalGroupUserList
        Author:   Justin Johns
        Version:  0.1.3 | Last Edit: 2025-07-22
        - Version history is capture in repository commit history
        Comments: <Comment(s)>
        General notes
        https://developers.arcgis.com/rest/users-groups-and-items/group-users-list.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Group ID')]
        [ValidatePattern('^[A-Za-z0-9]{32}$')]
        [System.String] $GroupID,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
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
        $userList = [System.Collections.Generic.List[System.Object]]::new()
    }
    Process {
        # SET PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/community/groups/{1}/userList' -f $Context, $GroupID
            Method = 'GET'
            Body   = @{ f = 'json'; token = $Token; num = 100 } # DEFAULT 25
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        $rest = Invoke-RestMethod @restParams

        # CHECK FOR ERRORS
        if ($rest.error) {
            # RETURN ANY ERRORS
            $rest
        }
        else {
            # ADD USER TO ARRAY
            foreach ($u in $rest.users) { $userList.Add($u) | Out-Null }

            # SET REMAINING USERS
            $remainingUsers = $rest.total - 100
            Write-Verbose -Message ('Total users: {0}' -f $rest.total)

            # GET REMAINING USERS
            if ($remainingUsers -GT 0) {

                do {

                    Write-Verbose -Message ('Remaining users: {0}' -f $remainingUsers)

                    # RESET START
                    $restParams.Body['start'] = $rest.nextStart

                    # SEND REQUEST
                    $rest = Invoke-RestMethod @restParams

                    # ADD USER TO ARRAY
                    foreach ($u in $rest.users) { $userList.Add($u) | Out-Null }

                    # DECREMENT REMAINING USERS
                    $remainingUsers -= 100
                }
                while ($remainingUsers -GT 0)
            }

            # RETURN USERS
            $userList
        }
    }
}
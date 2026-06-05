function Get-PortalUserGroupList {
    <#
    .SYNOPSIS
        Get Portal for ArcGIS user group
    .DESCRIPTION
        Get groups owned by specified user in Portal for ArcGIS
    .PARAMETER UserName
        Username
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
        PS C:\> Get-PortalUserGroupList -UserName jsmith -Context 'https://arcgis.com/arcgis' -Token $token
        Get groups owned by user 'jsmith'
    .NOTES
        Name:     Get-PortalUserGroupList
        Author:   Justin Johns
        Version:  0.1.1 | Last Edit: 2025-07-22
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/group-search.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    [Alias('Get-PortalUserGroup')]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

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

        # VALIDATE USER NAME
        if (-Not $PSBoundParameters.ContainsKey('UserName')) {
            try {
                # GET USER PORTAL INFO
                Write-Verbose -Message 'Getting user settings...'
                $userSettings = Get-PortalSettings -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck

                # SET USER NAME
                $UserName = $userSettings.user.username
            }
            catch {
                # PASS ERROR
                Write-Error -Message ('Unable to get user info with error: {0}' -f $PSItem.Exception.Message) -ErrorAction Stop
            }
        }

        # CREATE USER ARRAY
        $groupList = [System.Collections.Generic.List[System.Object]]::new()
    }
    Process {
        # SET PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/community/groups' -f $Context
            Method = 'GET'
            Body   = @{
                f     = 'json'
                token = $Token
                num   = 100
                # THE SYNTAX 'q = "jsmith"' WILL FIND THE USER ACROSS MULTIPLE
                # FIELDS RATHER THAN JUST THE OWNER FIELD. USE Find-PortalItem
                # TO FIND A USERNAME AS A SEARCH TERM FOR MULTIPLE FIELDS
                q     = 'owner:"{0}"' -f $UserName
            }
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
            foreach ($g in $rest.results) { $groupList.Add($g) | Out-Null }

            # SET REMAINING USERS
            $remainingGroups = $rest.total - 100
            Write-Verbose -Message ('Total groups: {0}' -f $rest.total)

            # GET REMAINING USERS
            if ($remainingGroups -GT 0) {

                do {

                    Write-Verbose -Message ('Remaining groups: {0}' -f $remainingGroups)

                    # RESET START
                    $restParams.Body['start'] = $rest.nextStart

                    # SEND REQUEST
                    $rest = Invoke-RestMethod @restParams

                    # ADD USER TO ARRAY
                    foreach ($g in $rest.results) { $groupList.Add($g) | Out-Null }

                    # DECREMENT REMAINING USERS
                    $remainingGroups -= 100
                }
                while ($remainingGroups -GT 0)
            }

            # RETURN USERS
            $groupList
        }
    }
}
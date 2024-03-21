function Get-PortalUserItemList {
    <#
    .SYNOPSIS
        Get Portal for ArcGIS user item list
    .DESCRIPTION
        Get all items owned by user in Portal for ArcGIS
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
        PS C:\> Get-PortalUserItemList @commonParams -UserName 'jsmith'
        Get all Portal items belonging to 'jsmith'
    .NOTES
        Name:     Get-PortalUserItemList
        Author:   Justin Johns
        Version:  0.1.2 | Last Edit: 2024-03-21
        - 0.1.2 - (2024-03-21) Made UserName parameter optional and added parameter for item type
        - 0.1.1 - (2023-13-20) Added automatic retrieval of paged results
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/search.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal item type')]
        [ValidateSet('Map Service', 'Feature Service', 'Data Store', 'Web Map')] # this list will need updating
        [System.String[]] $Type,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

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
                throw ('Unable to get user info with error: {0}' -f $_.Exception.Message)
            }
        }

        # CREATE USER ARRAY
        $itemList = [System.Collections.Generic.List[System.Object]]::new()
    }
    Process {
        # SET PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/search' -f $Context
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
                q     = 'owner:{0}' -f $UserName
                num   = 100
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
            foreach ($i in $rest.results) { $itemList.Add($i) | Out-Null }

            # SET REMAINING ITEMS
            $remainingItems = $rest.total - 100
            Write-Verbose -Message ('Total Items: {0}' -f $rest.total)

            # GET REMAINING USERS
            if ($remainingItems -GT 0) {

                do {

                    Write-Verbose -Message ('Remaining items: {0}' -f $remainingItems)

                    # RESET START
                    $restParams.Body['start'] = $rest.nextStart

                    # SEND REQUEST
                    $rest = Invoke-RestMethod @restParams

                    # ADD USER TO ARRAY
                    foreach ($i in $rest.results) { $itemList.Add($i) | Out-Null }

                    # DECREMENT REMAINING USERS
                    $remainingItems -= 100
                }
                while ($remainingItems -GT 0)
            }

            # RETURN USERS
            if ($PSBoundParameters.ContainsKey('Type')) { $itemList | Where-Object type -IN $Type }
            else { $itemList }
        }
    }
}
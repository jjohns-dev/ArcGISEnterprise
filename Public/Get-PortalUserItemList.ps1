function Get-PortalUserItemList {
    <#
    .SYNOPSIS
        Get Portal for ArcGIS user item list
    .DESCRIPTION
        Get all items owned by user in Portal for ArcGIS
    .PARAMETER UserName
        Username
    .PARAMETER Type
        Portal item type
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
        Version:  0.1.4 | Last Edit: 2025-07-22
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/search.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal item type')]
        #[ValidateNotNullOrEmpty()]
        # THIS LIST WILL NEED UPDATING
        [ValidateSet('Map Service', 'Feature Service', 'Data Store', 'Web Map', 'CSV', 'CSV Collection')]
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
            Method = 'GET'
            Body   = @{
                f      = 'json'
                token  = $Token
                filter = 'owner:"{0}"' -f $UserName
                num    = 100
            }
        }

        # CHECK FOR TYPE
        if ($PSBoundParameters.ContainsKey('Type')) {
            # CHECK FOR MULTIPLE VALUES
            if ($Type.Count -GT 1) {
                # ADD APPROPRIATE SYNTAX
                $typeString = foreach ($t in $Type) { 'type:"{0}"' -f $t }

                # ADD GROUPING
                $restParams.Body.filter += ' and ({0})' -f ($typeString -join ' OR ')
            }
            else {
                # ADD SINGLE TYPE
                $restParams.Body.filter += ' and type:"{0}"' -f $Type
            }
        }

        # OUTPUT VERBOSE
        Write-Verbose -Message ('Query filter: [{0}]' -f $restParams.Body.filter)

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
            $itemList
        }
    }
}
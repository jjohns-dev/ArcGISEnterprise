function Find-PortalItem {
    <#
    .SYNOPSIS
        Search Portal for ArcGIS content
    .DESCRIPTION
        Search Portal for ArcGIS content by user, item ID, etc.
    .PARAMETER Id
        Id
    .PARAMETER Owner
        Owner
    .PARAMETER Tag
        Tag
    .PARAMETER Type
        Type
    .PARAMETER Title
        Title
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
        PS C:\> Find-PortalItem @commonParams -Owner 'jsmith'
        Get all Portal items belonging to 'jsmith'
    .NOTES
        Name:     Find-PortalItem
        Author:   Justin Johns
        Version:  0.1.2 | Last Edit: 2024-03-29
        - 0.1.2 - (2024-03-29) Renamed function and switch to filter rather than q (query)
        - 0.1.1 - (2023-03-21) Removed raw query
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
        https://developers.arcgis.com/rest/users-groups-and-items/search.htm
        https://developers.arcgis.com/rest/users-groups-and-items/search-reference.htm
        This function does not yet support multiple search values for a given criterion
        (e.g., can only search for a single "tag" not two tags)
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Id')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Id,

        [Parameter(Mandatory = $false, HelpMessage = 'Owner')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Owner,

        [Parameter(Mandatory = $false, HelpMessage = 'Tag')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Tag,

        [Parameter(Mandatory = $false, HelpMessage = 'Type')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Type,

        [Parameter(Mandatory = $false, HelpMessage = 'Title')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Title,

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

        # CREATE USER ARRAY
        $itemList = [System.Collections.Generic.List[System.Object]]::new()
    }
    Process {
        # SET PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/search' -f $Context
            Method = 'POST'
            Body   = @{ f = 'json'; token = $Token }
        }

        # CHECK FOR NO INPUT
        if (-NOT $Id -AND -NOT $Owner -AND -NOT $Tag -AND -NOT $Type -AND -NOT $Title) {
            Throw 'No seach parameter found. Please add search parameter and try again.'
        }

        # ADD SEARCH PARAMS
        switch ($PSBoundParameters.Keys) {
            'Id' {
                $restParams.Body['filter'] = 'id:"{0}"' -f $Id
                $searchParams = $true
            }
            'Owner' {
                if ($searchParams) { $restParams.Body['filter'] += ' AND owner:"{0}"' -f $Owner }
                else { $restParams.Body['filter'] = 'owner:"{0}"' -f $Owner }
                $searchParams = $true
            }
            'Tag' {
                if ($searchParams) { $restParams.Body['filter'] += ' AND tags:"{0}"' -f $Tag }
                else { $restParams.Body['filter'] = 'tags:"{0}"' -f $Tag }
                $searchParams = $true
            }
            'Type' {
                if ($searchParams) { $restParams.Body['filter'] += ' AND type:"{0}"' -f $Type }
                else { $restParams.Body['filter'] = 'type:"{0}"' -f $Type }
                $searchParams = $true
            }
            'Title' {
                if ($searchParams) { $restParams.Body['filter'] += ' AND title:"{0}"' -f $Title }
                else { $restParams.Body['filter'] = 'title:"{0}"' -f $Title }
                $searchParams = $true
            }
        }

        # SHOW QUERY STRING
        Write-Verbose -Message ('Query string: [{0}]' -f $restParams.Body['filter'])
        #Write-Verbose -Message ($restParams.Body | Out-String)

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
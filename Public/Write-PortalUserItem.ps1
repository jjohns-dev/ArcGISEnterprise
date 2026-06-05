function Write-PortalUserItem {
    <#
    .SYNOPSIS
        Upload file item to Portal for ArcGIS
    .DESCRIPTION
        Upload file item to Portal for ArcGIS
    .PARAMETER Username
        Username
    .PARAMETER FilePath
        File (item) path
    .PARAMETER Title
        Item title
    .PARAMETER Description
        Item description
    .PARAMETER Snippet
        Item snippet (summary)
    .PARAMETER Tag
        Item tag
    .PARAMETER TypeKeyword
        Item type keyword
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
        PS C:\> Write-PortalUserItem -FilePath C:\Data.xlsx @commonParams
        Uploads Data.xlsx as a Portal item for the current user
    .NOTES
        Name:     Write-PortalUserItem
        Author:   Justin Johns
        Version:  0.1.2 | Last Edit: 2025-01-14
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        https://developers.arcgis.com/rest/users-groups-and-items/add-item.htm
        https://developers.arcgis.com/rest/users-groups-and-items/items-and-item-types.htm
        https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

        [Parameter(Mandatory = $true, HelpMessage = 'File path')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [System.String] $FilePath,

        [Parameter(Mandatory = $false, HelpMessage = 'Item title')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Title,

        [Parameter(Mandatory = $false, HelpMessage = 'Item description')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Description,

        [Parameter(Mandatory = $false, HelpMessage = 'Item snippet (summary)')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Snippet,

        [Parameter(Mandatory = $false, HelpMessage = 'Item tag(s)')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $Tag,

        [Parameter(Mandatory = $false, HelpMessage = 'Type keyword(s)')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $TypeKeyword,

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

        # GET [System.IO.FileInfo] OBJECT
        $file = Get-Item -Path $FilePath

        # CREATE LOOKUP TABLE
        # https://developers.arcgis.com/rest/users-groups-and-items/items-and-item-types.htm
        $fileTypeHash = @{
            '.xlsx' = 'Microsoft Excel'
            '.csv'  = 'CSV'
            '.docx' = 'Microsoft Word'
            '.pdf'  = 'PDF'
            '.zip'  = 'File Geodatabase' # ZIP CAN BE MULTIPLE TYPES
            '.pptx' = 'Microsoft Powerpoint'
            '.epk'  = 'Export Package'
        }

        # VALIDATE FILE TYPE
        if (-Not $fileTypeHash.ContainsKey($file.Extension)) {
            # TERMINATE WITH ERROR
            Write-Error ('File type "{0}" is not supported.' -f $file.Extension) -ErrorAction Stop
        }
    }
    Process {
        # SET PARAMETERS FOR ITEM UPLOAD
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/users/{1}/addItem' -f $Context, $UserName
            Method = 'POST'
            Form   = @{
                f            = 'json'
                token        = $Token
                #multipart = $true
                title        = if ($PSBoundParameters.ContainsKey('Title')) { $Title } else { Split-Path -Path $FilePath -LeafBase }
                filename     = Split-Path -Path $FilePath -Leaf
                type         = $fileTypeHash[($file.Extension)]
                file         = $file
                description  = $Description
                typeKeywords = $TypeKeyword -join ', '
                tags         = $Tag -join ', '
                snippet      = $Snippet
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE UPLOAD
        Invoke-RestMethod @restParams
    }
}
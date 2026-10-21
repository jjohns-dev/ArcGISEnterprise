function Update-PortalItem {
    <#
    .SYNOPSIS
        Update Portal item
    .DESCRIPTION
        Allows users to update an item's information and file, URL, or text, depending on type.
    .PARAMETER UserName
        Owner of Portal Item
    .PARAMETER ItemId
        Id of Portal item
    .PARAMETER Title
        Item Title
    .PARAMETER Description
        Item Description
    .PARAMETER URL
        Item URL
    .PARAMETER PrivateURL
        Item Private URL
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
        PS C:\> Update-PortalItem -ItemId 'fdc51cd9e3ac4f4aa8444949caf5e816' -URL 'https://arcgis.com/arcgis/rest/services/Data_Owner_Connection_Layers/Util_CommSite_SpeclUse/MapServer' @cmnParams
        Updates the URL property of item with ID 'fdc51cd9e3ac4f4aa8444949caf5e816'
    .NOTES
        Status: Stable
        Comments:
        https://developers.arcgis.com/rest/users-groups-and-items/update-item/
        https://developers.arcgis.com/javascript/latest/api-reference/esri-layers-Layer.html
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Owner of Portal Item')]
        [ValidateNotNullOrEmpty()]
        [System.String] $UserName,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal item ID')]
        [ValidatePattern('[a-f0-9]{32}')]
        [System.String] $ItemId,

        [Parameter(Mandatory = $false, HelpMessage = 'Item Title')]
        [ValidatePattern('^[\w]{1,90}$')]
        [System.Uri] $Title,

        [Parameter(Mandatory = $false, HelpMessage = 'Item Description')]
        [ValidateNotNullOrEmpty()]
        [System.Uri] $Description,

        [Parameter(Mandatory = $false, HelpMessage = 'Item URL')]
        [ValidateNotNullOrEmpty()]
        [System.Uri] $URL,

        [Parameter(Mandatory = $false, HelpMessage = 'Item Private URL')]
        [ValidateNotNullOrEmpty()]
        [System.Uri] $PrivateURL,

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

        # VALIDATE USER NAME
        if (-Not $PSBoundParameters.ContainsKey('UserName')) {
            $UserName = Resolve-PortalUserName -Context $Context -Token $Token -SkipCertificateCheck:$SkipCertificateCheck
        }
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/content/users/{1}/items/{2}/update' -f $Context, $UserName, $ItemId
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
            }
            Headers = @{
                referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority
            }
        }

        # ADD OPTIONAL PARAMETERS FOR UPDATE
        switch ($PSBoundParameters.Keys) {
            'URL' { $restParams.Body['url'] = $URL }
            'Title' { $restParams.Body['title'] = $Title }
            'Description' { $restParams.Body['description'] = $Description }
            'PrivateURL' { $restParams.Body['privateUrl'] = $PrivateURL }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($ItemId, ('Update Portal item for user [{0}]' -f $UserName))) {
            # OUTPUT VERBOSE
            Write-Verbose -Message 'Invoking REST API endpoint "Update Item"'

            # INVOKE TRUNCATE PROCESS
            Invoke-RestMethod @restParams
        }
    }
}
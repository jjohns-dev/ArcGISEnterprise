function Set-ServerPSAPassword {
    <#
    .SYNOPSIS
        Set ArcGIS Server PSA Account
    .DESCRIPTION
        Set ArcGIS Server PSA Account
    .PARAMETER Context
        ArcGIS Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Credential
        PSCredential object containing current username and password
    .PARAMETER NewPassword
        PSCredential object containing new password
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Set-ServerPSAPassword -Context https://arcgisonline.com/arcgis -Credential $creds -NewPassword $new
        Set the Portal user specified by the "username" property of the $creds credential object to the password in the $new credential object
    .NOTES
        Name:     Set-ServerPSAPassword
        Author:   Phillip Glodowski, Justin Johns
        Version:  0.2.1 | Last Edit: 2023-12-04
        - 0.2.1 - Fixed error handling
        - 0.2.0 - Renamed cmdlet to Set-ServerPSAPassword
        - 0.1.0 - Initial version (Update-ServerPSA)
        Comments: <Comment(s)>
        General notes
        https://developers.arcgis.com/rest/enterprise-administration/server/psa.htm
        https://developers.arcgis.com/rest/enterprise-administration/server/updatepsa.htm
        https://developers.arcgis.com/rest/users-groups-and-items/update-user.htm
    #>
    [CmdletBinding()]
    [Alias('Update-ServerPSA')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Server base URI (a.k.a., context)')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'PSCredential object containing current username and password')]
        [System.Management.Automation.PSCredential] $Credential,

        [Parameter(Mandatory, HelpMessage = 'PSCredential object containing new password')]
        [System.Management.Automation.PSCredential] $NewPassword
    )
    Process {
        # GET TOKEN
        $token = Get-ServerToken -Context $Context -Credential $Credential -Client 'referer' -Referer 'referer'

        # CHECK USER STATUS
        $status = Get-ServerPSA -Context $Context -Token $token.token

        # VALIDATE USER EXISTENCE USING DISABLED PROPERTY
        # THIS IS THE ONLY PROPERTY RETURNED BY "Get-ServerPSA"
        if ($status.disabled -eq $false) {
            # SET REST PARAMETERS
            $restParams = @{
                Uri     = '{0}/admin/security/psa/update' -f $Context
                Method  = 'POST'
                Headers = @{ Referer = 'referer-value' }
                Body    = @{
                    f        = 'json'
                    token    = $token.token
                    username = $Credential.GetNetworkCredential().UserName
                    password = $NewPassword.GetNetworkCredential().Password
                }
            }

            # CHANGE PASSWORD
            Invoke-RestMethod @restParams
        }
        else {
            Write-Warning -Message 'ArcGIS Server PSA is disabled.'
        }
    }
}
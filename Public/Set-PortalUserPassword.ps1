function Set-PortalUserPassword {
    <#
    .SYNOPSIS
        Set password for Portal user
    .DESCRIPTION
        Set password for Portal user
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Credential
        PSCredential object containing current username and password
    .PARAMETER NewPassword
        PSCredential object containing new password
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Set-PortalUserPassword -Context https://arcgisonline.com/arcgis -Credential $creds -NewPassword $new
        Set the user ArcGIS Server specified by the "username" property of the $creds credential object to the password in the $new credential object
    .NOTES
        Name:     Set-PortalUserPassword
        Author:   Justin Johns
        Version:  0.2.1 | Last Edit: 2023-12-04
        - 0.2.1 - Fixed error handling
        - 0.2.0 - Renamed cmdlet to Set-PortalUserPassword
        - 0.1.0 - Initial version (Update-PortalPSA)
        General notes:
        https://developers.arcgis.com/rest/users-groups-and-items/update-user.htm
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    [Alias('Update-PortalPSA')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Portal base URI (a.k.a., context)')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'PSCredential object containing current username and password')]
        [System.Management.Automation.PSCredential] $Credential,

        [Parameter(Mandatory, HelpMessage = 'PSCredential object containing new password')]
        [System.Management.Automation.PSCredential] $NewPassword
    )
    Process {
        # GET TOKEN
        $token = Get-PortalToken -Context $Context -Credential $Credential

        # GET USERNAME FROM CREDENTIAL
        $username = $Credential.GetNetworkCredential().UserName

        # GET USER FROM PROVIDED CREDENTIAL
        $status = Get-PortalUser -Context $Context -Username $username -Token $token.token

        # VALIDATE USER EXISTENCE USING ID PROPERTY
        if ($status.id) {
            # SET REQUEST PARAMETERS
            $restParams = @{
                Uri    = '{0}/sharing/rest/community/users/{1}/update' -f $Context, $username
                Method = 'POST'
                Body   = @{
                    f        = 'json'
                    token    = $token.token
                    password = $NewPassword.GetNetworkCredential().Password
                }
            }

            # SEND REQUEST
            Invoke-RestMethod @restParams
        }
        else {
            Write-Error -Message ('User "{0}" not found in Portal "{1}"' -f $username, $Context) -ErrorAction Stop
        }
    }
}
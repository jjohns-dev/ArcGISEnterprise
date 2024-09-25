function Get-ServerServiceLayerAttachment {
    <#
    .SYNOPSIS
        Get ArcGIS service layer attachment(s)
    .DESCRIPTION
        The result of this operation are attachments grouped by the source feature object Ids and global ids (if exist)
    .PARAMETER GlobalId
        Global ID
    .PARAMETER LayerId
        Service Layer ID
    .PARAMETER ServiceName
        Name of service
    .PARAMETER FolderName
        Folder name in ArcGIS Server
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
        PS C:\> Get-ServerServiceLayerAttachment @cmnParams -GlobalId '96B099D7-C4FD-4B73-99E6-C7D6552F4E22' -LayerId 0 -ServiceName 'dashboard'
        Returns the attachment(s) for the feature with the global ID '96B099D7-C4FD-4B73-99E6-C7D6552F4E22' in the 'dashboard' service
    .NOTES
        Name:     Get-ServerServiceLayerAttachment
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-09-25
        - Version history is capture in repository commit history
        Comments:
        https://developers.arcgis.com/rest/services-reference/enterprise/query-attachments-feature-service-layer/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Global ID')]
        [ValidatePattern('^[0-9a-fA-F]{8}(-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}$')]
        [System.String[]] $GlobalId,

        [Parameter(Mandatory = $true, HelpMessage = 'Service Layer ID')]
        [ValidateNotNullOrEmpty()]
        [Alias('Layer')]
        [System.Int32] $LayerId,

        [Parameter(Mandatory = $true, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $false, HelpMessage = 'Folder name')]
        [ValidateNotNullOrEmpty()]
        [Alias('Folder')]
        [System.String] $FolderName,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Server context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(Mandatory = $false, HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri     = if ($PSBoundParameters.ContainsKey('FolderName')) {
                '{0}/rest/services/{1}/{2}/FeatureServer/{3}/queryAttachments' -f $Context, $FolderName, $ServiceName, $LayerId
            }
            else {
                '{0}/rest/services/{1}/FeatureServer/{2}/queryAttachments' -f $Context, $ServiceName, $LayerId
            }
            Method  = 'POST'
            Body    = @{
                f                    = 'json'
                token                = $Token
                objectIds            = '' #2353852
                globalIds            = $GlobalId -join ',' # '' # 96B099D7-C4FD-4B73-99E6-C7D6552F4E22
                definitionExpression = ''
                attachmentTypes      = ''
                resultOffset         = ''
                resultRecordCount    = ''
            }
            Headers = @{
                referer = '{0}://{1}' -f $Context.Scheme, $Context.Authority
            }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE REQUEST
        $attachments = Invoke-RestMethod @restParams

        # VALIDATE RESPONSE
        if ($attachments.error) {
            Write-Error -Message $attachments.error.message -ErrorAction Stop
        }
        else {
            # CHECK FOR SCENARIO WHERE LAYER IS ATTACHMENT
            # THIS IS DUE TO A POOR DESIGN CHOICE TO HAVE MULTIPLE PROPERTIES WITH THE SAME NAME BUT DIFFERENT CASING
            # THE PROPERTIES ARE 'globalId' AND 'globalid'
            if ($attachments.getType().FullName -EQ 'System.String') {
                # CREATE CUSTOM HASHTABLE
                $attachments = $attachments | ConvertFrom-Json -AsHashtable

                # REMOVE DUPLICATE PROPERTY WITH DIFFERENT NAME CASING
                $attachments.Remove('globalid')

                # CONVERT TO CUSTOM OBJECT
                [PSCustomObject] $attachments
            }
        }
    }
}
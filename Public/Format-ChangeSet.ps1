function Format-ChangeSet {
    <#
    .SYNOPSIS
        Format change set for reporting purposes
    .DESCRIPTION
        Re-format payload response from "extracChanges" API call to report-friendly object
    .PARAMETER ServiceName
        ArcGIS Server service name
    .PARAMETER ChangeSet
        Response from "extractChanges" API call
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Format-ChangeSet
        Explanation of what the example does
    .NOTES
        Name:     Format-ChangeSet
        Author:   Justin Johns
        Version:  0.1.1 | Last Edit: 2024-10-30
        Comments: <Comment(s)>
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'ArcGIS Server service name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $true, Position = 1, HelpMessage = 'Change payload')]
        [ValidateScript({ $_.responseType -EQ 'esriDataChangesResponseTypeEdits' })]
        [System.Object] $ChangeSet
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)

        # CREATE REPORT OBJECT ARRAYS
        $report = @{
            features    = @()
            attachments = @()
            deleted     = @()
        }

        # SET DESIRED FEATURE PROPERTIES
        $featProps = @(
            'serviceName'
            'editId'
            'changeType'
            'last_edited_user'
            'created_user'
            'globalid'
            'last_edited_date'
            'created_date'
            'objectid'
        )
    }
    Process {
        # PROCESS EDITS
        foreach ($edit in $ChangeSet.edits) {
            # PROCESS FEATURE EDITS
            foreach ($feature in $edit.features) {
                # PROCESS FEATURE UPDATES
                foreach ($update in $feature.updates) {
                    # EVALUATE EACH ATTRIBUTE
                    foreach ($attributesObject in $update.attributes) {
                        # ADD GEOMETRY TO ATTRIBUTE
                        Add-Member -InputObject $attributesObject -NotePropertyMembers @{
                            serviceName = $ServiceName
                            editId      = $edit.id
                            changeType  = 'update'
                            #x           = if ($update.geometry.x) { $update.geometry.x } else { $null }
                            #y           = if ($update.geometry.y) { $update.geometry.y } else { $null }
                        }

                        # CONVERT DATE PROPERTIES
                        $attributesObject.last_edited_date = (ConvertFrom-Epoch -Milliseconds $attributesObject.last_edited_date).ToString()
                        $attributesObject.created_date = (ConvertFrom-Epoch -Milliseconds $attributesObject.created_date).ToString()

                        # ADD ATTRIBUTE TO ARRAY
                        $report.features += $attributesObject | Select-Object -Property $featProps
                    }
                }

                # PROCESS FEATURE ADDITIONS
                foreach ($add in $feature.adds) {
                    # EVALUATE EACH ATTRIBUTE
                    foreach ($attributesObject in $add.attributes) {
                        # ADD GEOMETRY TO ATTRIBUTE
                        Add-Member -InputObject $attributesObject -NotePropertyMembers @{
                            serviceName = $ServiceName
                            editId      = $edit.id
                            changeType  = 'add'
                            #x           = if ($update.geometry.x) { $update.geometry.x } else { $null }
                            #y           = if ($update.geometry.y) { $update.geometry.y } else { $null }
                        }

                        # CONVERT DATE PROPERTIES
                        $attributesObject.last_edited_date = (ConvertFrom-Epoch -Milliseconds $attributesObject.last_edited_date).ToString()
                        $attributesObject.created_date = (ConvertFrom-Epoch -Milliseconds $attributesObject.created_date).ToString()

                        # ADD ATTRIBUTE TO ARRAY
                        $report.features += $attributesObject | Select-Object -Property $featProps
                    }
                }

                # PROCESS FEATURE DELETIONS
                foreach ($delete in $feature.deleteIds) {
                    # CREATE CUSTOM OBJECT AND ADD TO ARRAY
                    $report.deleted += [PSCustomObject] @{ serviceName = $ServiceName; itemType = 'feature'; id = $delete }
                }
            }

            # PROCESS ATTACHMENT EDITS
            foreach ($attachment in $edit.attachments) {
                # PROCESS FEATURE UPDATES
                foreach ($update in $attachment.updates) {
                    # EVALUATE EACH ATTRIBUTE
                    foreach ($aiObject in $add.attachmentInfos) {
                        # ADD GEOMETRY TO ATTRIBUTE
                        Add-Member -InputObject $aiObject -NotePropertyMembers @{
                            serviceName    = $ServiceName
                            editId         = $edit.id
                            changeType     = 'add'
                            parentObjectId = $add.parentObjectId
                            parentGlobalId = $add.parentGlobalId
                        }

                        # ADD ATTRIBUTE TO ARRAY
                        $report.attachments += $aiObject
                    }
                }

                # PROCESS FEATURE ADDITIONS
                foreach ($add in $attachment.adds) {
                    # EVALUATE EACH ATTRIBUTE
                    foreach ($aiObject in $add.attachmentInfos) {
                        # ADD GEOMETRY TO ATTRIBUTE
                        Add-Member -InputObject $aiObject -NotePropertyMembers @{
                            serviceName    = $ServiceName
                            editId         = $edit.id
                            changeType     = 'add'
                            parentObjectId = $add.parentObjectId
                            parentGlobalId = $add.parentGlobalId
                        }

                        # ADD ATTRIBUTE TO ARRAY
                        $report.attachments += $aiObject
                    }
                }

                # PROCESS ATTACHMENT DELETIONS
                foreach ($delete in $attachment.deleteIds) {
                    # CREATE CUSTOM OBJECT AND ADD TO ARRAY
                    $report.deleted += [PSCustomObject] @{ serviceName = $ServiceName; itemType = 'attachment'; id = $delete }
                }
            }
        }
    }
    End {
        # RETURN REPORT OBJECT
        [PSCustomObject] $report
    }
}
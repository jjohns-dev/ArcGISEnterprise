function New-TableSchemaObject {
    <# =========================================================================
    .SYNOPSIS
        Create a new table schema object
    .DESCRIPTION
        Create a new table schema object for a Hosted Feature Service table
    .PARAMETER Type
        Object type
    .PARAMETER Name
        Schema object name
    .PARAMETER Alias
        Schema object alias
    .PARAMETER Length
        Field maximum length
    .PARAMETER OID
        Internal OID property
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> New-TableSchemaObject -Type string -Name RegionName -Alias "Region Name" -Length 255
        Returns an object with all required properties for a schema component of a Hosted Feature Service table
    .NOTES
        Name:     New-TableSchemaObject
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2024-03-08
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = '_typ')]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = '_typ', HelpMessage = 'Object type')]
        [ValidateSet('date', 'short', 'blob', 'double', 'guid', 'string', 'long', 'float')]
        [System.String] $Type,

        [Parameter(Mandatory = $true, ParameterSetName = '_typ', HelpMessage = 'Schema object name')]
        [ValidateScript({$_ -cnotmatch '[A-Z\s]'})]
        #[ValidatePattern('[^A-Z\s]')]
        [System.String] $Name,

        [Parameter(Mandatory = $true, ParameterSetName = '_typ', HelpMessage = 'Schema object alias')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Alias,

        [Parameter(Mandatory = $false, ParameterSetName = '_typ', HelpMessage = 'Field maximum length')]
        [ValidateRange(1, 1000)]
        [System.Int32] $Length,

        [Parameter(Mandatory = $true, ParameterSetName = '_oid', HelpMessage = 'Internal OID property')]
        [System.Management.Automation.SwitchParameter] $OID
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # CREATE LOOKUP TABLE FOR PROPERTIES
        New-Variable -Name 'TableFieldTypes' -Option ReadOnly -Value @{
            oid    = @{ type = 'esriFieldTypeOID'; modelName = 'OBJECTID'; sqlType = 'sqlTypeInteger' }
            string = @{ type = 'esriFieldTypeString'; modelName = 'type_text'; sqlType = 'sqlTypeVarchar' }
            double = @{ type = 'esriFieldTypeDouble'; modelName = 'type_double'; sqlType = 'sqlTypeNumeric' }
            short  = @{ type = 'esriFieldTypeSmallInteger'; modelName = 'type_int_short'; sqlType = 'sqlTypeSmallInt' }
            long   = @{ type = 'esriFieldTypeInteger'; modelName = 'type_int_long'; sqlType = 'sqlTypeInteger' }
            float  = @{ type = 'esriFieldTypeDouble'; modelName = 'type_float'; sqlType = 'sqlTypeNumeric' }
            date   = @{ type = 'esriFieldTypeDate'; modelName = 'type_date'; sqlType = 'sqlTypeTimestamp' }
            guid   = @{ type = 'esriFieldTypeGUID'; modelName = 'type_guid'; sqlType = 'sqlTypeVarchar' }
            blob   = @{ type = 'esriFieldTypeBlob'; modelName = 'type_blob'; sqlType = 'sqlTypeBinary' }
        }
    }
    Process {
        # CHECK FOR PARAMETER SET
        if ($PSCmdlet.ParameterSetName -EQ '_oid') {
            # CREATE AND RETURN OID OBJECT
            [PSCustomObject] @{
                nullable     = $false
                defaultValue = $null
                editable     = $false
                length       = 8 # $null
                type         = 'esriFieldTypeOID'
                modelName    = 'OBJECTID'
                sqlType      = 'sqlTypeInteger'
                name         = 'objectid'
                alias        = 'OBJECTID'
            }
        }
        else {
            # CREATE AND RETURN OBJECT
            [PSCustomObject] @{
                nullable     = $true
                defaultValue = $null
                editable     = $true
                length       = $Length #if ($PSBoundParameters.ContainsKey('Length')) { $Length } else { $null }
                type         = $TableFieldTypes[$Type].type
                modelName    = $TableFieldTypes[$Type].modelName
                sqlType      = $TableFieldTypes[$Type].sqlType
                name         = $Name
                alias        = $Alias
            }
        }
    }
}
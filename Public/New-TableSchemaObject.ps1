function New-TableSchemaObject {
    <#
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
    .PARAMETER GID
        Internal GlobalID property
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
        Version:  0.1.1 | Last Edit: 2025-01-28
        - Version history is capture in repository commit history
        Comments:
    #>
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Creates an in-memory object only; does not call any API or change any external state.')]
    [CmdletBinding(DefaultParameterSetName = '_typ')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = '_typ', HelpMessage = 'Object type')]
        [ValidateSet('oid', 'gid', 'date', 'short', 'blob', 'double', 'guid', 'integer', 'string', 'long', 'float')]
        [System.String] $Type,

        [Parameter(Mandatory = $true, ParameterSetName = '_typ', HelpMessage = 'Schema object name')]
        [ValidateScript({$_ -cnotmatch '[A-Z\s]'})]
        [System.String] $Name,

        [Parameter(Mandatory = $true, ParameterSetName = '_typ', HelpMessage = 'Schema object alias')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Alias,

        [Parameter(Mandatory = $false, ParameterSetName = '_typ', HelpMessage = 'Field maximum length')]
        [ValidateRange(1, 8000)]
        [System.Int32] $Length,

        [Parameter(Mandatory = $true, ParameterSetName = '_oid', HelpMessage = 'Internal OID property')]
        [System.Management.Automation.SwitchParameter] $OID,

        [Parameter(Mandatory = $true, ParameterSetName = '_gid', HelpMessage = 'Internal GlobalID property')]
        [System.Management.Automation.SwitchParameter] $GID
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)

        # CREATE LOOKUP TABLE FOR PROPERTIES
        New-Variable -Name 'TableFieldTypes' -Option ReadOnly -Value @{
            oid     = @{ sqlType = 'sqlTypeInteger'; type = 'esriFieldTypeOID' }
            gid     = @{ sqlType = 'sqlTypeVarchar'; type = 'esriFieldTypeGlobalID' }
            string  = @{ sqlType = 'sqlTypeVarchar'; type = 'esriFieldTypeString' }
            short   = @{ sqlType = 'sqlTypeSmallInt'; type = 'esriFieldTypeSmallInteger' }
            long    = @{ sqlType = 'sqlTypeSmallInt'; type = 'esriFieldTypeInteger' }
            integer = @{ sqlType = 'sqlTypeInteger'; type = 'esriFieldTypeInteger' }
            double  = @{ sqlType = 'sqlTypeNumeric'; type = 'esriFieldTypeDouble' }
            float   = @{ sqlType = 'sqlTypeNumeric'; type = 'esriFieldTypeDouble' }
            date    = @{ sqlType = 'sqlTypeTimestamp'; type = 'esriFieldTypeDate' }
            guid    = @{ sqlType = 'sqlTypeVarchar'; type = 'esriFieldTypeGUID' }
            blob    = @{ sqlType = 'sqlTypeBinary'; type = 'esriFieldTypeBlob' }
        }
    }
    Process {
        # CREATE AND RETURN OBJECT
        [PSCustomObject] @{
            nullable     = switch ($PSCmdlet.ParameterSetName) { '_oid' { $false }; '_gid' { $false }; '_typ' { $true } }
            editable     = switch ($PSCmdlet.ParameterSetName) { '_oid' { $false }; '_gid' { $false }; '_typ' { $true } }
            length       = switch ($PSCmdlet.ParameterSetName) {
                '_oid' { 8 }
                '_gid' { 38 }
                '_typ' { if ($PSBoundParameters.ContainsKey('Length')) { $Length } else { $null } } }
            type     = switch ($PSCmdlet.ParameterSetName) {
                '_oid' { $TableFieldTypes.oid.type }
                '_gid' { $TableFieldTypes.gid.type }
                '_typ' { $TableFieldTypes[$Type].type }
            }
            name         = switch ($PSCmdlet.ParameterSetName) { '_oid' { 'objectid' }; '_gid' { 'globalid' }; '_typ' { $Name } }
            alias        = switch ($PSCmdlet.ParameterSetName) { '_oid' { 'OBJECTID' }; '_gid' { 'GlobalID' }; '_typ' { $Alias } }
            locationType = "unknown"
            defaultValue = $null
            domain       = $null
            sqlType      = switch ($PSCmdlet.ParameterSetName) {
                '_oid' { $TableFieldTypes.oid.sqlType }
                '_gid' { $TableFieldTypes.gid.sqlType }
                '_typ' { $TableFieldTypes[$Type].sqlType }
            }
            # sqlTypeCode = switch ($PSCmdlet.ParameterSetName) { '_oid' { }; '_gid' { 12 }; '_typ' { } }
        }
    }
}
function ConvertTo-RedactedHashtable {
    <#
    .SYNOPSIS
        Copy a hashtable with credential values redacted
    .DESCRIPTION
        Returns a shallow copy of a dictionary (a request Body or Form, or $PSBoundParameters) in which the
        values of credential keys (token, password, client_secret; case-insensitive) are replaced with
        '[redacted]'. Use it to write request data to the verbose stream without the credential. The input
        is not modified, so the request itself still carries the real values.
    .PARAMETER InputObject
        Dictionary to copy
    .INPUTS
        None.
    .OUTPUTS
        System.Collections.Specialized.OrderedDictionary.
    .EXAMPLE
        PS C:\> Write-Verbose -Message ('Request body: {0}' -f (ConvertTo-RedactedHashtable -InputObject $restParams.Body | ConvertTo-Json -Compress))
        Writes the request body to the verbose stream with the token replaced by '[redacted]'
    .NOTES
        Status: Stable
        Comments: Private helper (#171).
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Dictionary to copy')]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary] $InputObject
    )
    Process {
        $copy = [ordered]@{}
        foreach ($key in $InputObject.Keys) {
            $copy[$key] = if ("$key" -in 'token', 'password', 'client_secret') { '[redacted]' } else { $InputObject[$key] }
        }
        $copy
    }
}

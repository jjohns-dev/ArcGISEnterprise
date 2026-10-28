function ConvertFrom-Epoch {
    [CmdletBinding()]
    [OutputType([System.DateTime])]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'EPOCH Time in milliseconds')]
        [ValidateNotNullOrEmpty()]
        [System.Int64[]] $Milliseconds
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        foreach ($ms in $Milliseconds) {

            [System.DateTimeOffset]::FromUnixTimeMilliseconds($ms).DateTime.ToLocalTime()
        }
    }
}
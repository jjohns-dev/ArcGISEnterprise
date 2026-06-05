function Format-CsvHeader {
    <#
    .SYNOPSIS
        Clean CSV data headers
    .DESCRIPTION
        Cleans or sanitizes CSV data headers by converting to lowercase and replacing spaces with underscores
    .PARAMETER Path
        CSV file path
    .PARAMETER KeepHeaders
        Keep original headers
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Format-CsvHeader -Path C:\temp\file.csv
        Sanitizes headers and returns data as array of objects
    .NOTES
        Status: Stable
        Comments:
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'CSV file path')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter '*.csv' })]
        [System.String] $Path,

        [Parameter(HelpMessage = 'Keep original headers')]
        [System.Management.Automation.SwitchParameter] $KeepHeaders
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        # GET FILE CONTENT
        $content = Get-Content -Path $Path -TotalCount 1
        #$content = [System.Collections.Generic.List[System.Object]]::new((Get-Content -Path $file.FullName))

        # REMOVE DOUBLE QUOTES
        $content = $content.Replace('"', '') # THIS MAY REMOVE TOO MUCH. IF SO, USE NEXT LINE
        #$content = $content.TrimStart('"').Replace('","', ',').TrimEnd('"')

        # GET CSV DATA HEADERS - USING "Get-Member" REORDERS THE HEADERS BOO!!!
        $headers = $content.Split(',')

        # CREATE NEW, SANITIZED HEADERS
        $newHeaders = foreach ($h in $headers) { $h.Trim().ToLower().Replace(' ', '_') }

        # CHECK FOR KEEP HEADERS
        if ($KeepHeaders) {
            # IMPORT DATA AGAIN WITH NEW HEADERS, KEEPING OLD HEADERS
            Import-Csv -Path $Path -Header $newHeaders
        }
        else {
            # IMPORT DATA AGAIN WITH NEW HEADERS, SKIPPING OLD HEADERS
            Import-Csv -Path $Path -Header $newHeaders | Select-Object -Skip 1
        }
    }
}
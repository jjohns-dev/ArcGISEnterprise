function ConvertFrom-ArcGISLog {
    <#
    .SYNOPSIS
        Convert from ArcGIS log
    .DESCRIPTION
        Convert from ArcGIS Server or Portal log to array of objects
    .PARAMETER Path
        Path to log file
    .INPUTS
        System.String.
    .OUTPUTS
        System.Management.Automation.PSCustomObject.
    .EXAMPLE
        PS C:\> ConvertFrom-ArcGISLog -Path "C:\logs\myLog.log"
        Converts all entries in the log to objects
    .NOTES
        Status: Stable
        Comments: No external API reference — utility function.
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Path to log file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [System.String] $Path
    )
    Begin {
        Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    }
    Process {
        # GET CONTENT OF LOG FILE
        $content = Get-Content -Path $Path

        # GET HEADERS
        $headers = (([System.Xml.XmlDocument] $content[0]).Msg | Get-Member -MemberType Property).Name

        foreach ($line in $content) {

            # IF LINE DOES EMD WITH CLOSING TAG APPEND CORRECT TAG
            if (-Not $line.EndsWith('</Msg>')) { $line += '</Msg>' }

            try {
                # CONVERT LINE TO XML OR CATCH ERROR
                $xml = ([System.Xml.XmlDocument] $line).Msg

                # CREATE HASHTABLE
                $hash = [Ordered] @{}

                # ADD PROPERTY NAME AND VALUE TO HASHTABLE
                for ($i = 0; $i -LT $headers.Count; $i++) {

                    if ($headers[$i] -EQ '#text') { $hash['message'] = $xml.'#text' }
                    else { $hash[$headers[$i]] = $xml.GetAttribute($headers[$i]) }
                }

                # CAST HASHTABLE AS OBJECT AND OUTPUT
                [PSCustomObject] $hash
            }
            catch {
                # THE CONVERSION ERRORS CAN BE VIEWED BY USING "-ErrorVariable" PARAMETER
                #Write-Warning -Message ('{0}' -f $_.Exception.Message)
                Write-Warning -Message ('Invalid log entry "{0}"' -f $line)
            }
        }
    }
}
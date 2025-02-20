function ConvertFrom-GeoJson {
    <#
    .SYNOPSIS
        Convert GeoJSON to ArcGIS JSON
    .DESCRIPTION
        Convert GeoJSON to ArcGIS JSON
    .PARAMETER GeoJson
        GeoJSON as an object
    .PARAMETER IDAttribute
        ID attribute
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> ConvertFrom-GeoJson -GeoJson (Get-Content -Path 'C:\temp\geojson.json' | ConvertFrom-Json)
        Converts GeoJSON in a flat file to objects and then to ArcGIS JSON
    .EXAMPLE
        PS C:\> $geoJson = Invoke-RestMethod -Uri 'https://services.arcgis.com/arcgis/rest/services/Counties/FeatureServer/0/query?where=1%3D1&outFields=*&f=geojson'
        PS C:\> ConvertFrom-GeoJson -GeoJson $geoJson
        Converts GeoJSON from a REST endpoint to objects and then to ArcGIS JSON
    .NOTES
        Name:     ConvertFrom-GeoJson
        Author:   Justin Johns (original author linked below)
        Version:  0.1.0 | Last Edit: 2025-02-20
        - Version history is capture in repository commit history
        Comments:
        https://unpkg.com/@esri/arcgis-to-geojson-utils@1.2.0/dist/arcgis-to-geojson.js
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'GeoJSON as an object')]
        [ValidateNotNullOrEmpty()]
        [System.Object] $GeoJson,

        [Parameter(Mandatory = $false, HelpMessage = 'ID attribute')]
        [ValidateNotNullOrEmpty()]
        [System.String] $IDAttribute = 'OBJECTID'
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # SET VARIABLES
        $spatialReference = @{ wkid = 4326 } # WELL-KNOWN ID
        $result = @{}
    }
    Process {
        # WRITE VERBOSE
        Write-Verbose -Message ('Type is [{0}]' -f $GeoJson.type)

        # PROCESS GEOJSON
        switch ($GeoJson.type) {
            'Point' {
                $result.x = $GeoJson.coordinates[0]
                $result.y = $GeoJson.coordinates[1]
                $result.spatialReference = $spatialReference
            }
            'MultiPoint' {
                $result.points = $GeoJson.coordinates.Clone()
                $result.spatialReference = $spatialReference
            }
            'LineString' {
                $result.paths = @($GeoJson.coordinates.Clone())
                $result.spatialReference = $spatialReference
            }
            'MultiLineString' {
                $result.paths = $GeoJson.coordinates.Clone()
                $result.spatialReference = $spatialReference
            }
            'Polygon' {
                $result.rings = Update-RingOrientation $GeoJson.coordinates #.Clone() -Verbose # why does this need to use '.Clone()' # $GeoJson = $county.features[0].geometry
                $result.spatialReference = $spatialReference
            }
            'MultiPolygon' {
                $result.rings = Format-MultiPolygonRing $GeoJson.coordinates #.Clone()
                $result.spatialReference = $spatialReference
            }
            'Feature' {
                Write-Verbose -Message ('Geometry is [{0}]' -f $GeoJson.geometry.type)
                if ($GeoJson.geometry) {
                    $result.geometry = ConvertFrom-GeoJson $GeoJson.geometry $IDAttribute
                }
                $result.attributes = if ($GeoJson.properties) { Get-ShallowClone $GeoJson.properties } else { @{} }
                if ($GeoJson.id) {
                    $result.attributes[$IDAttribute] = $GeoJson.id
                }
            }
            'FeatureCollection' {
                $result = @()
                for ($i = 0; $i -lt $GeoJson.features.Length; $i++) {
                    $result += ConvertFrom-GeoJson $GeoJson.features[$i] $IDAttribute
                }
            }
            'GeometryCollection' {
                $result = @()
                for ($i = 0; $i -lt $GeoJson.geometries.Length; $i++) {
                    $result += ConvertFrom-GeoJson $GeoJson.geometries[$i] $IDAttribute
                }
            }
        }
        return [PSCustomObject] $result
    }
}
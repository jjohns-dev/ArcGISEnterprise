# ==============================================================================
# Filename: GeoJson.ps1
# Version:  0.1.0 | Updated: 2025-02-20
# Author:   Justin Johns (original author linked in notes)
# ==============================================================================

<# =============================================================================
.DESCRIPTION
    Long description
.NOTES
    Version History: (see commit history)
    General Notes:
    https://unpkg.com/@esri/arcgis-to-geojson-utils@1.2.0/dist/arcgis-to-geojson.js

    Other Helpful Links:
    - https://esri.github.io/geometry-api-java/doc/Polygon.html
    - https://developers.arcgis.com/rest/services-reference/enterprise/geometry-objects/
    - https://developers.arcgis.com/rest/services-reference/enterprise/areas-and-lengths/
============================================================================= #>

function Test-PointsEqual {
    param (
        [array] $PointA,
        [array] $PointB
    )
    $result = $true
    for ($i = 0; $i -lt $PointA.Length; $i++) {
        if ($PointA[$i] -ne $PointB[$i]) {
            #if ($PointA[$i][0] -ne $PointB[$i][0] -or $PointA[$i][1] -ne $PointB[$i][1]) {
            $result = $false # DOES THIS NEED A BREAK?
            break
        }
    }
    return $result
}

function Close-Ring {
    [CmdletBinding()]
    param (
        #[array] $Coordinates
        [System.Collections.Generic.List[System.Object]] $Coordinates
    )
    $verbose = @($Coordinates[0][0], $Coordinates[0][1], $Coordinates[-1][0], $Coordinates[-1][1])
    Write-Verbose -Message ('Testing points for close ring [{0}, {1}] and [{2}, {3}]...' -f $verbose)
    if (-not (Test-PointsEqual $Coordinates[0] $Coordinates[-1])) {
        Write-Verbose -Message 'Adding first point to close ring...'
        #$Coordinates += $Coordinates[0]
        $Coordinates.Add($Coordinates[0])
    }
    return $Coordinates
}

function Test-RingIsClockwise {
    [CmdletBinding()]
    param (
        [array] $Ring
    )
    Write-Verbose -Message 'Testing ring is clockwise...'
    $total = 0
    $pt1 = $Ring[0]
    for ($i = 0; $i -lt $Ring.Length - 1; $i++) {
        $pt2 = $Ring[$i + 1]
        $total += ($pt2[0] - $pt1[0]) * ($pt2[1] + $pt1[1])
        $pt1 = $pt2
    }
    return ($total -ge 0)
}

function Update-RingOrientation {
    [CmdletBinding()]
    param (
        [array] $Polygon
    )
    Write-Verbose -Message 'Orienting rings...'
    $output = [System.Collections.Generic.List[System.Object]]::new()

    $outerRing = Close-Ring $Polygon[0]
    if ($outerRing.Length -ge 4) {
        if (-not (Test-RingIsClockwise $outerRing)) {
            [array]::Reverse($outerRing)
        }
        if ($Polygon.Length -eq 1) {
            $addList = [System.Collections.Generic.List[System.Object]]::new()
            $addList.Add($outerRing)
            $output.Add($addList)
        }
        else {
            $output.Add($outerRing)
            for ($i = 1; $i -lt $Polygon.Length; $i++) {
                $hole = Close-Ring $Polygon[$i]
                if ($hole.Length -ge 4) {
                    if (Test-RingIsClockwise $hole) {
                        [array]::Reverse($hole)
                    }
                    $output.Add($hole)
                }
            }
        }
    }
    return $output
}

function Format-MultiPolygonRing {
    [CmdletBinding()]
    param (
        [array] $Ring
    )
    Write-Verbose -Message 'Flattening multi-polygon rings...'

    $output = [System.Collections.Generic.List[System.Object]]::new() #@()
    $coordLists = [System.Collections.Generic.List[System.Object]]::new()

    Write-Verbose -Message ('rings has [{0}] elements' -f $Ring.Length)

    # testing 2
    foreach ($array in $Ring) {

        Write-Verbose -Message ('array has [{0}] elements' -f $array.Length)

        foreach ($subArray in $array) {

            Write-Verbose -Message ('subArray has [{0}] elements' -f $subArray.Length)

            if ($subArray[0][0] -is [System.Double]) {
                Write-Verbose -Message 'subArray[0][0] is a double. Adding subArray to coordLists...'
                $coordLists.Add($subArray)
            }
            else {
                Write-Error -Message 'subArray first element is not a double...'
            }
        }
    }

    $polygon = Update-RingOrientation $coordLists
    $output.Add($polygon)

    #return $coordLists
    return $output
}

function Get-ShallowClone {
    param (
        [System.Object] $Object # original was hashtable # System.Collections.Hashtable
    )
    $target = @{}
    foreach ($property in $Object.psobject.Properties) {
        $target.Add($property.Name.ToLower(), $property.Value)
    }
    return $target
}

<#function ConvertFrom-GeoJson {
    [CmdletBinding()]
    param (
        [System.Object] $GeoJson, # original was System.Collections.Hashtable
        [System.String] $IDAttribute = 'OBJECTID'
    )
    $spatialReference = @{ wkid = 4326 } # WELL-KNOWN ID
    $result = @{}
    Write-Verbose -Message ('Type is [{0}]' -f $GeoJson.type)
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
} #>

<# -- Example usage
$geojson = @{
    type = 'Point'
    coordinates = @(102.0, 0.5)
}
$result = ConvertFrom-GeoJson -GeoJson $geojson
Write-Output $result

$z = ConvertFrom-GeoJson -GeoJson $county
$z = ConvertFrom-GeoJson -GeoJson $county.features[1]

$z
#>

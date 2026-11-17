[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
param()

BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }

    $validLocations = @(
        @{ Case = 'hashtable of doubles'; Location = @{ x = -77.3; y = 38.8 } }
        @{ Case = 'ordered dictionary of doubles'; Location = [ordered]@{ x = -77.3; y = 38.8 } }
        @{ Case = 'PSCustomObject of doubles'; Location = [PSCustomObject]@{ x = -77.3; y = 38.8 } }
        @{ Case = 'hashtable of integers'; Location = @{ x = -77; y = 38 } }
        @{ Case = 'PSCustomObject of integers'; Location = [PSCustomObject]@{ x = -77; y = 38 } }
        @{ Case = 'ConvertFrom-Json whole numbers (Int64)'; Location = '{"x":-77,"y":38}' | ConvertFrom-Json }
        @{ Case = 'decimals'; Location = @{ x = -77.3d; y = 38.8d } }
        @{ Case = 'singles'; Location = @{ x = [single]-77.3; y = [single]38.8 } }
    )
    $invalidLocations = @(
        @{ Case = 'missing y'; Location = @{ x = -77.3 } }
        @{ Case = 'numeric strings'; Location = [PSCustomObject]@{ x = '-77.3'; y = '38.8' } }
        @{ Case = 'NaN'; Location = [PSCustomObject]@{ x = [double]::NaN; y = 38.8 } }
        @{ Case = 'infinity'; Location = [PSCustomObject]@{ x = [double]::PositiveInfinity; y = 38.8 } }
        @{ Case = 'booleans'; Location = [PSCustomObject]@{ x = $true; y = $false } }
    )
}

Describe -Name 'Find-ServerReverseGeocode' -Fixture {
    BeforeAll {
        $commonParams = @{
            ServiceName = 'TestLocator'
            Context     = [System.Uri]::new('https://server.example.com/arcgis')
            Token       = 'testTokenValue123'
        }
        Mock -CommandName Invoke-RestMethod -MockWith {
            [PSCustomObject] @{ address = [PSCustomObject] @{ Match_addr = 'test' } }
        } -ModuleName $env:BHProjectName
    }
    It -Name 'accepts a location given as <Case>' -ForEach $validLocations -Test {
        Find-ServerReverseGeocode @commonParams -Location $Location
        Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName
    }
    It -Name 'sends whole-number coordinates as x, y' -Test {
        Find-ServerReverseGeocode @commonParams -Location @{ x = -77; y = 38 }
        Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName -ParameterFilter {
            $Body.location -eq '-77, 38'
        }
    }
    It -Name 'rejects a location with <Case>' -ForEach $invalidLocations -Test {
        { Find-ServerReverseGeocode @commonParams -Location $Location } | Should -Throw -ExpectedMessage "*parameter 'Location'*"
        Should -Invoke -CommandName Invoke-RestMethod -Times 0 -Exactly -ModuleName $env:BHProjectName
    }
}

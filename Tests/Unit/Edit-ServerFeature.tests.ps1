[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
param()

BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }

    $featureShapes = @(
        @{ Shape = 'hashtable'; Feature = @{ attributes = @{ objectid = 1 } } }
        @{ Shape = 'ordered dictionary'; Feature = [ordered]@{ attributes = @{ objectid = 1 } } }
        @{ Shape = 'PSCustomObject'; Feature = [PSCustomObject]@{ attributes = @{ objectid = 1 } } }
    )
}

Describe -Name 'Edit-ServerFeature' -Fixture {
    BeforeAll {
        $commonParams = @{
            ServiceName = 'TestService'
            Context     = [System.Uri]::new('https://server.example.com/arcgis')
            Token       = 'testTokenValue123'
        }
        Mock -CommandName Invoke-RestMethod -MockWith {
            [PSCustomObject] @{ addResults = @(); updateResults = @() }
        } -ModuleName $env:BHProjectName
    }
    Context -Name 'feature input shapes' -Fixture {
        It -Name 'accepts a <Shape> for -Add and sends it as adds' -ForEach $featureShapes -Test {
            Edit-ServerFeature @commonParams -Add $Feature
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName -ParameterFilter {
                $Body.adds -eq '[{"attributes":{"objectid":1}}]'
            }
        }
        It -Name 'accepts a <Shape> for -Update and sends it as updates' -ForEach $featureShapes -Test {
            Edit-ServerFeature @commonParams -Update $Feature
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName -ParameterFilter {
                $Body.updates -eq '[{"attributes":{"objectid":1}}]'
            }
        }
        It -Name 'sends every feature when -Update is given an array of hashtables' -Test {
            Edit-ServerFeature @commonParams -Update @(@{ attributes = @{ objectid = 1 } }, @{ attributes = @{ objectid = 2 } })
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName -ParameterFilter {
                $Body.updates -eq '[{"attributes":{"objectid":1}},{"attributes":{"objectid":2}}]'
            }
        }
    }
    Context -Name 'invalid feature input' -Fixture {
        It -Name 'rejects a <Parameter> feature without attributes' -ForEach @(
            @{ Parameter = 'Add' }
            @{ Parameter = 'Update' }
        ) -Test {
            $featureParam = @{ $Parameter = @{ geometry = @{ x = 1; y = 2 } } }
            { Edit-ServerFeature @commonParams @featureParam } | Should -Throw -ExpectedMessage "*parameter '$Parameter'*"
            Should -Invoke -CommandName Invoke-RestMethod -Times 0 -Exactly -ModuleName $env:BHProjectName
        }
    }
}

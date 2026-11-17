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

Describe -Name 'Add-ServerFeature' -Fixture {
    BeforeAll {
        $commonParams = @{
            ServiceName = 'TestService'
            Context     = [System.Uri]::new('https://server.example.com/arcgis')
            Token       = 'testTokenValue123'
        }
        Mock -CommandName Invoke-RestMethod -MockWith {
            [PSCustomObject] @{ addResults = @() }
        } -ModuleName $env:BHProjectName
    }
    It -Name 'accepts a <Shape> for -Feature and sends it as features' -ForEach $featureShapes -Test {
        Add-ServerFeature @commonParams -Feature $Feature
        Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName -ParameterFilter {
            $Body.features -eq '[{"attributes":{"objectid":1}}]'
        }
    }
    It -Name 'rejects a -Feature without attributes' -Test {
        { Add-ServerFeature @commonParams -Feature @{ geometry = @{ x = 1; y = 2 } } } | Should -Throw -ExpectedMessage "*parameter 'Feature'*"
        Should -Invoke -CommandName Invoke-RestMethod -Times 0 -Exactly -ModuleName $env:BHProjectName
    }
}

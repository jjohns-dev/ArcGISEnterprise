[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
param()

BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }
}

Describe -Name 'Remove-ServerServiceFeature' -Fixture {
    BeforeAll {
        $commonParams = @{
            ServiceName = 'TestService'
            LayerId     = 0
            Context     = [System.Uri]::new('https://server.example.com/arcgis')
            Token       = 'testTokenValue123'
            Confirm     = $false
        }
    }
    Context -Name 'where clause validation (intentionally strict: this deletes rows)' -Fixture {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith { [PSCustomObject] @{ deleteResults = @() } } -ModuleName $env:BHProjectName
        }
        It -Name 'accepts a numeric comparison' -Test {
            Remove-ServerServiceFeature @commonParams -Where 'objectid >= 10'
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName -ParameterFilter {
                $Body.where -eq 'objectid >= 10'
            }
        }
        It -Name 'rejects quoted string literals' -Test {
            { Remove-ServerServiceFeature @commonParams -Where "status='done'" } | Should -Throw -ExpectedMessage "*parameter 'Where'*"
            Should -Invoke -CommandName Invoke-RestMethod -Times 0 -Exactly -ModuleName $env:BHProjectName
        }
    }
    Context -Name 'service responses' -Fixture {
        It -Name 'returns an empty deleteResults without an error when nothing matches' -Test {
            Mock -CommandName Invoke-RestMethod -MockWith { [PSCustomObject] @{ deleteResults = @() } } -ModuleName $env:BHProjectName
            $result = Remove-ServerServiceFeature @commonParams -Where 'objectid = 999'
            $result.psobject.Properties.Name | Should -Contain 'deleteResults'
        }
        It -Name 'stops with the service error when the response body contains an error' -Test {
            Mock -CommandName Invoke-RestMethod -MockWith {
                [PSCustomObject] @{ error = [PSCustomObject] @{ code = 500; message = "Field name 'nosuchfield' does not exist."; details = @() } }
            } -ModuleName $env:BHProjectName
            { Remove-ServerServiceFeature @commonParams -Where 'nosuchfield = 1' } |
                Should -Throw -ExpectedMessage "*Delete failed*TestService*500*Field name 'nosuchfield' does not exist.*"
        }
        It -Name 'sends nothing with -WhatIf' -Test {
            Mock -CommandName Invoke-RestMethod -MockWith { [PSCustomObject] @{ deleteResults = @() } } -ModuleName $env:BHProjectName
            Remove-ServerServiceFeature @commonParams -WhatIf
            Should -Invoke -CommandName Invoke-RestMethod -Times 0 -Exactly -ModuleName $env:BHProjectName
        }
    }
}

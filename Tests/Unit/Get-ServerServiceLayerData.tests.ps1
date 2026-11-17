[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
param()

BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }

    # The first four were valid under the previous pattern '^[\w\*\s=<>''-]+$'; the shared pattern must still accept them.
    $validClauses = @(
        @{ Where = 'objectid >= 0' }
        @{ Where = "status='a'" }
        @{ Where = 'amount > -5' }
        @{ Where = "status <> 'a'" }
        @{ Where = 'amount > 2.0' }
        @{ Where = "status LIKE 'a%'" }
        @{ Where = "status IN ('a','b')" }
        @{ Where = "UPPER(status)='A'" }
    )
    $invalidClauses = @(
        @{ Where = "status='a'; DELETE FROM t" }
        @{ Where = 'status="a"' }
    )
}

Describe -Name 'Get-ServerServiceLayerData' -Fixture {
    BeforeAll {
        $commonParams = @{
            ServiceName = 'TestService'
            LayerId     = 0
            Context     = [System.Uri]::new('https://server.example.com/arcgis')
            Token       = 'testTokenValue123'
        }
    }
    Context -Name 'where clause validation' -Fixture {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith { [PSCustomObject] @{ features = @() } } -ModuleName $env:BHProjectName
        }
        It -Name 'accepts and sends <Where>' -ForEach $validClauses -Test {
            Get-ServerServiceLayerData @commonParams -Where $Where
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName -ParameterFilter {
                $Body.where -ceq $Where
            }
        }
        It -Name 'rejects <Where> with a readable message' -ForEach $invalidClauses -Test {
            { Get-ServerServiceLayerData @commonParams -Where $Where } | Should -Throw -ExpectedMessage '*contains unsupported characters*'
            Should -Invoke -CommandName Invoke-RestMethod -Times 0 -Exactly -ModuleName $env:BHProjectName
        }
    }
    Context -Name 'service responses' -Fixture {
        It -Name 'returns the response when the query succeeds' -Test {
            Mock -CommandName Invoke-RestMethod -MockWith {
                [PSCustomObject] @{ features = @([PSCustomObject] @{ attributes = [PSCustomObject] @{ status = 'a' } }) }
            } -ModuleName $env:BHProjectName
            (Get-ServerServiceLayerData @commonParams).features[0].attributes.status | Should -Be 'a'
        }
        It -Name 'stops with the service error when the response body contains an error' -Test {
            Mock -CommandName Invoke-RestMethod -MockWith {
                [PSCustomObject] @{ error = [PSCustomObject] @{ code = 500; message = "Field name 'objectid' does not exist."; details = @() } }
            } -ModuleName $env:BHProjectName
            { Get-ServerServiceLayerData @commonParams } | Should -Throw -ExpectedMessage "*TestService*500*Field name 'objectid' does not exist.*"
        }
    }
}

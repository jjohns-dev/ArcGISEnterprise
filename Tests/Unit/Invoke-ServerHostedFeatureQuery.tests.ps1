[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
param()

BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }

    # The first three were valid under the previous pattern '^[\w\*=]+$'; the new pattern must still accept them.
    $validClauses = @(
        @{ Where = '1=1' }
        @{ Where = 'ObjectId=1001' }
        @{ Where = 'objectid=*' }
        @{ Where = "status='a'" }
        @{ Where = 'amount > 2.0' }
        @{ Where = 'amount > -5' }
        @{ Where = "status LIKE 'a%'" }
        @{ Where = "status IN ('a','b')" }
        @{ Where = "status='o''brien'" }
        @{ Where = "UPPER(status)='A'" }
        @{ Where = "status <> 'a' AND amount >= 1.5" }
    )
    $invalidClauses = @(
        @{ Where = "status='a'; DELETE FROM t" }
        @{ Where = 'status="a"' }
    )
}

Describe -Name 'Invoke-ServerHostedFeatureQuery' -Fixture {
    BeforeAll {
        $commonParams = @{
            ServiceName = 'TestService'
            Context     = [System.Uri]::new('https://server.example.com/arcgis')
            Token       = 'testTokenValue123'
        }
    }
    Context -Name 'where clause validation' -Fixture {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith { [PSCustomObject] @{ features = @() } } -ModuleName $env:BHProjectName
        }
        It -Name 'accepts and sends <Where>' -ForEach $validClauses -Test {
            Invoke-ServerHostedFeatureQuery @commonParams -Where $Where
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName -ParameterFilter {
                $Body.where -ceq $Where
            }
        }
        It -Name 'rejects <Where> with a readable message' -ForEach $invalidClauses -Test {
            { Invoke-ServerHostedFeatureQuery @commonParams -Where $Where } | Should -Throw -ExpectedMessage '*contains unsupported characters*'
            Should -Invoke -CommandName Invoke-RestMethod -Times 0 -Exactly -ModuleName $env:BHProjectName
        }
    }
    Context -Name 'service responses' -Fixture {
        It -Name 'returns the response when the query succeeds' -Test {
            Mock -CommandName Invoke-RestMethod -MockWith {
                [PSCustomObject] @{ features = @([PSCustomObject] @{ attributes = [PSCustomObject] @{ status = 'a' } }) }
            } -ModuleName $env:BHProjectName
            $result = Invoke-ServerHostedFeatureQuery @commonParams -Where "status='a'"
            $result.features[0].attributes.status | Should -Be 'a'
        }
        It -Name 'stops with the service error when the response body contains an error' -Test {
            # The service returns query errors with HTTP 200, so Invoke-RestMethod returns the error object.
            Mock -CommandName Invoke-RestMethod -MockWith {
                [PSCustomObject] @{ error = [PSCustomObject] @{ code = 500; message = "Field name 'a' does not exist."; details = @() } }
            } -ModuleName $env:BHProjectName
            { Invoke-ServerHostedFeatureQuery @commonParams -Where 'status=a' } |
                Should -Throw -ExpectedMessage "*TestService*500*Field name 'a' does not exist.*"
        }
    }
}

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'The behavior under test is the session-wide $PSDefaultParameterValues.')]
param()

# Issue #182: Set-*Connection must set defaults in the global $PSDefaultParameterValues, not the module's own copy,
# or commands called from the user's session never receive them.
BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }

    $connections = @(
        @{ Name = 'Set-PortalConnection'; Pattern = '*-Portal*' }
        @{ Name = 'Set-ServerConnection'; Pattern = '*-Server*' }
        @{ Name = 'Set-GeoEventConnection'; Pattern = '*-GeoEventServer*' }
    )
}

Describe -Name '<Name> sets session-wide connection defaults' -ForEach $connections -Fixture {
    BeforeAll {
        $token = 'testTokenValue123'
        $context = [System.Uri]::new('https://arcgis.example.com/arcgis')
        $keys = @(('{0}:Context' -f $Pattern), ('{0}:Token' -f $Pattern))
    }
    BeforeEach {
        $saved = @{}
        foreach ($k in $keys) {
            if ($global:PSDefaultParameterValues.Contains($k)) { $saved[$k] = $global:PSDefaultParameterValues[$k] }
            $global:PSDefaultParameterValues.Remove($k)
        }
    }
    AfterEach {
        foreach ($k in $keys) {
            $global:PSDefaultParameterValues.Remove($k)
            if ($saved.ContainsKey($k)) { $global:PSDefaultParameterValues[$k] = $saved[$k] }
        }
    }
    It -Name 'adds the Context and Token defaults to the global $PSDefaultParameterValues' -Test {
        & $Name -Context $context -Token $token
        $global:PSDefaultParameterValues[$keys[0]] | Should -Be $context
        $global:PSDefaultParameterValues[$keys[1]] | Should -BeExactly $token
    }
}

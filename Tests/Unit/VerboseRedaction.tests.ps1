[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
param()

# Issue #171: verbose output must not contain the token; the request itself still carries it.
BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }

    $hex = '0123456789abcdef0123456789abcdef'
    $verboseFunctions = @(
        @{ Name = 'Edit-ServerFeature'; Params = @{ ServiceName = 'Svc'; Add = @{ attributes = @{ a = 1 } } }; Sender = 'Invoke-RestMethod' }
        @{ Name = 'Export-PortalGroupItem'; Params = @{ GroupID = $hex; Synchronous = $true }; Sender = 'Invoke-WebRequest' }
        @{ Name = 'Publish-PortalDataStoreLayer'; Params = @{ DataStoreId = $hex; PortalFolderId = $hex; ServerId = '0123456789abcdef'; ServerFolderName = 'Folder'; PortalId = '0123456789ABCDEF'; Confirm = $false }; Sender = 'Invoke-RestMethod' }
        @{ Name = 'Remove-ServerServiceFeature'; Params = @{ ServiceName = 'Svc'; LayerId = 0; Confirm = $false }; Sender = 'Invoke-RestMethod' }
        @{ Name = 'Get-ServerServiceReport'; Params = @{}; Sender = $null }
    )
}

Describe -Name 'Verbose output redacts the token' -Fixture {
    BeforeAll {
        $token = 'testTokenValue123'
        $context = [System.Uri]::new('https://portal.example.com/arcgis')
        $response = { [PSCustomObject] @{ id = '0123456789ABCDEF'; services = @(); folders = @(); addResults = @(); deleteResults = @() } }
        Mock -CommandName Invoke-RestMethod -MockWith $response -ModuleName $env:BHProjectName
        Mock -CommandName Invoke-WebRequest -MockWith $response -ModuleName $env:BHProjectName
    }
    It -Name '<Name> writes verbose output without the token' -ForEach $verboseFunctions -Test {
        $verbose = & $Name @Params -Context $context -Token $token -Verbose 4>&1 | Where-Object { $_ -is [System.Management.Automation.VerboseRecord] }
        @($verbose).Count | Should -BeGreaterThan 1
        @($verbose | Where-Object { $_.Message -match $token }).Count | Should -Be 0
        @($verbose | Where-Object { $_.Message -match '\[redacted\]' }).Count | Should -BeGreaterThan 0
    }
    It -Name '<Name> still sends the token in the request' -ForEach ($verboseFunctions | Where-Object Sender) -Test {
        & $Name @Params -Context $context -Token $token -Verbose 4>$null | Out-Null
        Should -Invoke -CommandName $Sender -ModuleName $env:BHProjectName -ParameterFilter {
            ($Body -is [System.Collections.IDictionary] -and $Body['token'] -ceq $token) -or ($Form -is [System.Collections.IDictionary] -and $Form['token'] -ceq $token)
        }
    }
}

Describe -Name 'ConvertTo-RedactedHashtable' -Fixture {
    It -Name 'redacts credential keys case-insensitively and keeps other values' -Test {
        InModuleScope -ModuleName $env:BHProjectName -ScriptBlock {
            $result = ConvertTo-RedactedHashtable -InputObject @{ Token = 't'; password = 'p'; CLIENT_SECRET = 's'; f = 'json'; where = '1=1' }
            $result['Token'] | Should -Be '[redacted]'
            $result['password'] | Should -Be '[redacted]'
            $result['CLIENT_SECRET'] | Should -Be '[redacted]'
            $result['f'] | Should -Be 'json'
            $result['where'] | Should -Be '1=1'
        }
    }
    It -Name 'does not modify the input' -Test {
        InModuleScope -ModuleName $env:BHProjectName -ScriptBlock {
            $body = @{ token = 't'; f = 'json' }
            $null = ConvertTo-RedactedHashtable -InputObject $body
            $body['token'] | Should -Be 't'
        }
    }
}

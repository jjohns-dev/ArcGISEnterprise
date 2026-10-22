[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
param()

BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }
}

Describe -Name 'Revoke-PortalApiKey' -Fixture {
    BeforeAll {
        $itemId = '0123456789abcdef0123456789abcdef'
        $commonParams = @{
            Context = [System.Uri]::new('https://portal.example.com/arcgis')
            Token   = 'testTokenValue123'
            Confirm = $false
        }
        Mock -CommandName Get-PortalApiKeyCredential -ModuleName $env:BHProjectName -MockWith {
            [PSCustomObject] @{ ItemId = '0123456789abcdef0123456789abcdef'; Title = 'test key'; Owner = 'jsmith'; Slot1Active = $true; Slot2Active = $false }
        }
        Mock -CommandName Get-PortalRegisteredAppInfo -ModuleName $env:BHProjectName -MockWith {
            [PSCustomObject] @{ client_id = 'clientId123'; client_secret = 'mockClientSecretValue' }
        }
        Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith { [PSCustomObject] @{ success = $true } }
    }
    Context -Name 'normal usage' -Fixture {
        It -Name 'revokes the requested active slot' -Test {
            Revoke-PortalApiKey -ItemId $itemId -Slot 1 @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 1 -Exactly -ParameterFilter {
                $Uri -like '*/oauth2/revokeToken' -and $Body['apiToken'] -eq 1 -and $Body['client_id'] -eq 'clientId123'
            }
        }
        It -Name 'produces no output' -Test {
            Revoke-PortalApiKey -ItemId $itemId -Slot 1 @commonParams | Should -BeNullOrEmpty
        }
        It -Name 'accepts ItemId from the pipeline by property name' -Test {
            [PSCustomObject] @{ ItemId = $itemId } | Revoke-PortalApiKey -Slot 1 @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 1 -Exactly
        }
    }
    Context -Name 'inactive slot' -Fixture {
        It -Name 'warns and makes no request' -Test {
            Revoke-PortalApiKey -ItemId $itemId -Slot 2 @commonParams -WarningVariable warnings -WarningAction SilentlyContinue
            $warnings | Should -Not -BeNullOrEmpty
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 0 -Exactly
        }
    }
    Context -Name 'WhatIf' -Fixture {
        It -Name 'makes no request' -Test {
            Revoke-PortalApiKey -ItemId $itemId -Slot 1 -WhatIf @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 0 -Exactly
        }
    }
    Context -Name 'error handling' -Fixture {
        It -Name 'reports an unsuccessful revoke' -Test {
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -MockWith {
                [PSCustomObject] @{ error = [PSCustomObject] @{ code = 400; message = 'Invalid client' } }
            }
            { Revoke-PortalApiKey -ItemId $itemId -Slot 1 @commonParams } | Should -Throw -ExpectedMessage '*400*'
        }
    }
}

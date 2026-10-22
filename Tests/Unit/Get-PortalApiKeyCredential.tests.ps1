[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
param()

BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }
}

Describe -Name 'Get-PortalApiKeyCredential' -Fixture {
    BeforeAll {
        $itemId = '0123456789abcdef0123456789abcdef'
        $secret = 'mockClientSecretValue'
        $commonParams = @{
            Context = [System.Uri]::new('https://portal.example.com/arcgis')
            Token   = 'testTokenValue123'
        }
        $credentialItem = [PSCustomObject] @{
            id                      = $itemId
            title                   = 'test key'
            owner                   = 'jsmith'
            type                    = 'Application'
            typeKeywords            = @('Application', 'Registered App', 'APIToken')
            apiToken1ExpirationDate = 1800384539394
            apiToken2ExpirationDate = 1792877825689
        }
        Mock -CommandName Get-PortalRegisteredAppInfo -ModuleName $env:BHProjectName -MockWith {
            [PSCustomObject] @{
                client_id       = 'clientId123'
                client_secret   = 'mockClientSecretValue'
                privileges      = @('portal:user:viewOrgItems')
                httpReferrers   = @()
                apiToken1Active = $true
                apiToken2Active = $false
            }
        }
    }
    Context -Name 'single item' -Fixture {
        BeforeAll {
            Mock -CommandName Get-PortalItem -ModuleName $env:BHProjectName -MockWith { $credentialItem }
        }
        It -Name 'returns the expiration of an active slot as a DateTime' -Test {
            $result = Get-PortalApiKeyCredential -ItemId $itemId @commonParams
            $result.Slot1Active | Should -BeTrue
            $result.Slot1Expires | Should -BeOfType [System.DateTime]
        }
        It -Name 'returns no expiration for an inactive slot with a stale value' -Test {
            $result = Get-PortalApiKeyCredential -ItemId $itemId @commonParams
            $result.Slot2Active | Should -BeFalse
            $result.Slot2Expires | Should -BeNullOrEmpty
        }
        It -Name 'looks up app info as the item owner by default' -Test {
            Get-PortalApiKeyCredential -ItemId $itemId @commonParams
            Should -Invoke -CommandName Get-PortalRegisteredAppInfo -ModuleName $env:BHProjectName -Times 1 -Exactly -ParameterFilter { $UserName -eq 'jsmith' }
        }
        It -Name 'uses the item owner even when UserName is given' -Test {
            Get-PortalApiKeyCredential -ItemId $itemId -UserName 'someoneElse' @commonParams
            Should -Invoke -CommandName Get-PortalRegisteredAppInfo -ModuleName $env:BHProjectName -Times 1 -Exactly -ParameterFilter { $UserName -eq 'jsmith' }
        }
        It -Name 'does not output the client secret' -Test {
            $result = Get-PortalApiKeyCredential -ItemId $itemId @commonParams
            $result.PSObject.Properties.Name | Should -Not -Contain 'client_secret'
            ($result | ConvertTo-Json -Depth 5) | Should -Not -Match $secret
        }
        It -Name 'accepts ItemId from the pipeline by property name' -Test {
            $result = [PSCustomObject] @{ ItemId = $itemId } | Get-PortalApiKeyCredential @commonParams
            $result.ItemId | Should -Be $itemId
        }
    }
    Context -Name 'list mode' -Fixture {
        BeforeAll {
            # Search results omit apiToken*ExpirationDate; the full item has them
            $searchResult = [PSCustomObject] @{ id = $itemId; owner = 'jsmith'; type = 'Application'; typeKeywords = @('Application', 'Registered App', 'APIToken') }
            $otherApp = [PSCustomObject] @{ id = 'fedcba9876543210fedcba9876543210'; owner = 'jsmith'; type = 'Application'; typeKeywords = @('Application', 'Registered App') }
            Mock -CommandName Find-PortalItem -ModuleName $env:BHProjectName -MockWith { $searchResult, $otherApp }
            Mock -CommandName Get-PortalItem -ModuleName $env:BHProjectName -MockWith { $credentialItem }
            Mock -CommandName Resolve-PortalUserName -ModuleName $env:BHProjectName -MockWith { 'jsmith' }
        }
        It -Name 'returns only API key credentials items' -Test {
            $result = Get-PortalApiKeyCredential @commonParams
            @($result) | Should -HaveCount 1
            $result.ItemId | Should -Be $itemId
        }
        It -Name 'returns slot expirations from the full item' -Test {
            $result = Get-PortalApiKeyCredential @commonParams
            $result.Slot1Expires | Should -BeOfType [System.DateTime]
            Should -Invoke -CommandName Get-PortalItem -ModuleName $env:BHProjectName -Times 1 -Exactly -ParameterFilter { $ItemId -eq '0123456789abcdef0123456789abcdef' }
        }
        It -Name 'defaults the owner to the token user' -Test {
            Get-PortalApiKeyCredential @commonParams
            Should -Invoke -CommandName Find-PortalItem -ModuleName $env:BHProjectName -Times 1 -Exactly -ParameterFilter { $Owner -eq 'jsmith' -and $Type -eq 'Application' }
        }
        It -Name 'does not resolve the token user when UserName is provided' -Test {
            Get-PortalApiKeyCredential -UserName 'other' @commonParams
            Should -Invoke -CommandName Resolve-PortalUserName -ModuleName $env:BHProjectName -Times 0 -Exactly
        }
    }
    Context -Name 'error handling' -Fixture {
        It -Name 'rejects an item that is not API key credentials' -Test {
            Mock -CommandName Get-PortalItem -ModuleName $env:BHProjectName -MockWith {
                [PSCustomObject] @{ id = '0123456789abcdef0123456789abcdef'; owner = 'jsmith'; type = 'Web Map'; typeKeywords = @() }
            }
            { Get-PortalApiKeyCredential -ItemId $itemId @commonParams } | Should -Throw -ExpectedMessage '*not an API key credentials item*'
        }
        It -Name 'reports an error returned for the item' -Test {
            Mock -CommandName Get-PortalItem -ModuleName $env:BHProjectName -MockWith {
                [PSCustomObject] @{ error = [PSCustomObject] @{ code = 403; message = 'You do not have permissions' } }
            }
            { Get-PortalApiKeyCredential -ItemId $itemId @commonParams } | Should -Throw -ExpectedMessage '*403*'
        }
    }
}

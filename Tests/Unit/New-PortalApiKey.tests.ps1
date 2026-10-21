[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
param()

BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }
}

Describe -Name 'New-PortalApiKey' -Fixture {
    BeforeAll {
        $itemId = '0123456789abcdef0123456789abcdef'
        $secret = 'mockClientSecretValue'
        # Slot digit sits 10 characters from the end
        $slot2Key = 'AAPT' + ('x' * 238) + '2' + ('y' * 9)
        $commonParams = @{
            ItemId  = $itemId
            Slot    = 2
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
        Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -ParameterFilter { $Uri -like '*/update' } -MockWith {
            [PSCustomObject] @{ success = $true; id = '0123456789abcdef0123456789abcdef' }
        }
        Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -ParameterFilter { $Uri -like '*/oauth2/token' } -MockWith {
            [PSCustomObject] @{ access_token = $slot2Key; expires_in = 259139 }
        }
    }
    Context -Name 'normal usage' -Fixture {
        It -Name 'returns the key as a SecureString with its slot and expiration' -Test {
            $result = New-PortalApiKey -Expiration (Get-Date).AddDays(3) @commonParams
            $result.ApiKey | Should -BeOfType [System.Security.SecureString]
            $result.Expires | Should -BeOfType [System.DateTime]
            $result.Slot | Should -Be 2
        }
        It -Name 'sets the slot expiration in epoch milliseconds before generating' -Test {
            $expiration = (Get-Date).AddDays(3)
            $expectedMs = [System.DateTimeOffset]::new($expiration).ToUnixTimeMilliseconds()
            New-PortalApiKey -Expiration $expiration @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 1 -Exactly -ParameterFilter {
                $Uri -like '*/content/users/jsmith/items/*/update' -and $Body['apiToken2ExpirationDate'] -eq $expectedMs
            }
        }
        It -Name 'requests a token for the requested slot' -Test {
            New-PortalApiKey -Expiration (Get-Date).AddDays(3) @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 1 -Exactly -ParameterFilter {
                $Uri -like '*/oauth2/token' -and $Body['apiToken'] -eq 2 -and $Body['regenerateApiToken'] -eq 'true'
            }
        }
        It -Name 'does not output the plain key or the client secret' -Test {
            $result = New-PortalApiKey -Expiration (Get-Date).AddDays(3) @commonParams
            $json = $result | ConvertTo-Json -Depth 5
            $json | Should -Not -Match $secret
            $json | Should -Not -Match $slot2Key
        }
        It -Name 'keeps certificate checking on when SkipCertificateCheck is explicitly false' -Test {
            New-PortalApiKey -Expiration (Get-Date).AddDays(3) -SkipCertificateCheck:$false @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 2 -Exactly -ParameterFilter {
                -not $PesterBoundParameters.ContainsKey('SkipCertificateCheck')
            }
        }
    }
    Context -Name 'parameter validation' -Fixture {
        It -Name 'rejects a past expiration without making requests' -Test {
            { New-PortalApiKey -Expiration (Get-Date).AddDays(-1) @commonParams } | Should -Throw -ExpectedMessage '*future*'
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 0 -Exactly
        }
        It -Name 'rejects an expiration more than one year out' -Test {
            { New-PortalApiKey -Expiration (Get-Date).AddYears(1).AddDays(1) @commonParams } | Should -Throw -ExpectedMessage '*one year*'
        }
        It -Name 'rejects a slot other than 1 or 2' -Test {
            $badParams = $commonParams.Clone()
            $badParams['Slot'] = 3
            { New-PortalApiKey -Expiration (Get-Date).AddDays(3) @badParams } | Should -Throw
        }
    }
    Context -Name 'WhatIf' -Fixture {
        It -Name 'makes no changes' -Test {
            New-PortalApiKey -Expiration (Get-Date).AddDays(3) -WhatIf @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 0 -Exactly
        }
    }
    Context -Name 'error handling' -Fixture {
        It -Name 'rejects a key returned for a different slot' -Test {
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -ParameterFilter { $Uri -like '*/oauth2/token' } -MockWith {
                [PSCustomObject] @{ access_token = 'AAPT' + ('x' * 238) + '1' + ('y' * 9); expires_in = 259139 }
            }
            { New-PortalApiKey -Expiration (Get-Date).AddDays(3) @commonParams } | Should -Throw -ExpectedMessage '*did not return a key for slot 2*'
        }
        It -Name 'reports a failed expiration update without generating a key' -Test {
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -ParameterFilter { $Uri -like '*/update' } -MockWith {
                [PSCustomObject] @{ error = [PSCustomObject] @{ code = 403; message = 'You do not have permissions' } }
            }
            { New-PortalApiKey -Expiration (Get-Date).AddDays(3) @commonParams } | Should -Throw -ExpectedMessage '*403*'
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 0 -Exactly -ParameterFilter { $Uri -like '*/oauth2/token' }
        }
    }
    Context -Name 'failed regeneration of an active slot' -Fixture {
        BeforeAll {
            $previousMs = 1893456000000
            $previousExpires = [System.DateTimeOffset]::FromUnixTimeMilliseconds($previousMs).DateTime.ToLocalTime()
            Mock -CommandName Get-PortalApiKeyCredential -ModuleName $env:BHProjectName -MockWith {
                [PSCustomObject] @{ ItemId = '0123456789abcdef0123456789abcdef'; Title = 'test key'; Owner = 'jsmith'; Slot1Active = $false; Slot2Active = $true; Slot2Expires = $previousExpires }
            }
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -ParameterFilter { $Uri -like '*/oauth2/token' } -MockWith {
                [PSCustomObject] @{ error = [PSCustomObject] @{ code = 400; message = 'Invalid request' } }
            }
        }
        It -Name 'restores the previous expiration and reports the original error' -Test {
            { New-PortalApiKey -Expiration (Get-Date).AddDays(3) @commonParams } | Should -Throw -ExpectedMessage '*Unable to generate*400*'
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 1 -Exactly -ParameterFilter {
                $Uri -like '*/update' -and $Body['apiToken2ExpirationDate'] -eq $previousMs
            }
        }
        It -Name 'warns and still reports the original error when the restore fails' -Test {
            Mock -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -ParameterFilter { $Uri -like '*/update' -and $Body['apiToken2ExpirationDate'] -eq $previousMs } -MockWith {
                [PSCustomObject] @{ error = [PSCustomObject] @{ code = 500; message = 'Server error' } }
            }
            Mock -CommandName Write-Warning -ModuleName $env:BHProjectName
            { New-PortalApiKey -Expiration (Get-Date).AddDays(3) @commonParams } | Should -Throw -ExpectedMessage '*Unable to generate*400*'
            Should -Invoke -CommandName Write-Warning -ModuleName $env:BHProjectName -Times 1 -Exactly -ParameterFilter { $Message -like '*Unable to restore*500*' }
        }
        It -Name 'does not restore an inactive slot' -Test {
            $slot1Params = $commonParams.Clone()
            $slot1Params['Slot'] = 1
            { New-PortalApiKey -Expiration (Get-Date).AddDays(3) @slot1Params } | Should -Throw
            Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 1 -Exactly -ParameterFilter { $Uri -like '*/update' }
        }
    }
}

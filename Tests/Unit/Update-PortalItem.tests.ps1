[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
param()

BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }
}

Describe -Name 'Update-PortalItem' -Fixture {
    BeforeAll {
        $commonParams = @{
            ItemId  = '0123456789abcdef0123456789abcdef'
            Title   = 'TestTitle'
            Context = [System.Uri]::new('https://portal.example.com/arcgis')
            Token   = 'testTokenValue123'
            Confirm = $false
        }
        Mock -CommandName Invoke-RestMethod -MockWith {
            [PSCustomObject] @{ success = $true; id = '0123456789abcdef0123456789abcdef' }
        } -ModuleName $env:BHProjectName
    }
    Context -Name 'token associated with a user' -Fixture {
        BeforeAll {
            Mock -CommandName Get-PortalSetting -MockWith {
                [PSCustomObject] @{ user = [PSCustomObject] @{ username = 'jdoe' } }
            } -ModuleName $env:BHProjectName
        }
        It -Name 'uses the token user in the request URI when UserName is omitted' -Test {
            Update-PortalItem @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName -ParameterFilter {
                $Uri -like '*/sharing/rest/content/users/jdoe/items/*/update'
            }
        }
        It -Name 'does not look up the user when UserName is provided' -Test {
            Update-PortalItem @commonParams -UserName 'owner1'
            Should -Invoke -CommandName Get-PortalSetting -Times 0 -Exactly -ModuleName $env:BHProjectName
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName -ParameterFilter {
                $Uri -like '*/content/users/owner1/items/*'
            }
        }
        It -Name 'keeps certificate checking on for the user lookup by default' -Test {
            Update-PortalItem @commonParams
            Should -Invoke -CommandName Get-PortalSetting -Times 1 -Exactly -ModuleName $env:BHProjectName -ParameterFilter {
                -not $PesterBoundParameters.ContainsKey('SkipCertificateCheck')
            }
        }
        It -Name 'skips certificate checking for the user lookup only when requested' -Test {
            Update-PortalItem @commonParams -SkipCertificateCheck
            Should -Invoke -CommandName Get-PortalSetting -Times 1 -Exactly -ModuleName $env:BHProjectName -ParameterFilter {
                $SkipCertificateCheck -eq $true
            }
        }
    }
    Context -Name 'token not associated with a user (API key)' -Fixture {
        BeforeAll {
            Mock -CommandName Get-PortalSetting -MockWith {
                [PSCustomObject] @{ appInfo = [PSCustomObject] @{ appId = 'abc' } }
            } -ModuleName $env:BHProjectName
        }
        It -Name 'rejects the call and asks for UserName' -Test {
            { Update-PortalItem @commonParams } | Should -Throw -ExpectedMessage '*Specify -UserName*'
        }
        It -Name 'does not send the update request' -Test {
            { Update-PortalItem @commonParams } | Should -Throw
            Should -Invoke -CommandName Invoke-RestMethod -Times 0 -Exactly -ModuleName $env:BHProjectName
        }
        It -Name 'succeeds when UserName is provided' -Test {
            { Update-PortalItem @commonParams -UserName 'owner1' } | Should -Not -Throw
        }
    }
    Context -Name 'error handling' -Fixture {
        It -Name 'reports an error returned in the Portal response body' -Test {
            Mock -CommandName Get-PortalSetting -MockWith {
                [PSCustomObject] @{ error = [PSCustomObject] @{ code = 498; message = 'Invalid token.' } }
            } -ModuleName $env:BHProjectName
            { Update-PortalItem @commonParams } | Should -Throw -ExpectedMessage '*Unable to get user info*Invalid token.*'
        }
        It -Name 'reports a failed user lookup' -Test {
            Mock -CommandName Get-PortalSetting -MockWith {
                Write-Error -Message 'connection refused' -ErrorAction Stop
            } -ModuleName $env:BHProjectName
            { Update-PortalItem @commonParams } | Should -Throw -ExpectedMessage '*Unable to get user info*connection refused*'
        }
    }
}

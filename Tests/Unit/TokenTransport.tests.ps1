[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
param()

# Issue #138: GET requests send the token in the X-Esri-Authorization header, never in the URL or body.
BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }

    $hex = '0123456789abcdef0123456789abcdef'
    $headerFunctions = @(
        @{ Name = 'Get-PortalCategorySchema'; Params = @{} }
        @{ Name = 'Get-PortalDataStoreServer'; Params = @{ ItemId = $hex } }
        @{ Name = 'Get-PortalDefaultUserSetting'; Params = @{} }
        @{ Name = 'Get-PortalGroup'; Params = @{ GroupID = $hex } }
        @{ Name = 'Get-PortalGroupContent'; Params = @{ GroupID = $hex } }
        @{ Name = 'Get-PortalGroupItemJobStatus'; Params = @{ JobId = $hex } }
        @{ Name = 'Get-PortalGroupUserList'; Params = @{ GroupID = $hex } }
        @{ Name = 'Get-PortalItem'; Params = @{ ItemId = $hex } }
        @{ Name = 'Get-PortalItemData'; Params = @{ ItemId = $hex } }
        @{ Name = 'Get-PortalItemGroupList'; Params = @{ ItemId = $hex } }
        @{ Name = 'Get-PortalJobStatus'; Params = @{ JobId = "j$hex"; ItemId = $hex } }
        @{ Name = 'Get-PortalLivingAtlasUpdate'; Params = @{} }
        @{ Name = 'Get-PortalOIDC'; Params = @{ ConfigId = 'config1' } }
        @{ Name = 'Get-PortalOIDCList'; Params = @{} }
        @{ Name = 'Get-PortalRoleList'; Params = @{} }
        @{ Name = 'Get-PortalSecurityPolicy'; Params = @{} }
        @{ Name = 'Get-PortalSetting'; Params = @{} }
        @{ Name = 'Get-PortalUser'; Params = @{ Username = 'jdoe' } }
        @{ Name = 'Get-PortalUserFolderList'; Params = @{} }
        @{ Name = 'Get-PortalUserGroupList'; Params = @{} }
        @{ Name = 'Get-PortalUserItemList'; Params = @{} }
        @{ Name = 'Get-PortalUserList'; Params = @{} }
        @{ Name = 'Get-ServerHostedFeatureService'; Params = @{ ServiceName = 'Svc' } }
        @{ Name = 'Get-ServerServiceLayer'; Params = @{ ServiceName = 'Svc'; ServiceType = 'FeatureServer'; LayerId = 0 } }
        @{ Name = 'Get-ServerServiceLayerAttachment'; Params = @{ ServiceName = 'Svc'; LayerId = 0; GlobalId = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee' } }
        @{ Name = 'Test-ServerHealth'; Params = @{} }
    )
    $optionalTokenFunctions = $headerFunctions | Where-Object { $_.Name -in 'Get-ServerServiceLayer', 'Get-ServerServiceLayerAttachment', 'Test-ServerHealth' }
}

Describe -Name 'Token transport for GET requests' -Fixture {
    BeforeAll {
        $token = 'testTokenValue123'
        $context = [System.Uri]::new('https://portal.example.com/arcgis')
        # One response shape that satisfies every function's paging and lookup logic.
        $response = {
            [PSCustomObject] @{
                id = '0123456789ABCDEF'; user = [PSCustomObject] @{ username = 'jdoe' }
                total = 0; nextStart = -1; start = 1; num = 0
                results = @(); users = @(); groups = @(); items = @(); folders = @(); roles = @()
            }
        }
        Mock -CommandName Invoke-RestMethod -MockWith $response -ModuleName $env:BHProjectName
        Mock -CommandName Invoke-WebRequest -MockWith $response -ModuleName $env:BHProjectName
        $tokenInUrlOrBody = {
            "$Uri" -match $token -or ($Body -is [System.Collections.IDictionary] -and @($Body.Values) -contains $token)
        }
    }
    It -Name '<Name> sends the token in the X-Esri-Authorization header' -ForEach $headerFunctions -Test {
        & $Name @Params -Context $context -Token $token -WarningAction SilentlyContinue | Out-Null
        Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -ParameterFilter {
            $Headers -and $Headers['X-Esri-Authorization'] -ceq "Bearer $token"
        }
    }
    It -Name '<Name> never puts the token in the URL or body' -ForEach $headerFunctions -Test {
        & $Name @Params -Context $context -Token $token -WarningAction SilentlyContinue | Out-Null
        Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 0 -Exactly -ParameterFilter $tokenInUrlOrBody
        Should -Invoke -CommandName Invoke-WebRequest -ModuleName $env:BHProjectName -Times 0 -Exactly -ParameterFilter $tokenInUrlOrBody
    }
    It -Name '<Name> sends no authorization header without -Token' -ForEach $optionalTokenFunctions -Test {
        & $Name @Params -Context $context -WarningAction SilentlyContinue | Out-Null
        Should -Invoke -CommandName Invoke-RestMethod -ModuleName $env:BHProjectName -Times 0 -Exactly -ParameterFilter {
            $Headers -and $Headers.Contains('X-Esri-Authorization')
        }
    }
}

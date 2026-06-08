BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }
}

Describe -Name 'Get-ServerLog' -Fixture {

    BeforeAll {
        $singlePageResponse = [PSCustomObject] @{
            logMessages = @(
                [PSCustomObject] @{ type = 'WARNING'; message = 'entry 1' }
                [PSCustomObject] @{ type = 'SEVERE';  message = 'entry 2' }
            )
            hasMore   = $false
            nextStart = $null
        }

        $page1Response = [PSCustomObject] @{
            logMessages = @(
                [PSCustomObject] @{ type = 'WARNING'; message = 'page1 entry 1' }
            )
            hasMore   = $true
            nextStart = 1748995200000
        }

        $page2Response = [PSCustomObject] @{
            logMessages = @(
                [PSCustomObject] @{ type = 'SEVERE'; message = 'page2 entry 1' }
            )
            hasMore   = $false
            nextStart = $null
        }

        $errorResponse = [PSCustomObject] @{
            error = [PSCustomObject] @{ code = 499; message = 'Token Required' }
        }

        $commonParams = @{
            Context = [System.Uri]::new('https://server.example.com/arcgis')
            Token   = 'testTokenValue123'
        }
    }

    Context -Name 'single-page response' -Fixture {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith { $singlePageResponse } -ModuleName $env:BHProjectName
        }

        It -Name 'returns all log entries from the page' -Test {
            $result = Get-ServerLog @commonParams
            $result | Should -HaveCount 2
        }

        It -Name 'does not make a second request' -Test {
            Get-ServerLog @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName
        }
    }

    Context -Name 'multi-page response' -Fixture {
        BeforeAll {
            # Default mock returns page 1 (hasMore = $true)
            Mock -CommandName Invoke-RestMethod -MockWith { $page1Response } -ModuleName $env:BHProjectName
            # ParameterFilter mock returns page 2 when startTime has been set by the loop
            Mock -CommandName Invoke-RestMethod -MockWith { $page2Response } -ModuleName $env:BHProjectName `
                -ParameterFilter { $null -ne $Body['startTime'] }
        }

        It -Name 'returns entries from all pages' -Test {
            $result = Get-ServerLog @commonParams
            $result | Should -HaveCount 2
        }

        It -Name 'makes two requests for a two-page result set' -Test {
            Get-ServerLog @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -Times 2 -Exactly -ModuleName $env:BHProjectName
        }

        It -Name 'passes nextStart as startTime on the second request' -Test {
            Get-ServerLog @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName `
                -ParameterFilter { $Body['startTime'] -eq 1748995200000 }
        }
    }

    Context -Name 'optional parameters' -Fixture {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith { $singlePageResponse } -ModuleName $env:BHProjectName
        }

        It -Name 'omits startTime from body when StartTime is not provided' -Test {
            Get-ServerLog @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName `
                -ParameterFilter { $null -eq $Body['startTime'] }
        }

        It -Name 'omits endTime from body when EndTime is not provided' -Test {
            Get-ServerLog @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName `
                -ParameterFilter { $null -eq $Body['endTime'] }
        }

        It -Name 'accepts PageSize below 1000' -Test {
            { Get-ServerLog @commonParams -PageSize 100 } | Should -Not -Throw
        }
    }

    Context -Name 'error response' -Fixture {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith { $errorResponse } -ModuleName $env:BHProjectName
        }

        It -Name 'returns the error response object' -Test {
            $result = Get-ServerLog @commonParams
            $result.error | Should -Not -BeNullOrEmpty
        }

        It -Name 'does not make a second request on error' -Test {
            Get-ServerLog @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName
        }
    }
}

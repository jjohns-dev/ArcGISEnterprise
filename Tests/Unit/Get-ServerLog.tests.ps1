[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
param()

BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }
}

Describe -Name 'Get-ServerLog' -Fixture {

    BeforeAll {
        $singlePageResponse = [PSCustomObject] @{
            logMessages = @(
                [PSCustomObject] @{ type = 'WARNING'; message = 'entry 1'; time = 300 }
                [PSCustomObject] @{ type = 'SEVERE';  message = 'entry 2'; time = 200 }
            )
            hasMore   = $false
            startTime = 300
            endTime   = 200
        }

        # Server paginates by time: the response 'endTime' (Unix milliseconds) is the oldest
        # record in the page and becomes the next request's 'startTime'. The bound is inclusive,
        # so page 2 repeats page 1's last (boundary) record, which the function drops.
        $page1Response = [PSCustomObject] @{
            logMessages = @(
                [PSCustomObject] @{ type = 'WARNING'; message = 'page1 entry 1'; time = 300 }
                [PSCustomObject] @{ type = 'INFO';    message = 'page1 entry 2'; time = 200 }
            )
            hasMore   = $true
            startTime = 300
            endTime   = 200
        }

        $page2Response = [PSCustomObject] @{
            logMessages = @(
                [PSCustomObject] @{ type = 'INFO';   message = 'page1 entry 2'; time = 200 }
                [PSCustomObject] @{ type = 'SEVERE'; message = 'page2 entry 1'; time = 100 }
            )
            hasMore   = $false
            startTime = 200
            endTime   = 100
        }

        $errorResponse = [PSCustomObject] @{
            error = [PSCustomObject] @{ code = 499; message = 'Token Required' }
        }

        # A page that reports more records but whose endTime equals the previous page's cursor:
        # more than PageSize records share one millisecond, so the time window cannot advance.
        $stalledResponse = [PSCustomObject] @{
            logMessages = @(
                [PSCustomObject] @{ type = 'WARNING'; message = 'dense 1'; time = 200 }
                [PSCustomObject] @{ type = 'INFO';    message = 'dense 2'; time = 200 }
            )
            hasMore   = $true
            startTime = 200
            endTime   = 200
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
            # Default mock returns page 1 (hasMore = $true, endTime = 200)
            Mock -CommandName Invoke-RestMethod -MockWith { $page1Response } -ModuleName $env:BHProjectName
            # When the loop sets startTime to the page 1 cursor (200), return the final page
            Mock -CommandName Invoke-RestMethod -MockWith { $page2Response } -ModuleName $env:BHProjectName `
                -ParameterFilter { $Body['startTime'] -eq 200 }
        }

        It -Name 'returns entries from all pages' -Test {
            $result = Get-ServerLog @commonParams
            $result | Should -HaveCount 3
        }

        It -Name 'drops the duplicate boundary record between pages' -Test {
            $result = Get-ServerLog @commonParams
            @($result.time | Select-Object -Unique) | Should -HaveCount 3
        }

        It -Name 'makes two requests for a two-page result set' -Test {
            Get-ServerLog @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -Times 2 -Exactly -ModuleName $env:BHProjectName
        }

        It -Name 'uses the response endTime as the next startTime' -Test {
            Get-ServerLog @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName `
                -ParameterFilter { $Body['startTime'] -eq 200 }
        }
    }

    Context -Name 'request body' -Fixture {
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

        It -Name 'sends StartTime as epoch milliseconds when provided' -Test {
            $start = [System.DateTime]::new(2026, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc)
            $expected = [System.DateTimeOffset]::new($start).ToUnixTimeMilliseconds()
            Get-ServerLog @commonParams -StartTime $start
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ModuleName $env:BHProjectName `
                -ParameterFilter { $Body['startTime'] -eq $expected }
        }

        It -Name 'rejects PageSize below the 1000 minimum' -Test {
            { Get-ServerLog @commonParams -PageSize 100 } | Should -Throw
        }

        It -Name 'accepts PageSize at the 1000 minimum' -Test {
            { Get-ServerLog @commonParams -PageSize 1000 } | Should -Not -Throw
        }
    }

    Context -Name 'non-advancing window' -Fixture {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith { $stalledResponse } -ModuleName $env:BHProjectName
            Mock -CommandName Write-Warning -ModuleName $env:BHProjectName
        }

        It -Name 'stops paging once the window stops advancing' -Test {
            Get-ServerLog @commonParams
            Should -Invoke -CommandName Invoke-RestMethod -Times 2 -Exactly -ModuleName $env:BHProjectName
        }

        It -Name 'warns that the result is truncated' -Test {
            Get-ServerLog @commonParams
            Should -Invoke -CommandName Write-Warning -Times 1 -Exactly -ModuleName $env:BHProjectName
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

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Variables set in Pester BeforeAll are used in It blocks.')]
param()

BeforeDiscovery {
    if (-not (Get-Module -Name $env:BHProjectName)) {
        Import-Module -Name $env:BHPSModuleManifest -ErrorAction Stop -Force
    }
}

Describe -Name 'Get-ServerServiceReport' -Fixture {
    Context -Name 'a layer whose data query fails' -Fixture {
        BeforeAll {
            $m = @{ ModuleName = $env:BHProjectName }
            Mock @m -CommandName Get-ServerServiceList -MockWith {
                [PSCustomObject] @{ folders = @(); services = @([PSCustomObject] @{ name = 'Svc'; type = 'FeatureServer' }) }
            }
            Mock @m -CommandName Get-ServerService -MockWith {
                [PSCustomObject] @{ layers = @([PSCustomObject] @{ id = 0; name = 'NoObjectId' }, [PSCustomObject] @{ id = 1; name = 'Ok' }) }
            }
            Mock @m -CommandName Get-ServerServiceLayer -MockWith { [PSCustomObject] @{ name = "L$LayerId"; HasAttachments = $true } }
            Mock @m -CommandName Get-ServerServiceLayerData -ParameterFilter { $LayerId -eq 0 } -MockWith {
                Write-Error -Message "Query failed for [Svc] layer [0]: 500 Field name 'objectid' does not exist." -ErrorAction Stop
            }
            Mock @m -CommandName Get-ServerServiceLayerData -ParameterFilter { $LayerId -eq 1 } -MockWith {
                [PSCustomObject] @{ features = @([PSCustomObject] @{ attributes = [PSCustomObject] @{ objectid = 7 } }) }
            }
            Mock @m -CommandName Get-ServerServiceLayerAttachment -MockWith {
                [PSCustomObject] @{ attachmentGroups = @([PSCustomObject] @{ attachmentInfos = @([PSCustomObject] @{ id = 1; name = 'a.png'; contentType = 'image/png'; size = 10 }) }) }
            }

            $reportErrors = $null
            $report = Get-ServerServiceReport -Context 'https://server.example.com/arcgis' -Token 'testTokenValue123' -ErrorVariable reportErrors 2>$null
        }
        It -Name 'still returns the report' -Test {
            $report | Should -Not -BeNullOrEmpty
            @($report.Layers).Count | Should -Be 2
        }
        It -Name 'records the failing layer as a non-terminating error' -Test {
            @($reportErrors | Where-Object { "$_" -like '*Unable to get data for layer `[Svc/NoObjectId`]*' }).Count | Should -Be 1
        }
        It -Name 'continues to the next layer and collects its attachments' -Test {
            Should -Invoke @m -CommandName Get-ServerServiceLayerAttachment -Times 1 -Exactly -Scope Context -ParameterFilter { $LayerId -eq 1 }
            @($report.Attachments).Count | Should -Be 1
        }
    }
}

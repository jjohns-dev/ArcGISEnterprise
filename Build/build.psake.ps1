# PSake makes variables declared here available in other scriptblocks
# Require psake v5 (5.0.0 introduced the two-phase compile/run model, Inputs/Outputs
# caching, and the structured PsakeBuildResult that this build relies on).
Version 5

Properties {
    $ProjectRoot = $env:BHProjectPath
    if (-not $ProjectRoot) {
        $ProjectRoot = $PSScriptRoot
    }

    $Timestamp = Get-Date -UFormat '%Y%m%d-%H%M%S'
    $lines = '----------------------------------------------------------------------'

    # Pester
    $TestScripts = Get-ChildItem "$ProjectRoot/Tests/*/*Tests.ps1"
    $TestFile = "Test-Unit_$($TimeStamp).xml"

    # Script Analyzer
    [ValidateSet('Error', 'Warning', 'Any', 'None')]
    $ScriptAnalysisFailBuildOnSeverityLevel = 'Error'
    $ScriptAnalyzerSettingsPath = "$ProjectRoot/Build/PSScriptAnalyzerSettings.psd1"

    # Build
    $ArtifactFolder = Join-Path -Path $ProjectRoot -ChildPath 'Artifacts'

    # Staging
    $StagingFolder = Join-Path -Path $ProjectRoot -ChildPath 'Staging'
    $StagingModulePath = Join-Path -Path $StagingFolder -ChildPath $env:BHProjectName
    #$StagingModulePath = Join-Path -Path $StagingFolder -ChildPath $ProjectName
    $StagingModuleManifestPath = Join-Path -Path $StagingModulePath -ChildPath "$($env:BHProjectName).psd1"
    #$StagingModuleManifestPath = Join-Path -Path $StagingModulePath -ChildPath "$($ProjectName).psd1"
}

# Define top-level tasks
Task 'Default' -depends 'Test'

# Show build variables
Task 'Init' {
    $lines

    Set-Location $ProjectRoot
    'Build System Details:'
    Get-Item ENV:BH*
    "`n"
}

# Setup the Artifact and Staging folders
Task 'Setup' -depends 'Init' {
    $lines

    $foldersToSetup = @(
        $ArtifactFolder
        $StagingFolder
    )

    # Remove folders
    foreach ($folderPath in $foldersToSetup) {
        Remove-Item -Path $folderPath -Recurse -Force -ErrorAction 'SilentlyContinue'
        New-Item -Path $folderPath -ItemType 'Directory' -Force | Out-String | Write-Verbose
    }
}

# Create a single .psm1 module file containing all functions
# Copy new module and other supporting files (Documentation / Examples) to Staging folder
Task 'CombineFunctionsAndStage' -depends 'Setup' {
    $lines

    # Create folders
    New-Item -Path $StagingFolder -ItemType 'Directory' -Force | Out-String | Write-Verbose
    New-Item -Path $StagingModulePath -ItemType 'Directory' -Force | Out-String | Write-Verbose

    # Get public and private function files
    #$publicFunctions = @( Get-ChildItem -Path "$env:BHModulePath\Public\*.ps1" -Recurse -ErrorAction 'SilentlyContinue' )
    #$privateFunctions = @( Get-ChildItem -Path "$env:BHModulePath\Private\*.ps1" -Recurse -ErrorAction 'SilentlyContinue' )

    # Combine functions into a single .psm1 module
    #$combinedModulePath = Join-Path -Path $StagingModulePath -ChildPath "$($env:BHProjectName).psm1"
    #@($publicFunctions + $privateFunctions) | Get-Content | Add-Content -Path $combinedModulePath

    # Copy other required folders and files
    $pathsToCopy = @(
        Join-Path -Path $ProjectRoot -ChildPath 'Private'
        Join-Path -Path $ProjectRoot -ChildPath 'Public'
        Join-Path -Path $ProjectRoot -ChildPath 'Documentation'
        Join-Path -Path $ProjectRoot -ChildPath 'README.md'
        Join-Path -Path $ProjectRoot -ChildPath ($env:BHProjectName + '.psd1')
        Join-Path -Path $ProjectRoot -ChildPath ($env:BHProjectName + '.psm1')
    )
    Copy-Item -Path $pathsToCopy -Destination $StagingModulePath -Recurse

    # Copy existing manifest
    #Copy-Item -Path $env:BHPSModuleManifest -Destination $StagingModulePath -Recurse
}

# Import new module
Task 'ImportStagingModule' -depends 'Init', 'CombineFunctionsAndStage' {
    $lines
    Write-Output "Reloading staged module from path: [$StagingModulePath]`n"

    # Reload module
    if (Get-Module -Name $env:BHProjectName) { Remove-Module -Name $env:BHProjectName -Force }
    Import-Module -Name $StagingModulePath -ErrorAction 'Stop' -Force
}

# Run PSScriptAnalyzer against code to ensure quality and best practices are used
Task 'Analyze' -depends 'ImportStagingModule' {
    $lines
    Write-Output "Running PSScriptAnalyzer on path: [$StagingModulePath]`n"

    $Results = Invoke-ScriptAnalyzer -Path $StagingModulePath -Recurse -Settings $ScriptAnalyzerSettingsPath -Verbose:$VerbosePreference
    $Results | Select-Object 'RuleName', 'Severity', 'ScriptName', 'Line', 'Message' | Format-List

    switch ($ScriptAnalysisFailBuildOnSeverityLevel) {
        'None' {
            return
        }
        'Error' {
            Assert -conditionToCheck (
                ($Results | Where-Object 'Severity' -EQ 'Error').Count -eq 0
            ) -failureMessage 'One or more ScriptAnalyzer errors were found. Build cannot continue!'
        }
        'Warning' {
            Assert -conditionToCheck (
                ($Results | Where-Object {
                    $_.Severity -eq 'Warning' -or $_.Severity -eq 'Error'
                }).Count -eq 0) -failureMessage 'One or more ScriptAnalyzer warnings were found. Build cannot continue!'
        }
        default {
            Assert -conditionToCheck ($analysisResult.Count -eq 0) -failureMessage 'One or more ScriptAnalyzer issues were found. Build cannot continue!'
        }
    }
}

# Run Pester tests
# Unit tests: verify inputs / outputs / expected execution path
# Misc tests: verify manifest data, check comment-based help exists
Task 'Test' -depends 'ImportStagingModule' {
    $lines

    # Gather test results. Store them in a variable and file
    $TestFilePath = Join-Path -Path $ArtifactFolder -ChildPath $TestFile

    # create a new configuration with our settings
    # JUnitXml (not NUnitXML) is required for dorny/test-reporter compatibility in CI;
    # the reporter's NUnit parser trips on Pester's NUnit 2.5 output.
    $PesterConfig = New-PesterConfiguration
    $PesterConfig.TestResult.OutputFormat = 'JUnitXml'
    $PesterConfig.TestResult.OutputPath = $TestFilePath
    $PesterConfig.TestResult.Enabled = $true
    $PesterConfig.Run.PassThru = $true
    $PesterConfig.Run.Path = $TestScripts
    #$PesterConfig.Output.Verbosity = 'Diagnostic'

    $TestResults = Invoke-Pester -Configuration $PesterConfig

    #$TestResults = Invoke-Pester -Script $TestScripts -PassThru -OutputFormat 'NUnitXml' -OutputFile $TestFilePath -PesterOption @{IncludeVSCodeMarker = $true }

    # Fail build if any tests fail
    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
}

# Create a versioned zip file of all staged files
# NOTE: Admin Rights are needed if you run this locally
Task 'CreateBuildArtifact' -depends 'Init' {
    $lines

    # Create /Release folder
    New-Item -Path $ArtifactFolder -ItemType 'Directory' -Force | Out-String | Write-Verbose

    # Get current manifest version
    try {
        $manifest = Test-ModuleManifest -Path $StagingModuleManifestPath -ErrorAction 'Stop'
        [Version]$manifestVersion = $manifest.Version

    }
    catch {
        throw "Could not get manifest version from [$StagingModuleManifestPath]"
    }

    # Create zip file
    try {
        $releaseFilename = "$($env:BHProjectName)-v$($manifestVersion.ToString()).zip"
        $releasePath = Join-Path -Path $ArtifactFolder -ChildPath $releaseFilename
        Write-Output "Creating release artifact [$releasePath] using manifest version [$manifestVersion]"
        Compress-Archive -Path "$StagingFolder/*" -DestinationPath $releasePath -Force -Verbose -ErrorAction 'Stop'
    }
    catch {
        throw "Could not create release artifact [$releasePath] using manifest version [$manifestVersion]"
    }

    Write-Output "`nFINISHED: Release artifact creation."
}

# cleanup dirs and files when finished
Task 'Cleanup' {
    $lines

    Write-Output 'Cleaning leftover/unneeded artifacts'

    # cleanup
    Remove-Item -Path $ArtifactFolder -Recurse -Force -ErrorAction 'SilentlyContinue'
    Remove-Item -Path $StagingFolder -Recurse -Force -ErrorAction 'SilentlyContinue'
}

# Regenerate per-function markdown help in $ProjectRoot/Documentation from the
# comment-based help in Public/*.ps1, using Microsoft.PowerShell.PlatyPS (v2).
#
# Dev-run only -- intentionally NOT included in the Default task or CI workflows.
# Run manually after any change to a public function's parameter signature or
# comment-based help:
#
#     .\Build\build.ps1 -TaskList GenerateDocs
#
# Operates on the SOURCE Documentation/ folder, not the staged copy, so the
# regenerated files are committed alongside the .ps1 changes.
Task 'GenerateDocs' -depends 'ImportStagingModule' {
    $lines

    # Verify Microsoft.PowerShell.PlatyPS is available (declared in Build/depend.psd1)
    if (-not (Get-Module -Name 'Microsoft.PowerShell.PlatyPS' -ListAvailable)) {
        Write-Error -Message "Microsoft.PowerShell.PlatyPS is not installed. Run: .\Build\build.ps1 -ResolveDependency" -ErrorAction Stop
    }
    Import-Module -Name 'Microsoft.PowerShell.PlatyPS' -Force

    $docPath = Join-Path -Path $ProjectRoot -ChildPath 'Documentation'
    if (-not (Test-Path -Path $docPath)) {
        New-Item -Path $docPath -ItemType 'Directory' -Force | Out-Null
    }

    $moduleInfo = Get-Module -Name $env:BHProjectName
    if (-not $moduleInfo) {
        Write-Error -Message "Module '$env:BHProjectName' is not loaded; ImportStagingModule should have loaded it." -ErrorAction Stop
    }

    # Always regenerate from scratch. Microsoft.PowerShell.PlatyPS 1.0.1's
    # `Update-MarkdownCommandHelp` has known bugs on repeat runs (doesn't
    # refresh `## NOTES` from comment-based help; duplicates `## DESCRIPTION`
    # and `### -<Param>` blocks in some files). A clean delete-and-regen via
    # `New-MarkdownCommandHelp` is reliable and the file count is small enough
    # (~130 files) that the cost is negligible.
    Write-Output "Generating Documentation/ from scratch using Microsoft.PowerShell.PlatyPS..."

    # Remove existing per-function pages (preserve index.md / Index.md, which
    # is hand-curated -- see Documentation/index.md).
    Get-ChildItem -Path $docPath -Filter '*.md' |
        Where-Object { $_.Name -ne 'index.md' -and $_.Name -ne 'Index.md' } |
        Remove-Item -Force

    # New-MarkdownCommandHelp ALWAYS writes to a $OutputFolder/$ModuleName/ subfolder.
    # Generate there, then flatten the files up into $docPath so existing relative
    # links (README, index.md) continue to work without rewrites.
    $newParams = @{
        ModuleInfo   = $moduleInfo
        OutputFolder = $docPath
        Force        = $true
    }
    New-MarkdownCommandHelp @newParams | Out-Null

    $nestedFolder = Join-Path -Path $docPath -ChildPath $env:BHProjectName
    if (Test-Path -Path $nestedFolder) {
        Get-ChildItem -Path $nestedFolder -Filter '*.md' |
            ForEach-Object { Move-Item -Path $_.FullName -Destination $docPath -Force }
        Remove-Item -Path $nestedFolder -Recurse -Force
    }

    # Populate the `## ALIASES` section from each function's `[Alias()]`
    # attribute. PlatyPS v2 1.0.1 ignores `[Alias()]` and instead writes a
    # `{{Insert list of aliases}}` placeholder under `## ALIASES` for every
    # cmdlet, so post-process every generated page:
    #   - if the function has aliases, replace the placeholder with a bullet
    #     list of the alias names;
    #   - if the function has no aliases, strip the placeholder so the
    #     section stays empty rather than leaving the template text in place.
    $utf8NoBom    = [System.Text.UTF8Encoding]::new($false)
    $aliasPattern = '(?ms)(^## ALIASES\r?\n)(.*?)(\r?\n## )'
    foreach ($cmd in $moduleInfo.ExportedFunctions.Values) {
        $mdPath = Join-Path -Path $docPath -ChildPath ('{0}.md' -f $cmd.Name)
        if (-not (Test-Path -Path $mdPath)) { continue }

        $aliasAttr = $cmd.ScriptBlock.Attributes |
            Where-Object { $_ -is [System.Management.Automation.AliasAttribute] }

        if ($aliasAttr) {
            $aliasBlock = (($aliasAttr.AliasNames | Sort-Object) | ForEach-Object { "- $_" }) -join [Environment]::NewLine
            $replacement = '$1' + [Environment]::NewLine + $aliasBlock + [Environment]::NewLine + '$3'
        }
        else {
            # Empty section: just a blank line between the heading and the next ##.
            $replacement = '$1$3'
        }

        $content = [System.IO.File]::ReadAllText($mdPath)
        $new     = [Regex]::Replace($content, $aliasPattern, $replacement)

        if ($new -ne $content) {
            [System.IO.File]::WriteAllText($mdPath, $new, $utf8NoBom)
        }
    }

    $generated = Get-ChildItem -Path $docPath -Filter '*.md' |
        Where-Object { $_.Name -ne 'index.md' -and $_.Name -ne 'Index.md' }
    Write-Output ("Documentation regenerated: {0} command-help file(s) under [{1}]" -f $generated.Count, $docPath)
}

# AGENTS.md

Guidance for AI agents working in `ArcGISEnterprise`. [.github/copilot-instructions.md](.github/copilot-instructions.md) also loads every session and covers always chaining `Cleanup` and why live ArcGIS behavior beats the REST docs; neither is repeated here.

## What this repo is

PowerShell 7.4+ module wrapping the ArcGIS Enterprise Portal, Server and GeoEvent REST APIs. Usage and auth: [README.md](README.md). Function template and `.NOTES Status:` values: [CONTRIBUTING.md](CONTRIBUTING.md).

## Layout

| Path | Holds |
| ---- | ----- |
| `Public/` | One file per exported function, `Verb-<Portal\|Server\|GeoEvent>Noun.ps1` |
| `Private/` | Non-exported helpers and `*.template` request bodies |
| `Tests/Common/` | Help, Manifest and Meta suites over every exported command |
| `Tests/Unit/` | `<Function>.tests.ps1` |
| `Build/` | `build.ps1` entry point, psake tasks, pinned `depend.psd1` |
| `Documentation/` | PlatyPS-generated pages; only `index.md` is hand-edited |

## Validating a change

From pwsh at the repo root; each was run and passed 2026-11-16 (pwsh 7.7.0, macOS):

| Command | Result |
| ------- | ------ |
| `./Build/build.ps1 -ResolveDependency -TaskList Init` | Installs the pins (CI's first step) |
| `./Build/build.ps1 -TaskList Analyze, Cleanup` | Fails only on Error-severity findings |
| `./Build/build.ps1 -TaskList Test, Cleanup` | 1881 tests, about 5 s |
| `./Build/build.ps1 -TaskList CombineFunctionsAndStage, CreateBuildArtifact, Cleanup` | `Artifacts/ArcGISEnterprise-v<ModuleVersion>.zip` |

Pins in `Build/depend.psd1`: Pester 6.2.0, psake 5.0.4, PSScriptAnalyzer 1.24.0, Microsoft.PowerShell.PlatyPS 1.0.1. `build.ps1` does not import by version, so locally the highest installed copy wins: Analyze loaded PSScriptAnalyzer 1.25.0 with 1.24.0 also installed.

## CI

`validate.yml` (PRs, pushes to `main`) and `release.yml` (`v*.*.*` tags) call `PS-MCS/mcssec-ops`'s `ps-module-validate.yml` / `ps-module-release.yml` **`@main`**, so a merge there changes this repo's CI immediately. Validate runs `Init`, `CombineFunctionsAndStage`, `Analyze`, `Test` on `ubuntu-latest`, then fails when executed tests (JUnit root `tests` minus `disabled`) fall below `min-tests`. When the suite changes size, recompute the floor with the formula in the comment beside it.

It does **not**:

- run on Windows;
- run `GenerateDocs`, so stale `Documentation/` is not caught;
- block merges: the `org_protect` ruleset requires no status checks;
- on release, enforce `min-tests` or check the tag against `ModuleVersion`.

## Conventions

- Branches `<type>/<slug>`: `feature/`, `fix/`, `test/`, `build/`, `chore/`, `docs/`.
- Squash-merge only, with 1 code-owner approval and resolved threads (`org_protect`). The PR title becomes the commit subject: `<type>(<scope>): <title>`, and GitHub appends `(#PR)`.
- Bump `ModuleVersion` in `ArcGISEnterprise.psd1` only for shipped-code changes; `test:`/`ci:`/`build:` PRs do not (#145, #146). The `Version:` header in `ArcGISEnterprise.psm1` is stale; ignore it.
- After changing a public signature or its help, run `./Build/build.ps1 -TaskList GenerateDocs` and commit the pages with the change.

## Gotchas that have bitten here

- **A psake `Properties` variable used only by a release task can vanish unnoticed.** The psake 5 bump dropped `$StagingModuleManifestPath` and the v2.3.0 release failed (#125). After touching `build.psake.ps1`, run the artifact command above.
- **The test gate is `$TestResults.Result -ne 'Passed'`, not `FailedCount`**: discovery errors leave `FailedCount` at 0. Do not "simplify" it.
- **`Tests/Common/Help.Tests.ps1` is a fleet-shared template**, kept diffable with PS-MCS/MCS (#152). Do not edit it as a side effect. It passes command *names* to `-ForEach`; a CommandInfo renames every test to `...FunctionInfo{Name='Foo'} help` (#152).
- **`FunctionsToExport` is hand-maintained and untested.** It lists `Format-ServerServiceMetadata` and `Format-ServerServiceLayerMetadata`, which do not exist. The Help suite enumerates exported commands only, so a `Public/` function left off the list is neither exported nor tested.

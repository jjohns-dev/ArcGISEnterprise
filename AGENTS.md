# AGENTS.md

Guidance for AI agents working in `ArcGISEnterprise`. [.github/copilot-instructions.md](.github/copilot-instructions.md) also loads every session and covers always chaining `Cleanup` and why live ArcGIS behavior beats the REST docs; neither is repeated here.

## What this repo is

PowerShell 7.4+ module wrapping the ArcGIS Enterprise Portal, Server and GeoEvent REST APIs. Usage and auth: [README.md](README.md). Function template and `.NOTES Status:` values: [CONTRIBUTING.md](CONTRIBUTING.md).

## Runtimes

Production (AWS Lambda) and CI run pwsh 7.6 (.NET 10); development is often 7.7 (.NET 11). Changes must behave the same on both: avoid numeric conversions whose results changed in .NET 11 (e.g. `[decimal]38.8` is `38.799999999999997157829056960` on 7.7).

## Layout

| Path | Holds |
| ---- | ----- |
| `Public/` | One file per exported function, `Verb-<Portal\|Server\|GeoEvent>Noun.ps1` |
| `Private/` | Non-exported helpers and `*.template` request bodies |
| `Tests/Common/` | Help, Manifest and Meta suites over every exported command |
| `Tests/Unit/` | `<Function>.tests.ps1`; `TokenTransport.tests.ps1` covers token transport for every GET function |
| `Build/` | `build.ps1` entry point, psake tasks, pinned `depend.psd1` |
| `docs/` | Hand-maintained `api-endpoints.md` (function → REST endpoint) and `specs/` |

## Validating a change

From pwsh at the repo root; each was run and passed 2026-11-16 (pwsh 7.7.0, macOS), test count as of 2026-11-17:

| Command | Result |
| ------- | ------ |
| `./Build/build.ps1 -ResolveDependency -TaskList Init` | Installs the pins (CI's first step) |
| `./Build/build.ps1 -TaskList Analyze, Cleanup` | Fails only on Error-severity findings |
| `./Build/build.ps1 -TaskList Test, Cleanup` | 2086 tests, about 5 s |
| `./Build/build.ps1 -TaskList CombineFunctionsAndStage, CreateBuildArtifact, Cleanup` | `Artifacts/ArcGISEnterprise-v<ModuleVersion>.zip` |

From zsh or bash, chain tasks through `pwsh -Command "./Build/build.ps1 -TaskList Test,Cleanup"`; `pwsh -File` passes `Test,` as one string and fails the `ValidateSet`.

Pins in `Build/depend.psd1`: Pester 6.2.0, psake 5.0.4, PSScriptAnalyzer 1.24.0. `build.ps1` does not import by version, so locally the highest installed copy wins: Analyze loaded PSScriptAnalyzer 1.25.0 with 1.24.0 also installed.

Live verification: `sharing/rest` and `rest/services` endpoints can be tested from outside the network; `/portaladmin` and Server `/admin` are WAF-blocked externally and need an internal tunnel. Never print tokens, or URLs containing them, in test output.

## CI

`validate.yml` (PRs, pushes to `main`) and `release.yml` (`v*.*.*` tags) call `PS-MCS/mcssec-ops`'s `ps-module-validate.yml` / `ps-module-release.yml` **`@main`**, so a merge there changes this repo's CI immediately. Validate runs `Init`, `CombineFunctionsAndStage`, `Analyze`, `Test` on `ubuntu-latest`, then fails when executed tests (JUnit root `tests` minus `disabled`) fall below `min-tests`. When the suite changes size, recompute the floor with the formula in the comment beside it.

It does **not**:

- run on Windows;
- block merges: the `org_protect` ruleset requires no status checks;
- on release, enforce `min-tests` or check the tag against `ModuleVersion`.

## Conventions

- Branches `<type>/<slug>`: `feature/`, `fix/`, `test/`, `build/`, `chore/`, `docs/`.
- Squash-merge only, with 1 code-owner approval and resolved threads (`org_protect`). The PR title becomes the commit subject: `<type>(<scope>): <title>`, and GitHub appends `(#PR)`.
- Bump `ModuleVersion` in `ArcGISEnterprise.psd1` only for shipped-code changes; `test:`/`ci:`/`build:` PRs do not (#145, #146). The `Version:` header in `ArcGISEnterprise.psm1` is stale; ignore it.
- Release notes are generated from PR labels by `.github/release.yml`: label every PR with its category (`bug`, `security`, `docs`, `ci`, ...) and label version-bump PRs `ignore-for-release` so they don't appear as changes.
- When adding a public function or changing the endpoint one calls, update its row in `docs/api-endpoints.md`; nothing generates or checks it.
- GET requests send the token as `Headers = @{ 'X-Esri-Authorization' = 'Bearer {0}' -f $Token }`, never in `Body`: a GET body becomes the URL query string, which proxies and logs record (#138). A header named `token` is ignored (verified on `sharing/rest` and `rest/services`). If `-Token` is optional, add the header only when it is passed.
- Multi-entry `Headers` hashtables list one entry per line; single-entry ones stay on one line.
- Never write a token to the verbose, debug or information streams. When logging request data or `$PSBoundParameters`, pass it through the private `ConvertTo-RedactedHashtable`, which replaces `token`, `password` and `client_secret` values with `[redacted]` (#171).

## Gotchas that have bitten here

- **A psake `Properties` variable used only by a release task can vanish unnoticed.** The psake 5 bump dropped `$StagingModuleManifestPath` and the v2.3.0 release failed (#125). After touching `build.psake.ps1`, run the artifact command above.
- **The test gate is `$TestResults.Result -ne 'Passed'`, not `FailedCount`**: discovery errors leave `FailedCount` at 0. Do not "simplify" it.
- **`Tests/Common/Help.Tests.ps1` is a fleet-shared template**, kept diffable with PS-MCS/MCS (#152). Do not edit it as a side effect. It passes command *names* to `-ForEach`; a CommandInfo renames every test to `...FunctionInfo{Name='Foo'} help` (#152).
- **`FunctionsToExport` is hand-maintained and untested.** It lists `Format-ServerServiceMetadata` and `Format-ServerServiceLayerMetadata`, which do not exist. The Help suite enumerates exported commands only, so a `Public/` function left off the list is neither exported nor tested.
- **ArcGIS returns HTTP 200 with an `error` body** (400/403/498/499/500), so `Invoke-RestMethod` doesn't throw. Check `.error` on a single object: on an array of 2+ objects, `$list.error` is an array of `$null`s and is truthy.
- **Server `/admin` uses a different error body:** `{"status":"error","code":498,...}`, not `{"error":{...}}`, so a `.error` check misses it. `sharing/rest`, `rest/services` and `/portaladmin` use `{"error":{...}}` (#138).
- **`.psobject.Properties` doesn't see hashtable keys.** Validate input shape with `($_ -is [System.Collections.IDictionary] -and $_.Contains('k')) -or $_.psobject.Properties.Name -contains 'k'` (#142).

# AGENTS.md

Guidance for AI agents working in `ArcGISEnterprise`. [.github/copilot-instructions.md](.github/copilot-instructions.md) also loads every session and covers always chaining `Cleanup` and why live ArcGIS behavior beats the REST docs; neither is repeated here.

## What this repo is

PowerShell 7.6+ module wrapping the ArcGIS Enterprise Portal, Server and GeoEvent REST APIs. Usage and auth: [README.md](README.md). Function template and `.NOTES Status:` values: [CONTRIBUTING.md](CONTRIBUTING.md).

## Runtimes

Production (AWS Lambda) and CI run pwsh 7.6 (.NET 10); development is often 7.7 (.NET 11). Changes must behave the same on both: avoid numeric conversions whose results changed in .NET 11 (e.g. `[decimal]38.8` is `38.799999999999997157829056960` on 7.7).

## Layout

| Path | Holds |
| ---- | ----- |
| `Public/` | One file per exported function, `Verb-<Portal\|Server\|GeoEvent>Noun.ps1`; helpers that work only on local data and call no endpoint (e.g. `ConvertFrom-Epoch`, `Format-CsvHeader`, `New-TableSchemaObject`) have no prefix |
| `Private/` | Non-exported helpers and `*.template` request bodies |
| `Tests/Unit/` | `<Function>.tests.ps1`; `TokenTransport.tests.ps1` covers token transport for every GET function |
| `Build/` | Only `build.ps1`, the [pwsh-module-ci](https://github.com/jjohns-dev/pwsh-module-ci) shim. Do not edit it; it must stay byte-identical to the template |
| `docs/` | Hand-maintained `api-endpoints.md` (function → REST endpoint) and `specs/` |

## Validating a change

From pwsh at the repo root. The shim reads the `@v2` pin from `.github/workflows/ci.yml`, fetches that harness into a shared cache (needs `git` and network access) and runs it against this repo; tasks and properties are in pwsh-module-ci's [consumer guide](https://github.com/jjohns-dev/pwsh-module-ci/blob/main/docs/consumer-guide.md). Run and passed 2026-11-18 (pwsh 7.7.0, macOS):

| Command | Result |
| ------- | ------ |
| `./Build/build.ps1 -ResolveDependency -TaskList Init` | Installs the harness's pinned build tools |
| `./Build/build.ps1 -TaskList Analyze, Cleanup` | Fails only on Error-severity findings |
| `./Build/build.ps1 -TaskList Test, Cleanup` | 953 tests, about 5 s |
| `./Build/build.ps1 -TaskList CombineFunctionsAndStage, CreateBuildArtifact, Cleanup` | `Artifacts/ArcGISEnterprise-v<ModuleVersion>.zip` |

From zsh or bash, chain tasks through `pwsh -Command "./Build/build.ps1 -TaskList Test,Cleanup"`; `pwsh -File` passes `Test,` as one string and fails the `ValidateSet`.

`Test` runs `Tests/Unit` and then the harness's shared help, manifest, meta and path-literal suites (`15 + 5n` tests for `n` public functions). They require a `.SYNOPSIS`, `.DESCRIPTION`, `.EXAMPLE` and a `.PARAMETER` for exactly the declared parameters on every public function, and `FunctionsToExport` equal to the `Public/*.ps1` names. Analyzer exclusions go inline as `SuppressMessageAttribute` with a justification; there is no repo-wide settings file.

Live verification: `sharing/rest` and `rest/services` endpoints can be tested from outside the network; `/portaladmin` and Server `/admin` are reachable only from inside it, so test those from an internal host. Never print tokens, or URLs containing them, in test output.

## CI

`ci.yml` (PRs, pushes to `main`), `release.yml` (PRs as a dry run, `v*.*.*` tags to publish) and `pssa-sarif.yml` (PRs, pushes to `main`) call the matching workflows in `jjohns-dev/pwsh-module-ci` at the moving **`@v2`** tag, so a new `v2.x.y` there changes this repo's CI without a commit here. `ci.yml` runs on `ubuntu-latest` only and fails when executed tests (JUnit root `tests` minus `disabled`) fall below `min-tests`. When the suite changes size, recompute the floor with the formula in the comment beside it.

It does **not**:

- run on Windows;
- on release, enforce `min-tests` or check the tag against `ModuleVersion`.

## Conventions

- Branches `<type>/<slug>`: `feature/`, `fix/`, `test/`, `build/`, `chore/`, `docs/`.
- Squash-merge only, with code-owner review, resolved threads and signed commits (the `protect` ruleset). The squash commit subject is `<type>(<scope>): <title> (#PR)`. Pass it explicitly with `gh pr merge --subject`: the repo's `COMMIT_OR_PR_TITLE` setting defaults a single-commit PR to its commit's title rather than the PR title.
- Bump `ModuleVersion` in `ArcGISEnterprise.psd1` only for shipped-code changes; `test:`/`ci:`/`build:` PRs do not (#145, #146). The `Version:` header in `ArcGISEnterprise.psm1` is stale; ignore it.
- Release notes are generated from PR labels by `.github/release.yml`: label every PR with its category (`bug`, `security`, `docs`, `ci`, ...) and label version-bump PRs `ignore-for-release` so they don't appear as changes.
- When adding a public function or changing the endpoint one calls, update its row in `docs/api-endpoints.md`; nothing generates or checks it.
- GET requests send the token as `Headers = @{ 'X-Esri-Authorization' = 'Bearer {0}' -f $Token }`, never in `Body`: a GET body becomes the URL query string, which proxies and logs record (#138). A header named `token` is ignored (verified on `sharing/rest` and `rest/services`). If `-Token` is optional, add the header only when it is passed.
- Multi-entry `Headers` hashtables list one entry per line; single-entry ones stay on one line.
- Never write a token to the verbose, debug or information streams. When logging request data or `$PSBoundParameters`, pass it through the private `ConvertTo-RedactedHashtable`, which replaces `token`, `password` and `client_secret` values with `[redacted]` (#171).

## Gotchas that have bitten here

- **`FunctionsToExport` is hand-maintained.** Add every new `Public/` function to it; the shared manifest suite fails when the list and `Public/*.ps1` differ.
- **ArcGIS returns HTTP 200 with an `error` body** (400/403/498/499/500), so `Invoke-RestMethod` doesn't throw. Check `.error` on a single object: on an array of 2+ objects, `$list.error` is an array of `$null`s and is truthy.
- **Server `/admin` uses a different error body:** `{"status":"error","code":498,...}`, not `{"error":{...}}`, so a `.error` check misses it. `sharing/rest`, `rest/services` and `/portaladmin` use `{"error":{...}}` (#138).
- **`.psobject.Properties` doesn't see hashtable keys.** Validate input shape with `($_ -is [System.Collections.IDictionary] -and $_.Contains('k')) -or $_.psobject.Properties.Name -contains 'k'` (#142).

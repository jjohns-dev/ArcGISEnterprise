# Contributing Guide

- For minor fixes such as a typo, a simple pull request is all that's needed. For more involved changes, please follow the process laid out below.
- :heavy_exclamation_mark: Focus on updating a single function/cmdlet in a Pull Request to make the review processes simpler for the core team.

To propose changes to the existing functions or the creation of a new one, the process is as follows:

1. Open a new [issue](https://github.com/PS-MCS/ArcGISEnterprise/issues/new/choose) describing the proposed addition or change.
2. Once the issue has been discussed and approved:
    1. Clone this repository.
    2. Create a new branch (`feature/<slug>` for additions, `fix/<slug>` for fixes).
    3. Either:
        - Add a new function under [`Public/`](Public) following the structure in the [Style Guide](#style-guide) below.
        - Modify the target function in case of an update or refactor.
    4. Submit your [Pull Request](https://help.github.com/articles/creating-a-pull-request/) and reference the issue (`refs #N` in commits, `closes #N` in the PR body).

## Style Guide

### Content

Functions in this module wrap the ArcGIS Enterprise REST APIs using only built-in PowerShell. There should be no dependency on outside libraries.

### Structure

Use this general structure for new functions:

```pwsh
function <Verb>-<Noun> {
    <#
    .SYNOPSIS
        One-line summary
    .DESCRIPTION
        Longer description
    .PARAMETER <Name>
        Description for each parameter
    .INPUTS
        None. (or pipeline input type)
    .OUTPUTS
        System.Object. (or specific output type)
    .EXAMPLE
        PS C:\> <Verb>-<Noun> -Context $ctx -Token $tok
        What the example does
    .NOTES
        Status: Stable
        Comments:
        https://link-to-api-docs (if applicable)
    #>

    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param()
}
```

#### Rules

- Use only [approved PowerShell verbs](https://learn.microsoft.com/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands) when naming functions.
- The `<Noun>` portion should start with the ArcGIS Enterprise component the function targets: `Portal`, `Server`, `GeoEvent`. Example: `Get-PortalUser`, `Set-ServerAllowedOrigin`.
- Every function must include complete comment-based help (`.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER` for each parameter, `.INPUTS`, `.OUTPUTS`, at least one `.EXAMPLE`, and `.NOTES`).
- Prefer splat tables (`$params = @{...}; Invoke-Cmd @params`) over backtick line continuations.
- Use `Write-Error -Message '...' -ErrorAction Stop` instead of `throw` for terminating errors, including inside `ValidateScript` blocks.

#### `.NOTES` section

The `.NOTES` block uses two fields:

- **`Status:`** — a single token indicating maturity of the function. See [allowed values](#status-values) below.
- **`Comments:`** — optional free-form text. Typically a link to the official API endpoint the function wraps, plus any caveats.

##### Status values

| Value | Meaning |
| ----- | ------- |
| `Stable` | Production-ready. Signature is unlikely to change. Fully tested against a live endpoint. Default for new functions once they're proven. |
| `Beta` | Feature-complete but not yet hardened in production use. Signature may still change in a minor release. |
| `Experimental` | Prototype or early implementation. Expect breaking changes. May be removed without deprecation. |
| `Deprecated` | Still works but slated for removal in a future major version. The `Comments:` field must point to the replacement (or explain why none exists). |
| `Untested` | Code is present but the wrapped endpoint has not been exercised against a live ArcGIS Enterprise instance. Use with caution. |
| `Internal` | Exposed publicly for tooling or advanced use only. Not part of the supported surface. Backwards-compatibility is not guaranteed. |

If you're adding a function, default to `Beta` unless you've exercised it end-to-end against a real endpoint, in which case use `Stable`.

## How to get started contributing

1. Install [Visual Studio Code](https://code.visualstudio.com/).
2. Clone the repo and open it in VS Code.
3. (Optional) If you have Docker installed, open the Command Palette and run "Dev Containers: Reopen in Container" to develop inside the pre-configured [dev container](.devcontainer).
4. You are ready to contribute :+1:

### Before pushing

1. Run the analyzer and tests:

    ```pwsh
    ./Build/build.ps1 -ResolveDependency -TaskList Analyze
    ./Build/build.ps1 -ResolveDependency -TaskList Test
    ```

2. Clean up the build output before committing:

    ```pwsh
    ./Build/build.ps1 -TaskList Cleanup
    ```

    :heavy_exclamation_mark: Do not commit the `Staging/` or `Artifacts/` directories.

When you add a public function or change the endpoint it calls, update its row in [`docs/api-endpoints.md`](docs/api-endpoints.md).

## Commit and PR conventions

- **Commit subject**: `<type>(<scope>): <title> (refs #N)` — e.g., `feat(Public): add Get-PortalThing (refs #42)`.
  - `<type>`: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `ci`.
  - `<scope>`: short area name (`Public`, `Private`, `Build`, `ci`, `docs`).
- **Commit body**: multi-paragraph rationale — what changed, why, user-visible impact. No marketing language.
- **PR title**: same as commit subject but with `(closes #N)` so the issue auto-closes on merge.
- **PR body**: include `Closes #N.`, a summary, a changes list, and a validation checklist.

## Release

This project automates module releases via GitHub Actions. See [`.github/workflows/release.yml`](.github/workflows/release.yml).

To cut a new release:

1. Bump `ModuleVersion` in [`ArcGISEnterprise.psd1`](ArcGISEnterprise.psd1). Follow the SemVer policy documented in the manifest comment (major = major changes / breaking; minor = new individual functions; patch = bug fixes).
2. Merge the change to `main`.
3. Tag the merge commit with `vMAJOR.MINOR.PATCH` and push the tag. The release workflow will build, test, package, and publish a GitHub Release with auto-generated notes (grouped by the labels defined in [`.github/release.yml`](.github/release.yml)).

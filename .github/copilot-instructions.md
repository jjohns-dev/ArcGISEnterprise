# ArcGISEnterprise — Repository Instructions

## Build and tests

Run tests through the `Build/build.ps1` shim, which runs the shared pwsh-module-ci
build harness, and always chain the `Cleanup` task so the generated `Artifacts` and
`Staging` folders are removed from the working tree afterward:

```powershell
./Build/build.ps1 -TaskList Test, Cleanup
```

`Cleanup` deletes `Artifacts/` and `Staging/`. Running `Test` alone leaves the staged
module behind, which can later cause "multiple modules named 'ArcGISEnterprise' are
loaded" errors and clutters the working tree.

## ArcGIS Enterprise REST API: testing wins over documentation

The official ArcGIS Enterprise REST API documentation (developers.arcgis.com — the
URLs typically linked in each function's `.NOTES` block) is **frequently wrong or
misleading**: required parameters, filter shapes, time formats, pagination cursors,
and response structures are often documented incorrectly.

**Never treat the documentation as authoritative.** When the docs and observed
behavior disagree, observed behavior wins. When implementing, debugging, or
reviewing any function that calls an ArcGIS Enterprise REST endpoint
(`Invoke-RestMethod` / `Invoke-WebRequest` against portaladmin, server admin,
sharing/rest, or services):

- Verify the actual request/response contract against a live ArcGIS Enterprise
  system before implementing or "fixing" it. Capture what you observe; don't infer
  it from the docs.
- If you cannot test live, state that the contract is unverified rather than
  asserting the documented behavior is correct.
- A function that already works against a live system encodes the *real* contract,
  even when the code looks odd. Treat such code as load-bearing — prove what it does
  live before changing it, and when adding a feature don't "tidy" the working
  request/response handling.
- Watch for undocumented quirks: required-but-"optional" keys (whose omission
  silently returns zero results), sentinel values (e.g. an empty string meaning
  "use default"), and endpoint-specific pagination with inclusive bounds that
  produce duplicate boundary records.

Endpoint-specific contracts confirmed by live testing are recorded in agent repo
memory (`/memories/repo/arcgis-enterprise.md`); consult and extend it as new
contracts are verified.

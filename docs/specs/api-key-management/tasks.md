# API key management: tasks

Each task lists the check that proves it is done. Tasks are ordered so the build stays green after each one.

## Private helper

- [x] **1. `Private/Get-PortalRegisteredAppInfo.ps1`.** POSTs `content/users/{owner}/items/{id}/registeredAppInfo`, returns the raw response, and turns an ArcGIS `error` body into a terminating error.
  - Verify: `Invoke-ScriptAnalyzer` shows 0 findings; the parse check passes.

## Get-PortalApiKeyCredential

- [x] **2. `Public/Get-PortalApiKeyCredential.ps1`.** Single-item mode (with `-ItemId`) per the design: type and keyword check, owner from `-UserName` or the item, flat output with `ConvertFrom-Epoch` dates and `$null` for inactive slots, no `client_secret`. Add it to `FunctionsToExport`.
- [x] **3. List mode** (no `-ItemId`): resolve `-UserName` with `Resolve-PortalUserName`, call `Find-PortalItem -Owner -Type 'Application'`, keep items whose `typeKeywords` contain `APIToken`, return one object per item.
- [x] **4. `Tests/Unit/Get-PortalApiKeyCredential.tests.ps1`**, covering:
  - active slot returns a `DateTime`; inactive slot with a stale value returns `$null`;
  - a non-`APIToken` item raises an error;
  - list mode filters to `APIToken` items;
  - no output property, and no serialized output, contains the mocked `client_secret`.
  - Verify: tests pass. Mutation check: remove the `$null`-when-inactive rule and the inactive-slot test fails.

## New-PortalApiKey

- [x] **5. `Public/New-PortalApiKey.ps1`** per the design:
  - check the expiration date first;
  - `ShouldProcess` with `ConfirmImpact = 'High'`;
  - set `apiToken{N}ExpirationDate`, then call `oauth2/token`;
  - check the slot digit;
  - return `ApiKey` as a `SecureString`;
  - a `Clean` block removes the plain-text values.

  Add it to `FunctionsToExport`.
- [x] **6. `Tests/Unit/New-PortalApiKey.tests.ps1`**, covering:
  - past dates and dates more than a year out are rejected with no requests made;
  - `-WhatIf` makes no update or token requests;
  - the update request carries the expected epoch ms value;
  - a slot-digit mismatch raises an error;
  - `ApiKey` is a `SecureString`, `Expires` is a `DateTime`, and the output contains neither the plain key nor `client_secret`.
  - Verify: tests pass. Mutation check: remove the slot-digit check and its test fails.

## Revoke-PortalApiKey

- [x] **7. `Public/Revoke-PortalApiKey.ps1`** per the design: inactive slot gives a warning and no request; otherwise `ShouldProcess` and then `oauth2/revokeToken`; an error if `success` is not `true`. Add it to `FunctionsToExport`.
- [x] **8. `Tests/Unit/Revoke-PortalApiKey.tests.ps1`**, covering:
  - an inactive slot sends no revoke request;
  - `-WhatIf` sends no request;
  - a `success: false` response raises an error;
  - pipeline input from `Get-PortalApiKeyCredential` binds `ItemId`.
  - Verify: tests pass.

## Docs and release

- [x] **9. `ModuleVersion` 2.3.1 to 2.4.0.**
  - Verify: the Manifest tests pass, and the file still has no BOM.
- [x] **10. Generate the three `Documentation/*.md` pages** with `./Build/build.ps1 -TaskList GenerateDocs`, and add the function-to-endpoint rows in `Documentation/index.md`.
  - Verify: `git status` shows only the three new pages plus `index.md`, and no other pages changed.
- [x] **11. README:** a short rotation example under "Use an API key".
  - Verify: markdownlint shows 0 findings.
- [x] **12. Full suite:** `./Build/build.ps1 -TaskList Test, Cleanup`.
  - Verify: the result is Passed, the test count went up by the number of new tests plus the new help tests, and PSScriptAnalyzer has 0 findings on the new files.

## Live verification (11.5 test portal, `ags_module_test_api_key` only)

- [x] **13. `Get-PortalApiKeyCredential`:**
  - by item ID (`faa4…`) and in list mode for `portaladmin`;
  - as an admin, for `jjohns@esri.com`.
  - Verify: the slots and expiration dates match the earlier probes, and no secret appears in the output.
- [x] **14. `New-PortalApiKey -Slot 2 -Expiration (Get-Date).AddDays(3)`, then a `portals/self` call with the returned key, then `Revoke-PortalApiKey -Slot 2`.**
  - Verify: the key authenticates before revoking and gets `498` after; the slot 1 key still authenticates at the end.

## Wrap-up

- [x] **15. Commit (signed) after each section; push; open the PR** with the same reviewers.
  - Verify: CI `validate` passes.

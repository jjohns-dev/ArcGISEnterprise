# API key management: requirements

## Problem

API keys (ArcGIS Enterprise 11.4+) are long-lived tokens managed through an API key credentials item. Rotating them today is a manual, portal-UI task. Operators rotate by hand and from AWS Lambda, so the module needs functions to read key status and expiration, generate a key in a slot, and invalidate a slot, without ever exposing secrets.

## User stories

- As an operator, I want to see which key slots are active and when they expire, so that I know when to rotate.
- As an operator, I want to generate a key in a specific slot with a chosen expiration, so that I can deploy it before retiring the old key.
- As an operator, I want to invalidate a slot, so that a retired or leaked key stops working immediately.
- As an automation author (Lambda), I want the new key returned as a `SecureString` with its slot and expiration, so that I can store it in Secrets Manager without it appearing in logs.

## Acceptance criteria

### Get-PortalApiKeyCredential

- WHEN given an API key credentials item ID, THE SYSTEM SHALL return one object with the item ID, title, owner, client ID, privileges, HTTP referrers, and per-slot `Active` and `Expires` values.
- WHEN no item ID is given, THE SYSTEM SHALL return one such object for every API key credentials item owned by `-UserName`.
- THE SYSTEM SHALL return `Expires` as a `System.DateTime`, and `$null` when the slot is not active (the portal keeps stale expirations on inactive slots).
- THE SYSTEM SHALL NOT include `client_secret` (or any key value) in output, verbose, or error messages.
- WHEN the item is not an API key credentials item (`type` = `Application` with type keyword `APIToken`), THE SYSTEM SHALL write a terminating error.

### New-PortalApiKey

- WHEN given an item ID, a slot (1 or 2), and an expiration `System.DateTime`, THE SYSTEM SHALL set that slot's expiration on the item and then generate a key in that slot.
- THE SYSTEM SHALL require the expiration, reject past dates, and reject dates more than one year out.
- THE SYSTEM SHALL return an object with `ItemId`, `Slot`, `Expires` (`System.DateTime`), and `ApiKey` (`System.Security.SecureString`).
- WHEN the target slot is already active, THE SYSTEM SHALL require confirmation (`ConfirmImpact = 'High'`), because regenerating invalidates the existing key in that slot.
- THE SYSTEM SHALL support `-WhatIf` and make no changes when it is used.

### Revoke-PortalApiKey

- WHEN given an item ID and a slot, THE SYSTEM SHALL invalidate the key in that slot.
- THE SYSTEM SHALL require confirmation (`ConfirmImpact = 'High'`) and support `-WhatIf`.
- WHEN the slot is not active, THE SYSTEM SHALL write a warning and make no request.

### All three

- THE SYSTEM SHALL accept `-Context`, `-Token`, and `-SkipCertificateCheck` consistent with other `*-Portal*` functions.
- WHEN an item ID is given, THE SYSTEM SHALL use the item owner for credential lookups. `-UserName` exists only on `Get-PortalApiKeyCredential`, to choose whose credentials to list.
- THE SYSTEM SHALL surface ArcGIS errors returned in a response body as terminating errors that do not contain secrets.

## Out of scope

- Creating API key credentials items, or changing their privileges, item access, or referrers (manual, per your decision).
- A single "rotate" command; rotation is generate, deploy, then revoke.
- Writing keys to SecretManagement or AWS Secrets Manager.
- Legacy (pre-June 2024) API keys.

## Open questions

None.

## Resolved

- Listing: with no item ID, `Get-PortalApiKeyCredential` returns all API key credentials for the user (approved 2026-10-21).
- Admin management: verified live on 11.5 (2026-10-21). A `portaladmin` token read, listed, set the expiration on, generated, and revoked a key for credentials owned by another user. The Lambda can run as a service account.

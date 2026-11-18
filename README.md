# ArcGISEnterprise

[![ci](https://github.com/jjohns-dev/ArcGISEnterprise/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/jjohns-dev/ArcGISEnterprise/actions/workflows/ci.yml)
[![release](https://github.com/jjohns-dev/ArcGISEnterprise/actions/workflows/release.yml/badge.svg)](https://github.com/jjohns-dev/ArcGISEnterprise/actions/workflows/release.yml)
[![PowerShell](https://img.shields.io/badge/PowerShell-7.6%2B-5391FE?logo=powershell&logoColor=white)](https://learn.microsoft.com/powershell/scripting/install/installing-powershell)

PowerShell 7 module for ArcGIS Enterprise REST APIs. Includes functions for
both ArcGIS Server and Portal for ArcGIS.

## Install

Download the latest `.zip` from [Releases](https://github.com/jjohns-dev/ArcGISEnterprise/releases/latest) and extract `ArcGISEnterprise/` into a folder on your `$env:PSModulePath`. On Windows, files downloaded from the internet are blocked, and the module is unsigned, so it must be unblocked (`Unblock-File`) before it will load. Unblocking is your decision and your risk. Then:

```powershell
Import-Module ArcGISEnterprise
```

## Authentication

Every function that calls a secured endpoint needs two things: a `-Context` (the
Portal or Server URI including its context, e.g. `https://arcgis.example.com/arcgis`)
and a `-Token`. Either generate a token from a username and password, or use an API
key, then choose how you want to pass the context and token to subsequent calls.

### 1. Generate a token

Provide credentials and request a token. The token functions return a response
object; the token string itself is on the `.token` property. Pass the context and
token to any function:

```powershell
$context = [System.Uri]'https://arcgis.example.com/arcgis'
$cred    = Get-Credential   # prompts for username and password

# Portal token (default expiration is 60 minutes)
$token = (Get-PortalToken -Context $context -Credential $cred).token

# ArcGIS Server token (add -Admin for the Server admin endpoint)
$token = (Get-ServerToken -Context $context -Credential $cred -Admin).token

# Call any function with the context and token
Get-PortalSetting -Context $context -Token $token
```

When Server and Data Store are federated to Portal, Portal manages authentication,
so a Portal token is accepted by the federated Server and Data Store endpoints.

### 1b. Use an API key

On ArcGIS Enterprise 11.4 and later, an [API key](https://developers.arcgis.com/documentation/security-and-authentication/api-key-authentication/)
can be passed to `-Token` in place of a generated token. What the key can access is
determined by the privileges and item access configured on its API key credentials.

```powershell
$apiKey = Get-Secret -Name 'arcgis_api_key' -AsPlainText
Set-PortalConnection -Context $context -Token $apiKey
```

Confirmed on ArcGIS Enterprise 11.5: reading and updating Portal items, and reading
hosted feature service information. An API key is not tied to a user, so functions
with a `-UserName` parameter require it to be passed explicitly.

To rotate a key, generate one in the free slot, deploy it, then revoke the old slot.
The key-management functions (`Get-PortalApiKeyCredential`, `New-PortalApiKey` and
`Revoke-PortalApiKey`) have been tested with a token for the credentials owner or an
administrator.

```powershell
$conn = @{ Context = $context; Token = $token }
Get-PortalApiKeyCredential -ItemId $itemId @conn
$newKey = New-PortalApiKey -ItemId $itemId -Slot 2 -Expiration (Get-Date).AddDays(90) @conn
# Deploy $newKey.ApiKey (a SecureString), then retire slot 1
Revoke-PortalApiKey -ItemId $itemId -Slot 1 @conn
```

### 2a. Pass `-Context` and `-Token` explicitly (splatting)

Keep the connection values in a hashtable and splat them into each call. This is
explicit and works well when you talk to more than one environment in the same
session.

```powershell
$conn = @{
    Context = $context
    Token   = $token
}

Get-PortalSetting  @conn
Get-PortalUserList @conn
```

### 2b. Set a default connection for the session

`Set-PortalConnection` and `Set-ServerConnection` register the context and token as
default parameter values (via `$PSDefaultParameterValues`) for the rest of the
session, so you can omit `-Context` and `-Token` on subsequent calls.

```powershell
# Applies to *-Portal* functions
Set-PortalConnection -Context $context -Token $token
Get-PortalSetting
Get-PortalUserList

# Applies to *-Server* functions
Set-ServerConnection -Context $context -Token $token
Get-ServerLog
```

The defaults live in the current PowerShell session only. Open a new session, or
clear `$PSDefaultParameterValues`, to remove them.

## Function naming

All functions follow the PowerShell `Verb-Noun` convention. The `Noun` portion
starts with the ArcGIS Enterprise component the function targets: `Portal`,
`Server`, or `GeoEvent`. For example, pass an ArcGIS Server URI to the
`-Context` parameter of `Set-ServerAllowedOrigin` to update the allowed-origins
property on Server.

## Documentation

- Per-function help: `Get-Help <Function-Name> -Full`, generated from each function's comment-based help.
- Function-to-API-endpoint mapping and root-directory reference: [`docs/api-endpoints.md`](docs/api-endpoints.md)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the coding standards, function
template, and the local build / analyze / test workflow.

## Releases

See [Releases](https://github.com/jjohns-dev/ArcGISEnterprise/releases) for change
notes and downloadable artifacts.

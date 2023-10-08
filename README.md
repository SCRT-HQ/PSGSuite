# PSGSuite
<div align="center">
  <img src="https://github.com/scrthq/PSGSuite/raw/master/bin/img/psgsuite2.0.0.png" alt="PSGSuite 2.0.0 released!" />
  <br />
  <br />
  <!-- Azure Pipelines -->
  <a href="https://dev.azure.com/scrthq/SCRT%20HQ/_build/latest?definitionId=2">
    <img src="https://dev.azure.com/scrthq/SCRT%20HQ/_apis/build/status/PSGSuite-CI"
      alt="Azure Pipelines" title="Azure Pipelines" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- Discord -->
  <a href="https://discord.gg/G66zVG7">
    <img src="https://img.shields.io/discord/235574673155293194.svg?style=flat&label=Discord&logo=discord&color=purple"
      alt="Discord - Chat" title="Discord - Chat" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- Slack -->
  <a href="https://scrthq-slack-invite.herokuapp.com/">
    <img src="https://img.shields.io/badge/chat-on%20slack-orange.svg?style=flat&logo=slack"
      alt="Slack - Chat" title="Slack - Chat" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- Gitter -->
  <a href="https://gitter.im/PSGSuite/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge">
    <img src="https://img.shields.io/gitter/room/scrthq/PSGSuite.svg?logo=gitter&style=flat&color=red"
      alt="Gitter - Chat" title="Gitter - Chat" />
  </a>
  <br />
  <br />
  <!-- Codacy -->
  <a href="https://www.codacy.com/app/scrthq/PSGSuite?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=scrthq/PSGSuite&amp;utm_campaign=Badge_Grade">
    <img src="https://api.codacy.com/project/badge/Grade/0d5203a1cf1945fe94c46b779eecb7f0"
      alt="Codacy" title="Codacy" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- PS Gallery -->
  <a href="https://www.PowerShellGallery.com/packages/PSGSuite">
    <img src="https://img.shields.io/powershellgallery/dt/PSGSuite.svg?style=flat&logo=powershell&color=blue"
      alt="PowerShell Gallery" title="PowerShell Gallery" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- GitHub Releases -->
  <a href="https://github.com/scrthq/PSGSuite/releases/latest">
    <img src="https://img.shields.io/github/downloads/scrthq/PSGSuite/total.svg?logo=github&color=blue"
      alt="GitHub Releases" title="GitHub Releases" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- GitHub Releases -->
  <a href="https://github.com/scrthq/PSGSuite/releases/latest">
    <img src="https://img.shields.io/github/release/scrthq/PSGSuite.svg?label=version&logo=github"
      alt="GitHub Releases" title="GitHub Releases" />
  </a>
</div>
<br />

***

## Documentation

Check out [PSGSuite.io](https://psgsuite.io/) for PSGSuite documentation, including [initial setup](https://psgsuite.io/Initial%20Setup/) help as well as function help!

## Contributing

Interested in helping out with PSGSuite development? Please check out our [Contribution Guidelines](https://github.com/scrthq/PSGSuite/blob/master/CONTRIBUTING.md)!

Building the module locally to test changes is as easy as running the `build.ps1` file in the root of the repo. This will compile the module with your changes and import the newly compiled module at the end by default.

Want to run the Pester tests locally? Pass `Test` as the value to the `Task` script parameter like so:

```powershell
.\build.ps1 -Task Test
```

## Code of Conduct

Please adhere to our [Code of Conduct](https://github.com/scrthq/PSGSuite/blob/master/CODE_OF_CONDUCT.md) when interacting with this repo.

## License

[Apache 2.0](https://tldrlegal.com/license/apache-license-2.0-(apache-2.0))

## Changelog

[Full CHANGELOG here](https://github.com/scrthq/PSGSuite/blob/master/CHANGELOG.md)

***

## 2.0.0 - Changes

### New Functionality

* PowerShell Core support for cross-platform functionality
* P12 Keys (service accounts) _and_ client_secrets.json (OAuth) are both now supported
* All Drive functions now support Team Drives
* Get-GSGmailMessage can now save message attachments to a local path
* File uploads to Drive are now supported (including recursive folder uploads!)

### Breaking Changes in 2.0.0

#### Gmail Delegation Management Removed

~~The Gmail API does not yet support handling inbox delegation. The functionality addition has been pushed back again until Q3 of 2018. Once the Gmail API supports inbox delegation, those functions will be added.~~

**Delegation functions have been re-added to PSGSuite as of v2.4.0! Update now to get all the goodness of v2 + delegation commands!**

#### Functions Removed

Please note that not all functions were ported to PSGSuite 2.0.0 due to restrictions within the .NET SDK and deprecated API calls. Here is the list of functions no longer existing in PSGSuite as of 2.0.0:

* `Get-GSToken`: no need for this as the keys are being consumed by Googles Auth SDK directly now, which makes Access/Refresh tokens non-existent for P12 Key service accounts and token management is handled automatically
* `Revoke-GSToken`: same here, no longer needed due to auth service changes
* `Start-PSGSuiteConfigWizard`: no longer supported as WPF is not compatible outside of Windows


#### Functions Aliased

All other functions are either intact or have an alias included to support backwards compatibility in scripts. Full list of aliases:

|               Alias               |            Maps To            |
| :-------------------------------: | :---------------------------: |
|    Add-GSDriveFilePermissions     |     Add-GSDrivePermission     |
|   Export-PSGSuiteConfiguration    |      Set-PSGSuiteConfig       |
|      Get-GSCalendarEventList      |      Get-GSCalendarEvent      |
|    Get-GSCalendarResourceList     |      Get-GSResourceList       |
| Get-GSDataTransferApplicationList | Get-GSDataTransferApplication |
|        Get-GSDriveFileInfo        |        Get-GSDriveFile        |
|  Get-GSDriveFilePermissionsList   |     Get-GSDrivePermission     |
|       Get-GSGmailDelegates        |      Get-GSGmailDelegate      |
|       Get-GSGmailFilterList       |       Get-GSGmailFilter       |
|       Get-GSGmailLabelList        |       Get-GSGmailLabel        |
|      Get-GSGmailMessageInfo       |      Get-GSGmailMessage       |
|     Get-GSGmailSendAsSettings     |    Get-GSGmailSendAsAlias     |
|       Get-GSGmailSignature        |    Get-GSGmailSendAsAlias     |
|          Get-GSGroupList          |          Get-GSGroup          |
|       Get-GSGroupMemberList       |       Get-GSGroupMember       |
|      Get-GSMobileDeviceList       |      Get-GSMobileDevice       |
|   Get-GSOrganizationalUnitList    |   Get-GSOrganizationalUnit    |
|           Get-GSOrgUnit           |   Get-GSOrganizationalUnit    |
|         Get-GSOrgUnitList         |   Get-GSOrganizationalUnit    |
|             Get-GSOU              |   Get-GSOrganizationalUnit    |
|        Get-GSResourceList         |        Get-GSResource         |
|        Get-GSShortURLInfo         |        Get-GSShortURL         |
|          Get-GSTeamDrive          |          Get-GSDrive          |
|       Get-GSTeamDrivesList        |          Get-GSDrive          |
|         Get-GSUserASPList         |         Get-GSUserASP         |
|       Get-GSUserLicenseInfo       |       Get-GSUserLicense       |
|       Get-GSUserLicenseList       |       Get-GSUserLicense       |
|          Get-GSUserList           |          Get-GSUser           |
|       Get-GSUserSchemaInfo        |       Get-GSUserSchema        |
|       Get-GSUserSchemaList        |       Get-GSUserSchema        |
|        Get-GSUserTokenList        |        Get-GSUserToken        |
|   Import-PSGSuiteConfiguration    |      Get-PSGSuiteConfig       |
|    Move-GSGmailMessageToTrash     |     Remove-GSGmailMessage     |
|      New-GSCalendarResource       |        New-GSResource         |
|  Remove-GSGmailMessageFromTrash   |    Restore-GSGmailMessage     |
|     Set-PSGSuiteDefaultDomain     |     Switch-PSGSuiteConfig     |
|       Switch-PSGSuiteDomain       |     Switch-PSGSuiteConfig     |
|     Update-GSCalendarResource     |       Update-GSResource       |
|   Update-GSGmailSendAsSettings    |   Update-GSGmailSendAsAlias   |
|        Update-GSSheetValue        |        Export-GSSheet         |

### Most recent changes

[Full CHANGELOG here](https://github.com/scrthq/PSGSuite/blob/master/CHANGELOG.md)

#### 2.36.7 - 2023-10-07

* [PR #385](https://github.com/SCRT-HQ/PSGSuite/pull/385)
    * Updated Invoke-Webrequest calls to accommodate systems with the now deprecated IE / MSHTML renderer disabled.

#### 2.36.4 - 2020-03-20

* [Issue #270](https://github.com/scrthq/PSGSuite/issues/270)
    * Corrected inaccurate warning that no licenses were found for a user when using the `CheckAll` switch on `Get-GSUserLicense`.

#### 2.36.3 - 2020-03-20

* [Issue #270](https://github.com/scrthq/PSGSuite/issues/270)
    * Added `CheckAll` switch parameter to `Get-GSUserLicense`
    * Updated `User` parameter aliases for all `*-GSUserLicense` functions to include `UserId` for better pipeline support.
* Miscellaneous
    * Updated GitHub Release section in psake.ps1 to POST the release to the Org URL due to failures.

#### 2.36.2 - 2020-03-02

* [Issue #263](https://github.com/scrthq/PSGSuite/issues/263)
    * Cleaned up decryption logic for encrypted config.

#### 2.36.1 - 2020-03-02

* [Issue #263](https://github.com/scrthq/PSGSuite/issues/263)
    * Fixed `[SecureString]` decryption on Unix machines running PowerShell 7 (found additional bugs)
    * Migrated private `Encrypt` and `Decrypt` to `EncryptionHelpers.ps1` in the Private folder to allow a single place to update.

#### 2.36.0 - 2020-02-28

* [PR #255](https://github.com/scrthq/PSGSuite/pull/255) - _Thanks, [@FISHMANPET](https://github.com/FISHMANPET)!_
    * Added support for `[ScriptBlock]` values on the config, allowing you to provide a script to run that will pull in a configuration value (vs embedded the value directly on the config)
* [PR #255](https://github.com/scrthq/PSGSuite/pull/260) - _Thanks, [@vaskotoo](https://github.com/vaskotoo)!_
    * Added support for an array of Users on `Get-GSGmailMessageList`
* [PR #261](https://github.com/scrthq/PSGSuite/issues/261) - _Thanks, [@Foggy2](https://github.com/Foggy2)!_
    * Added support for all license types including undocumented ones.
    * Closed out [Issue #252](https://github.com/scrthq/PSGSuite/issues/252) as well.
* [PR #262](https://github.com/scrthq/PSGSuite/issues/262) - _Thanks, [@nwls-hermesj](https://github.com/nwls-hermesj)!_
    * Added support for pipeline input of Drive file objects to `Remove-GSDriveFile`.
* [Issue #256](https://github.com/scrthq/PSGSuite/issues/256)
    * Cleaned up docs on `Send-GSChatMessage`.
* [Issue #258](https://github.com/scrthq/PSGSuite/issues/258)
    * Removed URL Shortener functions due to Google deprecation.
* [Issue #263](https://github.com/scrthq/PSGSuite/issues/263)
    * Fixed `[SecureString]` decryption on Unix machines running PowerShell 7
* Miscellaneous
    * Removed the Tasks API functions. Google has not pushed an update to the Tasks .NET SDK in over 2 months, so it is now behind the current release versions of the core Google.Apis assemblies, resulting in failure to import.

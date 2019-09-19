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

#### 2.32.3 - 2019-09-18

* [Issue #234](https://github.com/scrthq/PSGSuite/issues/234)
    * Fixed: `Update-GSUserPhoto` errors by switching to `[System.IO.File]::ReadAllBytes($path)`.

#### 2.32.2 - 2019-09-15

* [Issue #225](https://github.com/scrthq/PSGSuite/issues/225)
    * Fixed: NuGet package versions for Google APIs fell back to the version sheet during the most recent version push due to failure to communicate with NuGet to dynamically pull the latest version, resulting in previous enhancements now failing (e.g. Admin SDK rolled back to a 2017 version).
        * Added more guards and force update situations for the NuGetDependencies.json file during local builds to more concretely guarantee that the NuGet packages needed will be available.

#### 2.32.1 - 2019-09-14

* [Issue #232](https://github.com/scrthq/PSGSuite/issues/232)
    * Added: `Visibility` parameter on `New-GSCalendarEvent`

#### 2.32.0 - 2019-09-12

* [Issue #229](https://github.com/scrthq/PSGSuite/issues/229)
    * Added: `Update-GSGmailLanguageSettings` and `Get-GSGmailLanguageSettings` functions to update/get a users default language settings in Gmail.
* [Issue #231](https://github.com/scrthq/PSGSuite/issues/231)
    * Added: `Update-GSCalenderSubscription` function to updated existing calendar subscriptions.
    * Removed: Default values for the following parameters on `Add-GSCalendarSubscription` to prevent automatically adding notifications for new CalendarList entries (subscriptions):
        * `DefaultNotificationType`
        * `DefaultNotificationMethod`
        * `DefaultReminderMethod`
        * `DefaultReminderMinutes`
    * Added: `Notifications` and `Reminders` parameters to `Add-GSCalenderSubscription` and `Update-GSCalenderSubscription`
    * Added: `Reminders` parameter to `New-GSCalendarEvent` and `Update-GSCalendarEvent` functions to set custom reminders on calendar events.
    * Added: `Add-GSCalendarEventReminder` and `Add-GSCalendarNotification` helper functions.
    * Updated: `DisableReminder` switch parameter name on `New-GSCalendarEvent` and `Update-GSCalendarEvent` functions to `DisableDefaultReminder` to better align with what that actually effects (default reminder inheritance only, not reminder overrides). The previous parameter name has been set as an alias to maintain backwards compatibility.
    * Added: `RemoveAllReminders` parameter to `Update-GSCalendarEvent` to remove all custom reminders and disable calendar inheritance.
* [Issue #232](https://github.com/scrthq/PSGSuite/issues/232)
    * Added: `Visibility` parameter on `Update-GSCalendarEvent` to set the visibility of a calendar event.
* Miscellaneous
    * Forced `Type` parameter values to lower on the `Add-GSUser*` helper functions to ensure case senstive field matches whats expected.
    * Updated Google .NET SDKs to latest versions.
    * Updated and corrected a LOT of comment based function help.
    * Added function help tests to validate that functions contain expected help content.

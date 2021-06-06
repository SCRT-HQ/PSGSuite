* [PSGSuite - ChangeLog](#psgsuite---changelog)
    * [2.36.6 - 2021-06-06](#2366---2021-06-06)
    * [2.36.5 - 2020-11-01](#2365---2020-11-01)
    * [2.36.4 - 2020-03-20](#2364---2020-03-20)
    * [2.36.3 - 2020-03-20](#2363---2020-03-20)
    * [2.36.2 - 2020-03-02](#2362---2020-03-02)
    * [2.36.1 - 2020-03-02](#2361---2020-03-02)
    * [2.36.0 - 2020-02-28](#2360---2020-02-28)
    * [2.35.1 - 2019-12-29](#2351---2019-12-29)
    * [2.35.0 - 2019-12-29](#2350---2019-12-29)
    * [2.34.0 - 2019-11-02](#2340---2019-11-02)
    * [2.33.2 - 2019-10-06](#2332---2019-10-06)
    * [2.33.1 - 2019-10-06](#2331---2019-10-06)
    * [2.33.0 - 2019-09-26](#2330---2019-09-26)
    * [2.32.3 - 2019-09-18](#2323---2019-09-18)
    * [2.32.2 - 2019-09-15](#2322---2019-09-15)
    * [2.32.1 - 2019-09-14](#2321---2019-09-14)
    * [2.32.0 - 2019-09-12](#2320---2019-09-12)
    * [2.31.1 - 2019-08-30](#2311---2019-08-30)
    * [2.31.0](#2310)
    * [2.30.2](#2302)
    * [2.30.1](#2301)
    * [2.30.0](#2300)
    * [2.29.0](#2290)
    * [2.28.2](#2282)
    * [2.28.1](#2281)
    * [2.28.0](#2280)
    * [2.27.0](#2270)
    * [2.26.4](#2264)
    * [2.26.3](#2263)
    * [2.26.2](#2262)
    * [2.26.1](#2261)
    * [2.26.0](#2260)
    * [2.25.3](#2253)
    * [2.25.2](#2252)
    * [2.25.1](#2251)
    * [2.25.0](#2250)
    * [2.24.0](#2240)
    * [2.23.2](#2232)
    * [2.23.1](#2231)
    * [2.23.0](#2230)
    * [2.22.4](#2224)
    * [2.22.3](#2223)
    * [2.22.2](#2222)
    * [2.22.1](#2221)
    * [2.22.0](#2220)
    * [2.21.3](#2213)
    * [2.21.2](#2212)
    * [2.21.1](#2211)
    * [2.21.0](#2210)
    * [2.20.2](#2202)
    * [2.20.1](#2201)
    * [2.20.0](#2200)
    * [2.19.0](#2190)
    * [2.18.1](#2181)
    * [2.18.0](#2180)
    * [2.17.2](#2172)
    * [2.17.1](#2171)
    * [2.17.0](#2170)
    * [2.16.1](#2161)
    * [2.16.0](#2160)
    * [2.15.4](#2154)
    * [2.15.3](#2153)
    * [2.15.2](#2152)
    * [2.15.1](#2151)
    * [2.15.0](#2150)
    * [2.14.1](#2141)
    * [2.14.0](#2140)
    * [2.13.2](#2132)
    * [2.13.1](#2131)
    * [2.13.0](#2130)
    * [2.12.1](#2121)
    * [2.12.0](#2120)
    * [2.11.0](#2110)
    * [2.10.2](#2102)
    * [2.10.1](#2101)
    * [2.10.0](#2100)
    * [2.9.0](#290)
    * [2.8.1](#281)
    * [2.8.0](#280)
    * [2.7.2](#272)
    * [2.7.1](#271)
    * [2.7.0](#270)
    * [2.6.3](#263)
    * [2.6.2](#262)
    * [2.6.1](#261)
    * [2.6.0](#260)
    * [2.5.4](#254)
    * [2.5.3](#253)
    * [2.5.2](#252)
    * [2.5.1](#251)
    * [2.5.0](#250)
    * [2.4.0](#240)
    * [2.3.0](#230)
    * [2.2.1](#221)
    * [2.2.0](#220)
    * [2.1.5](#215)
    * [2.1.3 / 2.1.4](#213--214)
    * [2.1.2](#212)
    * [2.1.1](#211)
    * [2.1.0](#210)
    * [2.0.3](#203)
    * [2.0.2](#202)
    * [2.0.1](#201)
    * [2.0.0](#200)
        * [New Functionality](#new-functionality)
        * [Breaking Changes in 2.0.0](#breaking-changes-in-200)
            * [Gmail Delegation Management Removed](#gmail-delegation-management-removed)
            * [Functions Removed](#functions-removed)
            * [Functions Aliased](#functions-aliased)

***

# PSGSuite - ChangeLog

## 2.36.6 - 2021-06-06

* [Issue #344](https://github.com/SCRT-HQ/PSGSuite/issues/344)
    * Added 'Update-GSGroup' function to allow updating directory information.
    * Removed 'Email' parameter in `Update-GSGroupSettings.ps1` as this cannot be updated via Groups Settings API.

## 2.36.5 - 2020-11-01

* [Issue #331](https://github.com/scrthq/PSGSuite/issues/331)
    * Updated many inaccurate parameters in `Set-GSGroupSettings.ps1` due to Google Group changes upstream

## 2.36.4 - 2020-03-20

* [Issue #270](https://github.com/scrthq/PSGSuite/issues/270)
    * Corrected inaccurate warning that no licenses were found for a user when using the `CheckAll` switch on `Get-GSUserLicense`.

## 2.36.3 - 2020-03-20

* [Issue #270](https://github.com/scrthq/PSGSuite/issues/270)
    * Added `CheckAll` switch parameter to `Get-GSUserLicense`
    * Updated `User` parameter aliases for all `*-GSUserLicense` functions to include `UserId` for better pipeline support.
* Miscellaneous
    * Updated GitHub Release section in psake.ps1 to POST the release to the Org URL due to failures.

## 2.36.2 - 2020-03-02

* [Issue #263](https://github.com/scrthq/PSGSuite/issues/263)
    * Cleaned up decryption logic for encrypted config.

## 2.36.1 - 2020-03-02

* [Issue #263](https://github.com/scrthq/PSGSuite/issues/263)
    * Fixed `[SecureString]` decryption on Unix machines running PowerShell 7 (found additional bugs)
    * Migrated private `Encrypt` and `Decrypt` to `EncryptionHelpers.ps1` in the Private folder to allow a single place to update.

## 2.36.0 - 2020-02-28

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

## 2.35.1 - 2019-12-29

* [Issue #57](https://github.com/scrthq/PSGSuite/issues/57)
    * Updated `New-GSGmailSMIMEInfo` to cast `Pkcs12` to URLSafeBase64 *without* removing the trailing padding `=`, based on GAMs process in Python. Confirmed replication of the resultant value being sent from GAM in PowerShell, ready to validate.

## 2.35.0 - 2019-12-29

* [Issue #216](https://github.com/scrthq/PSGSuite/issues/216) - _Thank you, [@WJurecki](https://github.com/WJurecki)!_
    * Added `Add-GSSheetValues` to use the native `Append()` method instead of `BatchUpdate()` to prevent needing to calculate the last row like you do with `Export-GSSheet`. Since the input for this method has additional options and the output differs from what `Export-GSSheet` outputs, this has been moved to a unique function to prevent introducing breaking changes to `Export-GSSheet`.
* [Issue #221](https://github.com/scrthq/PSGSuite/issues/221)
    * Added: `Invoke-GSUserOffboarding` function to wrap common offboarding tasks for ease of access management automation.
* [Issue #248](https://github.com/scrthq/PSGSuite/issues/248)
    * Fixed `Get-GSSheetInfo` so it no longer defaults `-IncludeGridData` to `$true` if not specified in `$PSBoundParameters`.
* [Issue #249](https://github.com/scrthq/PSGSuite/issues/249)
    * Updated private function `Resolve-Email` with new `IsGroup` switch, then cleaned up all `*-GSGroup*` functions to use it so that Group ID's are respected based on RegEx match.
* [Issue #252](https://github.com/scrthq/PSGSuite/issues/252)
    * Added: `Archived` parameter to `Update-GSUser` to enable setting of Archived User licenses.
* Miscellaneous
    * Swapped instances of `Get-StoragePath` for `Get-ConfigurationPath` in `Import-SpecificConfiguration` and `Set-PSGSuiteConfig` to avoid alias related issues with PowerShell 4.0

## 2.34.0 - 2019-11-02

* [Issue #245](https://github.com/scrthq/PSGSuite/issues/245) + [PR #246](https://github.com/scrthq/PSGSuite/pull/246) - _Thank you, [@devblackops](https://github.com/devblackops)!_
    * Added: Optional `-CreateMeetEvent` switch parameter to `New-GSCalendarEvent` to create a Google Meet conference and attach it to the calendar event.

## 2.33.2 - 2019-10-06

* [Issue #242](https://github.com/scrthq/PSGSuite/issues/242)
    * Fixed: Error handling around `[System.Console]::CursorVisible` on `Start-GSDriveFileUpload`, `Wait-GSDriveFileUpload` and `Write-InlineProgress`
    * Cleaned up verbose handling on `Stop-GSDriveFileUpload` due to file uploads showing as Failed even though they were successful.
* Miscellaneous
    * Updated build.ps1 script for better verbose output

## 2.33.1 - 2019-10-06

* [Issue #235](https://github.com/scrthq/PSGSuite/issues/235)
    * Removed: `Name` parameter from `Start-GSDriveFileUpload` as it was unused in the function and doesnt make sense when uploading an array of files.
* [Issue #238](https://github.com/scrthq/PSGSuite/issues/238)
    * Added: `Get-GSDataTransfer` to Get/List current Data Transfers
* [Issue #239](https://github.com/scrthq/PSGSuite/issues/239)
    * Removed: `Update-GSResource` `Id` parameter as it was non-applicable (duplicate of `ResourceId` and not writable per API docs)
    * Cleaned up function help and examples to match changes
* [Issue #240](https://github.com/scrthq/PSGSuite/issues/240)
    * Fixed: `Get-GSCalendar` now properly resolves single calendar metadata retrieval and passes List requests to `Get-GSCalendarSubscription` since the `Calendars` service does not support List requests.
* Miscellaneous
    * Updated Google .NET SDKs to latest versions
    * Cleaned up build.ps1 script

## 2.33.0 - 2019-09-26

* [Issue #236](https://github.com/scrthq/PSGSuite/issues/236)
    * Fixed: Custom converter for Configuration metadata defaults to `ConvertTo-SecureString` as the preferred function instead of the custom `Secure`. `Secure` is still supported for backwards compatibility.

## 2.32.3 - 2019-09-18

* [Issue #234](https://github.com/scrthq/PSGSuite/issues/234)
    * Fixed: `Update-GSUserPhoto` errors by switching to `[System.IO.File]::ReadAllBytes($path)`.

## 2.32.2 - 2019-09-15

* [Issue #225](https://github.com/scrthq/PSGSuite/issues/225)
    * Fixed: NuGet package versions for Google APIs fell back to the version sheet during the most recent version push due to failure to communicate with NuGet to dynamically pull the latest version, resulting in previous enhancements now failing (e.g. Admin SDK rolled back to a 2017 version).
        * Added more guards and force update situations for the NuGetDependencies.json file during local builds to more concretely guarantee that the NuGet packages needed will be available.

## 2.32.1 - 2019-09-14

* [Issue #232](https://github.com/scrthq/PSGSuite/issues/232)
    * Added: `Visibility` parameter on `New-GSCalendarEvent`

## 2.32.0 - 2019-09-12

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

## 2.31.1 - 2019-08-30

* [Issue #222](https://github.com/scrthq/PSGSuite/issues/222)
    * Fixed: `Remove-GSUserASP` and `Remove-GSUserToken` not removing all when no Id is passed due to no service being created.
* [Issue #225](https://github.com/scrthq/PSGSuite/issues/225)
    * Added: `RecoveryEmail` and `RecoveryPhone` parameters to `Update-GSUser`
* [Issue #189](https://github.com/scrthq/PSGSuite/issues/189)
    * Removed `$env:UserName` from the application name when creating the client in `New-GoogleService` to prevent errors with the underlying .NET SDK.
* Miscellaneous
    * Fixed: Corrected logic on the `FullName` parameter on `Update-GSUser` to parse the name parts.
    * Updated Google .NET SDKs to latest versions.

## 2.31.0

* [Issue #218](https://github.com/scrthq/PSGSuite/issues/218)
    * Fixed: `Update-GSOrganizationalUnit` was failing with `null` reference errors.
* [Issue #213](https://github.com/scrthq/PSGSuite/issues/213)
    * Added: Support for `RELEASE_RESOURCES` TransferParam for Calendar application data transfers to function `Start-GSDataTransfer`
* [Issue #215](https://github.com/scrthq/PSGSuite/issues/215)
    * Added:
        * `Get-GSDomain`
        * `Remove-GSDomain`
        * `New-GSDomain`
        * `Get-GSDomainAlias`
        * `New-GSDomainAlias`
        * `Remove-GSDomainAlias`
    * _These will need the additional scope of `https://www.googleapis.com/auth/admin.directory.domain` added in order to use!_
* Miscellaneous
    * Added:
        * `Get-GSCustomer`
        * `Update-GSCustomer`
        * `Add-GSCustomerPostalAddress`
    * _These will need the additional scope of `https://www.googleapis.com/auth/admin.directory.customer` added in order to use!_

## 2.30.2

* [Issue #212](https://github.com/scrthq/PSGSuite/issues/212)
    * Fixed: `Get-GSUserLicense` no longer short circuiting after first license match when processing pipeline input
    * Updated: License SKU order to check most common license types first for `Get-GSUserLicense`, which should result in faster overall processing when working with a large amount of users.

## 2.30.1

* Miscellaneous
    * Fixed: `Remove-GSDrivePermission` duplicate parameter alias prevented usage after module update.

## 2.30.0

* [Issue #193](https://github.com/scrthq/PSGSuite/issues/193)
    * Added: Drive Revision functions:
        * `Get-GSDriveRevision`
        * `Remove-GSDriveRevision`
        * `Update-GSDriveRevision`
* [Issue #210](https://github.com/scrthq/PSGSuite/issues/210)
    * Fixed: `Update-GSUser` was not accepting User ID's as the User parameter
* [Issue #209](https://github.com/scrthq/PSGSuite/issues/209)
    * Added: Support for inline image downloading with `Get-GSGmailMessage` where the image is not included on the Attachments property of the parsed message object.
    * Fixed: `Get-GSGmailMessage` will now automatically set the `Format` to `Raw` if either `ParseMessage` or `SaveAttachmentsTo` is passed, as `ParseMessage` is a requirement in order to be able to access the message attachments as needed.
* [Issue #204](https://github.com/scrthq/PSGSuite/issues/204)
    * Added: `Recurse` parameter to `Get-GSDriveFileList` to allow recursively listing all files and subfolders underneath the result set. Confirmed setting the `Limit` parameter also works as expected with `Recurse` included, stopping is the original limit is reached.
    * Added: `Get-GSDriveFolderSize` function to return the calculated total size of the files in the specified folder(s).
* Miscellaneous
    * Added: `Rfc822MsgId` parameter to `Get-GSGmailMessageList` to easily build a query looking for a specific RFS 822 Message ID.
    * Added: Pipeline support for `*-GSDrivePermission` functions to enable piping Drive Files into them to manage permissions without looping manually.

## 2.29.0

* [Issue #201](https://github.com/scrthq/PSGSuite/issues/201)
    * Fixed: Fields parameter on remaining `*-GSDriveFile` functions
* [Issue #197](https://github.com/scrthq/PSGSuite/issues/197)
    * Updated: All remaining `*-TeamDrive` functions now use the new Drives namespace. All previous functions names have been converted to aliases to maintain backwards compatibility.
    * Added: `Hide-GSDrive`
    * Added: `Show-GSDrive`
* [Issue #184](https://github.com/scrthq/PSGSuite/issues/184)
    * Added: `EnableCollaborativeInbox` parameter to `Update-GSGroupSettings`
    * Added: `WhoCanDiscoverGroup` parameter to `Update-GSGroupSettings`

## 2.28.2

* [Issue #194](https://github.com/scrthq/PSGSuite/issues/194)
    * Fixed: Parameters not setting correctyl on `Update-GSChromeOSDevice`:
        * `AnnotatedAssetId [string]`
        * `AnnotatedLocation [string]`
        * `AnnotatedUser [string]`
        * `Notes [string]`

## 2.28.1

* [Issue #188](https://github.com/scrthq/PSGSuite/issues/188)
    * Fixed: `Get-SafeFileName` correctly replaces special RegEx chars with underscores as well.

## 2.28.0

* [Issue #188](https://github.com/scrthq/PSGSuite/issues/188)
    * Added: `Get-GSDriveFile` now supports specifying a full file path.
    * Fixed: `Get-GSDriveFile` will now replace any special path characters in the filename with underscores
    * Added: The File object returned by `Get-GSDriveFile` will now include an additional `OutFilePath` property if the file is downloaded. This property will contain the full path to the downloaded file.
* [Issue #190](https://github.com/scrthq/PSGSuite/issues/190)
    * Fixed: `Fields` parameter on `Get-GSDriveFile` and `Update-GSDriveFile` were not being honored.
* [Issue #192](https://github.com/scrthq/PSGSuite/issues/192)
    * Added: Parameters to `Update-GSDriveFile`:
        * `CopyRequiresWriterPermission [switch]`
        * `Starred [switch]`
        * `Trashed [switch]`
        * `WritersCanShare [switch]`
* [Issue #194](https://github.com/scrthq/PSGSuite/issues/194)
    * Added: Parameters to `Update-GSChromeOSDevice`:
        * `AnnotatedAssetId [string]`
        * `AnnotatedLocation [string]`
        * `AnnotatedUser [string]`
        * `Notes [string]`
* [Issue #195](https://github.com/scrthq/PSGSuite/issues/195)
    * Added: `Limit` parameter with `First` alias to the following `List` functions:
        * `Get-GSActivityReport`
        * `Get-GSAdminRole`
        * `Get-GSAdminRoleAssignment`
        * `Get-GSCalendar`
        * `Get-GSCalendarAcl`
        * `Get-GSCalendarEvent`
        * `Get-GSChromeOSDevice`
        * `Get-GSDataTransferApplication`
        * `Get-GSDrive`
        * `Get-GSDriveFileList`
        * `Get-GSDrivePermission`
        * `Get-GSGmailMessageList`
        * `Get-GSGroup`
        * `Get-GSGroupMember`
        * `Get-GSMobileDevice`
        * `Get-GSResource`
        * `Get-GSTask`
        * `Get-GSTaskList`
        * `Get-GSUsageReport`
        * `Get-GSUser`
        * `Get-GSUserLicense`
* [Issue #196](https://github.com/scrthq/PSGSuite/issues/196)
    * Fixed: `Get-GSTeamDrive` was not paginating through the results.
* [Issue #197](https://github.com/scrthq/PSGSuite/issues/197)
    * Renamed: `Get-GSTeamDrive` has been changed to `Get-GSDrive`. `Get-GSTeamDrive` has been turned into an alias for `Get-GSDrive` to maintain backwards compatibility.
    * Replaced: `SupportsTeamDrives = $true` with `SupportsAllDrives = $true` on all functions that have it.
* Miscellaneous
    * Fixed: `Export-PSGSuiteConfig` is faster due to safely assuming that the P12Key and/or ClientSecrets values have already been pulled from the corresponding keys.
    * Fixed: Incomplete documentation for `Test-GSGroupMembership`.
    * Added: `UseDomainAdminAccess` switch parameter to `Get-GSTeamDrive`
    * Removed: `Get-GSUserLicenseListPrivate` by rolling the `List` code into `Get-GSUserLicense`
    * Removed: `Get-GSResourceListPrivate` by rolling the `List` code into `Get-GSResource`

## 2.27.0

* [Issue #185](https://github.com/scrthq/PSGSuite/issues/185)
    * Fixed: `Get-GSGroup -Where_IsAMember $member` no longer errors.
* [Issue #186](https://github.com/scrthq/PSGSuite/issues/186)
    * Added: `Test-GSGroupMembership` to map to the [hasMember method](https://developers.google.com/admin-sdk/directory/v1/reference/members/hasMember).
* Miscellaneous
    * Improved build process to auto-update NuGet dependencies during CI.
    * Added new private function `Resolve-Email` to convert a name-part or the case-sensitive `me` to the full email address accordingly.

## 2.26.4

* [Issue #177](https://github.com/scrthq/PSGSuite/issues/177) - _Thanks, [@WJurecki](https://github.com/WJurecki)!_
    * Fixed: `Fields` parameter `Get-GSDriveFileList` would not set correctly with the default fields value, breaking the expected experience. Restored the same functionality

## 2.26.3

* [Issue #182](https://github.com/scrthq/PSGSuite/issues/182) - _Thanks, [@aitcriver](https://github.com/aitcriver)!_
    * Added: `FileOrganizer` role to `ValidateSet` for parameter `Role` on function `Add-GSDrivePermission`

## 2.26.2

* [Issue #177](https://github.com/scrthq/PSGSuite/issues/177)
    * Added: `Fields` parameter to `Get-GSDriveFileList`
* [Issue #178](https://github.com/scrthq/PSGSuite/issues/178)
    * Fixed: `Start-GSDriveFileUpload` failing on PowerShell 4.0
* [Issue #179](https://github.com/scrthq/PSGSuite/issues/179)
    * Added: `Ims` parameter to both `New-GSUser` and `Update-GSUser`
    * Added: `Add-GSUserIm` function to create correct type for new `Ims` parameter.
* Miscellaneous
    * Added: `Clear-PSGSuiteServiceCache` to clear the cache and dispose of any remaining open web clients.
    * Improved overall service caching.
    * Added: Support for `Cloud-Identity` licenses for `Get-GSUserLicense`
    * Added: `OutputType` for all applicable Helper functions (i.e. `Add-GSUserIm`).

## 2.26.1

* [Issue #172](https://github.com/scrthq/PSGSuite/issues/172)
    * Fixed: `New-GoogleService` now using `New-Object` to prevent `[Google.Apis.Util.Store.FileDataStore]::new()` constructor issues in PowerShell 4.
* [Issue #173](https://github.com/scrthq/PSGSuite/issues/173)
    * Added: `FolderColorRgb` parameter to `New-GSDriveFile` and `Update-GSDriveFile` to enable setting the color of a folder in Drive - _Thanks, [@WJurecki](https://github.com/WJurecki)!_
* [PR #174](https://github.com/scrthq/PSGSuite/pull/174) - _Thanks, [@WJurecki](https://github.com/WJurecki)!_
    * Fixed: `Get-GSDriveFileList` filter concatenation so it joins multiple filters with ` and ` instead of just a space ` `.

## 2.26.0

* [Issue #169](https://github.com/scrthq/PSGSuite/issues/169)
    * Fixed: `Get-GSGmailMessage` fails to download attachments containing invalid characters (e.g. `:`)
* [Issue #168](https://github.com/scrthq/PSGSuite/issues/168)
    * Added: `Add-GSUserLocation`
    * Updated: `New-GSUser` and `Update-GSUser` to add in Location support
* Miscellaneous
    * Improved pipeline support for the `User` parameter across all pertinent functions, i.e. Drive, Calendar, Gmail, Sheets & Tasks APIs.

## 2.25.3

* Miscellaneous
    * Added: Pipeline support for `Remove-GSCalendarEvent`

## 2.25.2

* [Issue #167](https://github.com/scrthq/PSGSuite/issues/167)
    * Fixed: `Switch-PSGSuiteConfig -SetToDefault` failing with invalid scope errors

## 2.25.1

* [PR #165](https://github.com/scrthq/PSGSuite/pull/165) - _Thanks, [@scv-m](https://github.com/scv-m)!_
    * Updated: `Get-GSCourseParticipant` now supports pipeline input for CourseId to enable piping `Get-GSCourse` into it.
* [Issue #166](https://github.com/scrthq/PSGSuite/issues/166)
    * Fixed: `Update-GSUser` would fail to update user phones due to incorrect variable name in the Process block, effectively skipping it.

## 2.25.0

* [Issue #162](https://github.com/scrthq/PSGSuite/issues/162)
    * Updated: `New-GoogleService` now caches Service objects created during the current session. This means that repeated calls will attempt to use an existing Service object from the cache if present, otherwise it will create the Service as usual.
    * Updated: `New-GoogleService` Verbose output. To cut down on verbose noisiness, the following verbose output is set:
        * New Service created = `Building ServiceAccountCredential from....`
        * First use of existing Service = `Using matching cached service for user....`
        * Re-use of existing Service = No verbose output (helps cut down on pipeline verbosity where service re-use is expected)
    * Added: `Get-PSGSuiteServiceCache` to get the current Service Cache for inspection.
* [Issue #163](https://github.com/scrthq/PSGSuite/issues/163)
    * Added: `Get-GSCalendar` to get the CalendarList of a user.
    * Added: `Remove-GSCalendarAcl` to remove Access Control List rules from Google Calendars.
* Miscellaneous
    * Improved pipeline support for Gmail `*Message` functions and Calendar functions.
    * Added tab completion to `Switch-PSGSuiteConfig` for the ConfigName parameter.

## 2.24.0

* [Issue #159](https://github.com/scrthq/PSGSuite/issues/159)
    * Added: `Revoke-GSStudentGuardianInvitation` to revoke student guardian invitations (Classroom API)

## 2.23.2

* Fixed logic issue with Get-GSUsageReport for reports returning no entities where errors would be thrown. Resolved by guarding against acting on `$null` values in the loop.

## 2.23.1

**This update changes the output of `Get-GSUsageReport` -- please review the output changes before updating if you have scripts that use that function!!**

* Fixed: `Get-GSUsageReport` wasn't displaying critical report information (such as the Entity info) due to Select-Object being hardcoded. Function has been updated to parse the resulting Parameters and Entity info out to the top-level object.
    * Added: `Flat` switch to specify that the parsed properties match what GAM returns, i.e. `'gmail:num_outbound_unencrypted_emails' = 6`. Normal behavior would be to parse that into an ordered dictionary, i.e. `gmail['num_outbound_unencrypted_emails'] = 6`, so that only `gmail` is seen from the top level object and all relevant report data is captured in the underlying dictionary.
    * Added: `Raw` switch to allow the raw UsageReportsValue to be returned instead of parsing it out.

## 2.23.0

* [Issue #152](https://github.com/scrthq/PSGSuite/issues/152)
    * Added full coverage of `Gmail.Settings.SendAs` resource (where signatures are managed with the newer Gmail API):
        * Added: `Get-GSGmailSendAsAlias`
        * Added: `Update-GSGmailSendAsAlias`
        * Added: `Get-GSGmailSignature` (aliased to `Get-GSGmailSendAsAlias`)
        * Added: `Update-GSGmailSignature` (aliased to `Update-GSGmailSendAsAlias` with some additional convenience parameters)
        * Added: `Get-GSGmailSendAsSettings` (aliased to `Get-GSGmailSendAsAlias`)
        * Added: `Update-GSGmailSendAsSettings` (aliased to `Update-GSGmailSendAsAlias`)
        * Added: `Remove-GSGmailSendAsAlias`
        * Added: `New-GSGmailSendAsAlias`
        * Added: `Send-GSGmailSendAsConfirmation`

## 2.22.4

* [Issue #147](https://github.com/scrthq/PSGSuite/issues/147)
    * Added: `Get-GSChromeOSDevice` - Handles Get or List requests, depending on if you specify a ResourceId or not.
    * Added: `Update-GSChromeOSDevice` - Handles Action, Move and/or Patch requests depending on the parameters passed.

## 2.22.3

* [Issue #144](https://github.com/scrthq/PSGSuite/issues/144)
    * Updated: `Start-GSDriveFileUpload` to not call `[System.Console]::CursorVisible` when `$Host` is PowerShell ISE

## 2.22.2

* [Issue #144](https://github.com/scrthq/PSGSuite/issues/144)
    * Updated: `Start-GSDriveFileUpload` to `Dispose()` open streams once uploads are completed.
    * Added: `Stop-GSDriveFileUpload` to enable cleanup of any remaining open streams.
    * Updated: `Get-GSDriveFileUpload` to `Dispose()` any completed streams that are still open.

## 2.22.1

* [PR #141](https://github.com/scrthq/PSGSuite/pull/141) - _Thanks, [@dwrusse](https://github.com/dwrusse)!_
    * Added: `Remove-GSDriveFile`
    * Updated: `Get-GSCalendarSubscription` to add support for `List()` requests and added the `ShowHidden` & `ShowDeleted` parameters.

## 2.22.0

* Miscellaneous: _Config management and portability updates_
    * Added: `Export-PSGSuiteConfig` function to export key parts of your config in a transportable JSON file.
    * Added: `Import-PSGSuiteConfig` function to import a config from a JSON file (i.e. one created with `Export-PSGSuiteConfig`) or from a JSON string (i.e. stored in a secure variable in a CI/CD system.)
    * Updated: All config functions now store the P12Key or the ClientSecrets JSON string in the encrypted config directly. This is to allow removal of the secrets files as well as enable PSGSuite to run in a contained environment via importing the config from a secure JSON string.
    * Updated: `[Get|Set|Switch]-PSGSuiteConfig` to include the P12Key and ClientSecrets parameters that enable housing of the key/secret directly on the encrypted config.
    * Updated: If the global PSGSuite variable `$global:PSGSuite` exists during module import, it will default to using that as it's configuration, otherwise it will import the default config if set.

## 2.21.3

* [Issue #131](https://github.com/scrthq/PSGSuite/issues/131)
    * Fixed: Changed `CodeReceiver` to use `PromptCodeReceiver` when client is PowerShell Core, as `LocalServerCodeReceiver` does not appear to redirect correctly and auth fails. Same behavior in Core regardless of OS.
* Miscellaneous
    * Added: `OutputType` to all functions that return standard objects.

## 2.21.2

* [Issue #136](https://github.com/scrthq/PSGSuite/issues/136)
    * Fixed: `Start-GSDriveFileUpload` failing when specifying a user other than the Admin user to do the upload as.

## 2.21.1

* [Issue #131](https://github.com/scrthq/PSGSuite/issues/131) - _Free/standard Google Account support_
    * Fixed: Handling of scopes in `New-GoogleService` for authentication when a client_secrets.json file is used instead of the typical .p12 key.
    * Updated: Documentation to show how to use an account that is not a G Suite admin or G Suite user at all with PSGSuite
    * Updated: `*-PSGSuiteConfig` commands now store the client_secrets.json string contents directly on the encrypted config once provided either the path or the string contents directly, allowing users to remove any plain text credentials once loaded into the encrypted config.
    * Updated: `Get-GSToken` now uses `New-GoogleService` under the hood, so `client_secrets.json` will work with Contacts API.

## 2.21.0

* [PR #130](https://github.com/scrthq/PSGSuite/pull/130) / [Issue #129](https://github.com/scrthq/PSGSuite/issues/129)
    * Added: Support for UserRelations management in `New-GSUser -Relations $relations` and `Update-GSUser -Relations $relations` via `Add-GSUserRelation` helper function. - _Thanks, [@mattwoolnough](https://github.com/mattwoolnough)!_
    * Added: Logic to `Update-GSUser` to enable clearing of all values for user properties `Phones`, `ExternalIds`, `Organizations`, and `Relations` by REST API call via passing `$null` as the value when calling `Update-GSUser`. - _Thanks, [@mattwoolnough](https://github.com/mattwoolnough)!_
* [Issue #129](https://github.com/scrthq/PSGSuite/issues/129)
    * Fixed: Documentation for `Get-GSSheetInfo` around the `Fields` parameter.
    * Added: Additional correction of casing for `Fields` values in `Get-GSSheetInfo` so that it will always submit the values using the correct case, even if providing the incorrect case as the value to the parameter.

## 2.20.2

* [Issue #120](https://github.com/scrthq/PSGSuite/issues/120)
    * Added: `Update-GSMobileDevice` to allow taking action on Mobile Devices
    * Fixed: Bug in `Remove-GSMobileDevice` with incorrect variable name

## 2.20.1

* [Issue #121](https://github.com/scrthq/PSGSuite/issues/121)
    * Added: `Update-GSGroupMember` to allow setting a group member's Role and/or DeliverySettings
* Miscellaneous
    * Added: GitHub release automation to deploy task
    * Added: Twitter update automation on new version release to deploy task

## 2.20.0

* [Issue #115](https://github.com/scrthq/PSGSuite/issues/115)
    * Renamed: `Get-GSCalendarEventList` to `Get-GSCalendarEvent` and set the original name as an exported Alias to the new name for backwards compatibility.
    * Added: `EventId` parameter to `Get-GSCalendarEvent` to specify individual event ID's to get instead of a filtered list.
    * Added: `PrivateExtendedProperty` parameter to `Get-GSCalendarEvent`.
    * Added: `SharedExtendedProperty` parameter to `Get-GSCalendarEvent`.
    * Added: `PrivateExtendedProperties` parameter to `New-GSCalendarEvent` and `Update-GSCalendarEvent`.
    * Added: `SharedExtendedProperties` parameter to `New-GSCalendarEvent` and `Update-GSCalendarEvent`.
    * Added: `ExtendedProperties` parameter to `New-GSCalendarEvent` and `Update-GSCalendarEvent`.
    * Added: `Id` parameter to `New-GSCalendarEvent` and `Update-GSCalendarEvent`.
* [Issue #117](https://github.com/scrthq/PSGSuite/issues/117)
    * Fixed: Type error on `States` parameter of `Get-GSStudentGuardianInvitation`.
* Miscellaneous
    * Updated Contributing doc with new Build script steps
    * Removed `DebugMode.ps1` script since it's no longer needed (use `build.ps1` instead)

## 2.19.0

* [PR #113](https://github.com/scrthq/PSGSuite/pull/113)
    * Added: `Add-GSUserEmail` to support the Emails property. - _Thanks, [@sguilbault-sherweb](https://github.com/sguilbault-sherweb)!_
    * Updated: `Add-GSUser` and `Update-GSUser` to implement the newly supported `Emails` property. - _Thanks, [@sguilbault-sherweb](https://github.com/sguilbault-sherweb)!_
    * Fixed: Removed `if ($PSCmdlet.ParameterSetName -eq 'Get')` from `New-GSAdminRoleAssignment` that was making the cmdlet fail. - _Thanks, [@sguilbault-sherweb](https://github.com/sguilbault-sherweb)!_
    * Fixed: `New-GSAdminRoleAssignment` help section rewrite. (The help of this function was a copy of the `Get-GSAdminRoleAssignment` cmdlet) - _Thanks, [@sguilbault-sherweb](https://github.com/sguilbault-sherweb)!_

## 2.18.1

* [Issue #87](https://github.com/scrthq/PSGSuite/issues/87)
    * Added: Additional scopes during Service creation for `Get-GSCourseParticipant` and `Get-GSClassroomUserProfile` to enable pulling of full user profile information. - _Thanks, [@jdstanberry](https://github.com/jdstanberry)!_
* [Issue #111](https://github.com/scrthq/PSGSuite/issues/111)
    * Added: `DisableReminder` switch parameter to `New-GSCalendarEvent` and `Update-GSCalendarEvent` to remove Reminder inheritance from the calendar the event is on as well as any Reminder overload definitions.
* [Issue #53](https://github.com/scrthq/PSGSuite/issues/53)
    * Updated: `Get-GSContactList` and `Remove-GSContact` Token retrieval and overall cleanup
* Various/Other
    * Updated: `Get-GSToken` to align parameters more with `New-GoogleService`

## 2.18.0

* [Issue #87](https://github.com/scrthq/PSGSuite/issues/87)
    * Added: `Get-GSCourseParticipant` and `Get-GSClassroomUserProfile` now have the `Fields` parameter
    * Added: `Sync-GSUserCache` to create a hashtable of users for quick lookups throughout scripts
* [Issue #53](https://github.com/scrthq/PSGSuite/issues/53) via [PR #108](https://github.com/scrthq/PSGSuite/pull/108) - _Thanks, [@dwrusse](https://github.com/dwrusse)!_
    * Added: `Get-GSContactList`
    * Added: `Remove-GSContact`
* Other additions via [PR #108](https://github.com/scrthq/PSGSuite/pull/108) - _Thanks, [@dwrusse](https://github.com/dwrusse)!_
    * Added: `Remove-GSCalendarEvent`
    * Added: `New-GSGmailLabel`
    * Added: `Remove-GSGmailLabel`

## 2.17.2

* [Issue #103](https://github.com/scrthq/PSGSuite/issues/103)
    * Fixed: `SendNotificationEmail` is now correctly defaulting to `$false`, but attempting to actually send the notification email results in an error. This is now corrected.

## 2.17.1

* Validated deployment via Azure Pipelines

## 2.17.0

* [Issue #102](https://github.com/scrthq/PSGSuite/issues/102)
    * Fixed: `$EncryptionKey` PSM1 parameter now stores the AES key correctly so SecureStrings are encrypted/decrypted as intended.
* [Issue #103](https://github.com/scrthq/PSGSuite/issues/103)
    * Updated: `SendNotificationEmail` parameter on `Add-GSDrivePermission` defaults to false for all User & Group permissions that are not ownership transfers.
    * Updated: Documentation for `SendNotificationEmail` parameter on `Add-GSDrivePermission` for clarity towards default Google API parameter values.
* Added: More unit testing for `Get-GSUser`
* Updated: `psake` build script

## 2.16.1

* Fixed: Module deployment segment in psake script deploying decompiled/broken module

## 2.16.0

* Updated: Build script to compile module into a single PSM1 file for cleanliness and loading speed improvements

## 2.15.4

* [Issue #96](https://github.com/scrthq/PSGSuite/issues/96)
    * Updated the following on `Get-GSGroup`:
        * Set default scope to `Customer` so that getting the list of groups expectedly gets all of them, not just the ones in your primary domain
        * Added `Domain` parameter to specify which domain to list groups from your customer account
        * Added `Filter` parameter to only list groups matching the Group query syntax
        * Moved the `Get-GSGroupListPrivate` private function into the body of `Get-GSGroup` for error clarity
* Others:
    * Moved the `Get-GSUserListPrivate` private function into the body of `Get-GSUser` for error clarity
    * Improved error handling for User and Message List functions when there are no results.

## 2.15.3

* [Issue #87](https://github.com/scrthq/PSGSuite/issues/87)
    * Fixed `Add-GSCourseParticipant` error: `"Cannot convert the "student@uni.edu" value of type "System.String" to type "Google.Apis.Classroom.v1.Data.Student"."`
    * Set `$request.Fields = "*"` for `Get-GSCourseParticipant` and `Get-GSClassroomUserProfile` to return all available fields for the `Profile`, including `EmailAddress`
* [Issue #93](https://github.com/scrthq/PSGSuite/issues/93)
    * Added: `MaxToModify` parameter to `Remove-GSGmailMessage` and `Update-GSGmailMessageLabels` in the `Filter` parameter set to prevent removing/updating more messages than expected when using a filter to gather the list of messages to update.
* Added: `Id` alias for `User` parameter on `Get-GSUser` for better pipeline support

## 2.15.2

* [Pull Request #94](https://github.com/scrthq/PSGSuite/pull/94) **Thanks, [@dwrusse](https://github.com/dwrusse)!**
    * Added `Update-GSGmailLabel` to enable updating of Gmail label properties
    * Added `Update-GSGmailMessageLabels` enable updating of labels attached to Gmail messages
* [Issue #93](https://github.com/scrthq/PSGSuite/issues/93)
    * Updated `Remove-GSGmailMessage` to include a `-Filter` parameter to allow removal of messages matching a filter in a single command
    * Improved pipeline support for `Remove-GSGmailMessage`

## 2.15.1

* [Issue #87](https://github.com/scrthq/PSGSuite/issues/87)
    * Added `User` parameter to all Classroom functions to specify which user to authenticate the request as
* [Issue #90](https://github.com/scrthq/PSGSuite/issues/90)
    * Added `Update-GSUserPhoto`
    * Added `Remove-GSUserPhoto`

## 2.15.0

* Updated Gmail Delegation functions to use the .NET SDK after Google announced delegation support for the Gmail API
* Cleaned up `Get-GSGmailDelegates` by removing the trailing `s` (now `Get-GSGmailDelegate`). Added the original function as an alias to the new function for backwards compatibility with scripts.
* Removed the `Raw` parameter from `Get-GSGmailDelegate` since it's no longer applicable.
* Enabled `Get-GSGmailDelegate` to perform both Get and List requests (previously only performed List requests)

## 2.14.1

* [Issue #87](https://github.com/scrthq/PSGSuite/issues/87)
    * Removed `Add-Member` calls from `Get-GSCourseParticipant` to resolve item 3 on issue
    * Cleaned up `CourseStates` parameter on `Get-GSCourse` to validate against the Enum directly and removed the default parameter value to resolve item 2 on issue
    * Cleaned up `State` parameter on `Get-GSStudentGuardianInvitation` to validate against the Enum directly in an effort to prevent the same issue as item 2

## 2.14.0

* [Issue #85](https://github.com/scrthq/PSGSuite/issues/85)
    * Added Google Classroom support with the following functions:
        * `Add-GSCourseParticipant`
        * `Confirm-GSCourseInvitation`
        * `Get-GSClassroomUserProfile`
        * `Get-GSCourse`
        * `Get-GSCourseAlias`
        * `Get-GSCourseInvitation`
        * `Get-GSCourseParticipant`
        * `Get-GSStudentGuardian`
        * `Get-GSStudentGuardianInvitation`
        * `New-GSCourse`
        * `New-GSCourseAlias`
        * `New-GSCourseInvitation`
        * `New-GSStudentGuardianInvitation`
        * `Remove-GSCourse`
        * `Remove-GSCourseAlias`
        * `Remove-GSCourseInvitation`
        * `Remove-GSCourseParticipant`
        * `Remove-GSStudentGuardian`
        * `Update-GSCourse`
* Fixed: `Get-GSToken` Create/Expiry time split issue on macOS caused by difference in `-UFormat %s` (macOS doesn't have trailing milliseconds)
* Fixed: Logic in confirming if UserID is `[decimal]` to prevent unnecessary errors

## 2.13.2

* [Issue #83](https://github.com/scrthq/PSGSuite/issues/83)
    * Added: `Add-GSUserOrganization` to create UserOrganization objects
    * Updated: `Update-GSUser` and `New-GSUser` to include Organizations parameter and cleaned up logic for other Generic.List type parameters to ensure functionality

## 2.13.1

* Fixed: `Add-GSDrivePermission` fails to transfer ownership of files ([Issue #80](https://github.com/scrthq/PSGSuite/issues/80))

## 2.13.0

* Fixed: Private list functions to check if a value is actually returned before adding members to the returned objects ([Issue #77](https://github.com/scrthq/PSGSuite/issues/77))
* Added: `Update-GSChatMessage` to allow updating existing messages in Chat (i.e. on Card Clicked events)
* Updated: Order of parameters in `Get-GSToken` to place `Scopes` first, as it's the only required parameter
* Updated: `Get-GSChatSpace` now updates the config with Space names/shortnames for ease of use
* Updated: `Send-GSChatMessage` to also support calling the REST API as an additional option. This is necessary for PoshBot due to the deserialization of objects passed back to result parser breaking the Google SDK type references
* Updated: `Get-GSChatConfig` to always fetch the latest config if no ConfigName is passed instead of using `Show-PSGSuiteConfig`
* Updated: `Set-PSGSuiteConfig` to refresh the Spaces dictionary each time in order to remove stale spaces (i.e. on removal of bot from a Room or DM)
* Fixed: `Add-GSChatOnClick` now properly builds the hashtable for the Webhook object
* Updated: `Get-GSUser` to allow passing User ID's instead of emails by checking if value passed is a `decimal` before concatenating the domain name.

## 2.12.1

* Fixed: `Get-GSDrivePermission` now returns all fields (including EmailAddress)

## 2.12.0

* Added: `Get-GSChatMember`, `Get-GSChatMessage`, `Get-GSChatSpace`, `Remove-GSChatMessage`, `Send-GSChatMessage`, `Add-GSChatButton`, `Add-GSChatCard`, `Add-GSChatCardAction`, `Add-GSChatCardSection`, `Add-GSChatImage`, `Add-GSChatKeyValue`, `Add-GSChatOnClick`, `Add-GSChatTextParagraph`
    * These allow interaction with the Google Chat API via either Webhook or through the SDK
    * Using the Webhook requires no additional configuration as the Webhook includes the authentication key and token in the URL
    * Using the SDK requires additional configuration of the Bot in the Google Developer's console (Documentation soon to come)
* Added: `Get-GSChatConfig` to retrieve the Chat specific config data
* Updated: `Set-PSGSuiteConfig` & `Get-PSGSuiteConfig` to manage config dictionaries for Chat Webhook and Space data
* Updated: All .NET SDK DLL's to version 1.34 to work with the Hangouts Chat API

## 2.11.0

* Added: `Get-GSGmailSMIMEInfo`, `Remove-GSGmailSMIMEInfo` & `New-GSGmailSMIMEInfo` to get, delete and insert S/MIME info for a user, respectively ([Issue #57](https://github.com/scrthq/PSGSuite/issues/57))

## 2.10.2

* Added: `Get-GSDocContent`, `Set-GSDocContent` & `Add-GSDocContent` to establish functional parity with `Get-Content`, `Set-Content` & `Add-Content` in regards to working with Google Docs ([Issue #56](https://github.com/scrthq/PSGSuite/issues/56))

## 2.10.1

* Updated: Added `Path` parameter to `Update-GSDriveFile` to allow updating a file's contents in Drive using a local file path ([Issue #55](https://github.com/scrthq/PSGSuite/issues/55))

## 2.10.0

* Added: `Clear-GSTasklist`, `Get-GSTask`, `Get-GSTasklist`, `Move-GSTask`, `New-GSTask`, `New-GSTasklist`, `Remove-GSTask`, `Remove-GSTasklist`, `Update-GSTask` & `Update-GSTasklist`
    * These will allow full use of the Tasks API from Google.
    * **Please see the updated [Initial Setup guide](https://github.com/scrthq/PSGSuite/wiki/Initial-Setup#adding-api-client-access-in-admin-console) to update your API access for the new Scope list and enable the Tasks API in your project in the Developer Console!**

## 2.9.0

* Updated: Added `IsAdmin` switch parameter to `Update-GSUser`, allowing set or revoke SuperAdmin privileges for a user ([Issue #54](https://github.com/scrthq/PSGSuite/issues/54))
* Added: `Get-GSAdminRole`, `New-GSAdminRole`, `Remove-GSAdminRole`& `Update-GSAdminRole` to manage Admin Roles in G Suite ([Issue #54](https://github.com/scrthq/PSGSuite/issues/54))
* Added: `Get-GSAdminRoleAssignment`, `New-GSAdminRoleAssignment` & `Remove-GSAdminRoleAssignment` to manage Admin Role Assignments in G Suite ([Issue #54](https://github.com/scrthq/PSGSuite/issues/54))

## 2.8.1

* Fixed: `Get-GSGroup` failing when using `List` ParameterSet and the `Fields` Parameter ([Issue #63](https://github.com/scrthq/PSGSuite/issues/63))

## 2.8.0

* Added: `Remove-GSDrivePermission`. Thanks to [Jeremy McGee](https://github.com/jeremymcgee73)!

## 2.7.2

* Fixed: `Get-GSDrivePermission` fails when attempting to get Team Drive permissions.

## 2.7.1

* Fixed: `Update-GSCalendarEvent` had default values set for LocalStartDateTime and LocalEndDateTime parameters, causing those to always update the event unexpectedly if a start and/or end datetime was not passed when running the command ([Issue #59](https://github.com/scrthq/PSGSuite/issues/59))

## 2.7.0

* Added: `Get-GSCalendarACL` and `New-GSCalendarACL` for pulling/adding calendar ACL's.

## 2.6.3

* Fixed: `Export-GSDriveFile -OutFilePath C:\doc.pdf -Type PDF` failing due to incorrect parameter validation.  ([Issue #51](https://github.com/scrthq/PSGSuite/issues/51))

## 2.6.2

* Added: `Get-GSGmailProfile` and `Get-GSDriveProfile` to pull down information for a user's Gmail or Drive account.

## 2.6.1

* Fixed: `Add-GSDrivePermission` error messages stating FileId is ReadOnly. ([Issue #47](https://github.com/scrthq/PSGSuite/issues/47))
* Fixed: `Get-GSGmailMessage -ParseMessage` broken on non-Windows OS's due to using $env:TEMP. Switched to converting the MimeMessage to a stream and parsing it that way for resolution and significant perf gains. ([Issue #48](https://github.com/scrthq/PSGSuite/issues/48))

## 2.6.0

* Added: `Compare-ModuleVersion` function to get latest installed version and compare against the latest version on the PSGallery ([Issue #44](https://github.com/scrthq/PSGSuite/issues/44))
* Fixed: Pipeline support, so you can do things like the following and get group, group member and user details (as an example) easily ([Issue #45](https://github.com/scrthq/PSGSuite/issues/45)):
```powershell
#much pipe
$users = Get-GSGroup $groupEmail -Verbose -OutVariable group | Get-GSGroupMember -Verbose -OutVariable members | Get-GSUser -Verbose

#contains the group's info
$group

#contains the group members' info
$members

#contains the group members' full user info
$users
```

## 2.5.4

* Added: `CustomSchemas` parameter to `New-GSUser` (Resolve [Issue #42](https://github.com/scrthq/PSGSuite/issues/42))

## 2.5.3

* Fixed/Added: Specific domain support for listing users with `Get-GSUser -Filter $filter -Domain domain2.com` to allow customers with multiple domains to only list users for a specific domain instead of just the entire customer or domain saved in the config. (Resolve [Issue #32](https://github.com/scrthq/PSGSuite/issues/32))
* Added: Better verbose output in when listing users
* Fixed: Performance increase in `Get-GSDriveFileList` but returning DriveFile objects as it iterates through each page instead of storing in an array and returning the array at the end (Resolve [Issue #38](https://github.com/scrthq/PSGSuite/issues/38))

## 2.5.2

* Fixed: `Update-GSUser -CustomSchemas @{schema = @{field = "value"}}` resulting in null array (Resolve [Issue #39](https://github.com/scrthq/PSGSuite/issues/39))

## 2.5.1

* Fixed: `Add-GSGmailDelegate` and `Remove-GSGmailDelegate` returning 400 Bad Request responses (Resolve [Issue #35](https://github.com/scrthq/PSGSuite/issues/35))

## 2.5.0

* Added: Custom Schema value setting for `Update-GSUser`
* Fixed: `Get-GSUser -Filter *` not returning the full user list with large organizations (Resolve [Issue #32](https://github.com/scrthq/PSGSuite/issues/32))

## 2.4.0

* Added: Refactored Get-GSToken to work on all versions of PowerShell and confirmed Gmail Delegation commands working in PowerShell Core (Resolve [Issue #8](https://github.com/scrthq/PSGSuite/issues/8))

## 2.3.0

* Added: `Get-GSUserAlias`,`New-GSUserAlias`,`Remove-GSUserAlias` for user alias management
* Added: `Get-GSGroupAlias`,`New-GSGroupAlias`,`Remove-GSGroupAlias` for group alias management
* Added: `Get-GSCalendarSubscription`, `Add-GSCalendarSubscription` and `Remove-GSCalendarSubscription` for managing calendar list entries
* Updated: `Start-GSDriveFileUpload` to fix recursive issues with trailing directory separators
* Updated: `Watch-GSDriveFileUpload` to show progress of total file upload vs batch upload

## 2.2.1

* Fixed: `Update-GSGmailAutoForwardingSettings` returns a 403 due to incorrect scope [#25](https://github.com/scrthq/PSGSuite/issues/25)

## 2.2.0

Added the following:

* Functions
    * Get-GSGmailAutoForwardingSettings
    * Get-GSGmailImapSettings
    * Get-GSGmailPopSettings
    * Get-GSGmailVacationSettings
    * Update-GSGmailAutoForwardingSettings
    * Update-GSGmailImapSettings
    * Update-GSGmailPopSettings
    * Update-GSGmailVacationSettings
* CI Testing
    * Added Travis CI testing for both Linux and macOS tests along with the existing AppVeyor CI testing on Ubuntu (PowerShell Core) Windows (PowerShell Core and Windows PowerShell)

## 2.1.5

* Added: Update-GSCalendarEvent
* Fixed: Error handling to only throw terminating errors when ErrorActionPreference is `Stop`****

## 2.1.3 / 2.1.4

* Fixed: Export-GSSheet -Value results in error [#19](https://github.com/scrthq/PSGSuite/issues/19)
* Updated: Added `-Attendees` and `-AttendeeEmails` parameters to New-GSCalendarEvent
* Added: Add-GSEventAttendee
* Added: Get-GSActivityReport
* Added: Get-GSUsageReport
* Added: Add-GSGmailForwardingAddress

## 2.1.2

* Fixed: Module to load only public functions

## 2.1.1

* Fixed: Documentation/comment based help for Get-GSUsageReport

## 2.1.0

* Added: Get-GSActivityReport
* Added: Get-GSUsageReport
* Updated: Initial setup page to include Reports scopes

## 2.0.3

* Fixed: Error when using -CalendarID with Get-GSCalendarEventList [#17](https://github.com/scrthq/PSGSuite/issues/17)
* Fixed: Update-GSUser failing to update OrgUnitPath [#18](https://github.com/scrthq/PSGSuite/issues/18)
* Added: -Attendees parameter to New-GSCalendarEvent
* Added: Add-GSEventAttendee helper function

## 2.0.2

* Fixed: Issue with Add-GSUserExternalId [#14](https://github.com/scrthq/PSGSuite/issues/14)

## 2.0.1

* Fixed: Set-PSGSuiteConfig not accepting pipeline input [#13](https://github.com/scrthq/PSGSuite/issues/13)

## 2.0.0

### New Functionality

* PowerShell Core/cross-platform support added
* All Drive functions now support Team Drives
* Get-GSGmailMessage can now save message attachments to a local path
* File uploads to Drive are now supported (including recursive folder uploads!)
* P12 Keys (service accounts) _and_ client_secrets.json (OAuth) are both now supported

### Breaking Changes in 2.0.0

#### Gmail Delegation Management Removed

~~The Gmail API does not yet support handling inbox delegation. The functionality addition has been pushed back again until Q3 of 2018. Once the Gmail API supports inbox delegation, those functions will be added.~~

**Delegation functions have been re-added to PSGSuite as of v2.4.0! Update now to get all the goodness of v2 + delegation commands!**

#### Functions Removed

Please note that not all functions were ported to PSGSuite 2.0.0 due to restrictions within the .NET SDK and deprecated API calls. Here is the list of functions no longer existing in PSGSuite as of 2.0.0:

* Get-GSToken: no need for this as the keys are being consumed by Googles Auth SDK directly now, which makes Access/Refresh tokens non-existent for P12 Key service accounts and token management is handled automatically
* Revoke-GSToken: same here, no longer needed due to auth service changes
* Start-PSGSuiteConfigWizard: no longer supported as WPF is not compatible outside of Windows


#### Functions Aliased

All other functions are either intact or have an alias included to support backwards compatibility in scripts. Full list of aliases:

```
Alias                             Maps To
-----                             -------
Add-GSDriveFilePermissions        Add-GSDrivePermission
Export-PSGSuiteConfiguration      Set-PSGSuiteConfig
Get-GSCalendarResourceList        Get-GSResourceList
Get-GSDataTransferApplicationList Get-GSDataTransferApplication
Get-GSDriveFileInfo               Get-GSDriveFile
Get-GSDriveFilePermissionsList    Get-GSDrivePermission
Get-GSGmailFilterList             Get-GSGmailFilter
Get-GSGmailLabelList              Get-GSGmailLabel
Get-GSGmailMessageInfo            Get-GmailMessage
Get-GSGroupList                   Get-GSGroup
Get-GSGroupMemberList             Get-GSGroupMember
Get-GSMobileDeviceList            Get-GSMobileDevice
Get-GSOrganizationalUnitList      Get-GSOrganizationalUnit
Get-GSOrgUnit                     Get-GSOrganizationalUnit
Get-GSOrgUnitList                 Get-GSOrganizationalUnit
Get-GSOU                          Get-GSOrganizationalUnit
Get-GSResourceList                Get-GSResource
Get-GSShortURLInfo                Get-GSShortURL
Get-GSTeamDrivesList              Get-GSTeamDrive
Get-GSUserASPList                 Get-GSUserASP
Get-GSUserLicenseInfo             Get-GSUserLicense
Get-GSUserLicenseList             Get-GSUserLicense
Get-GSUserList                    Get-GSUser
Get-GSUserSchemaInfo              Get-GSUserSchema
Get-GSUserSchemaList              Get-GSUserSchema
Get-GSUserTokenList               Get-GSUserToken
Import-PSGSuiteConfiguration      Get-PSGSuiteConfig
Move-GSGmailMessageToTrash        Remove-GSGmailMessage
New-GSCalendarResource            New-GSResource
Remove-GSGmailMessageFromTrash    Restore-GSGmailMessage
Set-PSGSuiteDefaultDomain         Switch-PSGSuiteConfig
Switch-PSGSuiteDomain             Switch-PSGSuiteConfig
Update-GSCalendarResource         Update-GSResource
Update-GSSheetValue               Export-GSSheet
```

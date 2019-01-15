# Changelog

* [Changelog](#changelog)
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

# PSGSuite
<div align="center">
<img src="bin/img/psgsuite2.0.0.png" alt="PSGSuite 2.0.0 released!" />
</br>
</br>
  <!-- Azure Pipelines -->
  <a href="https://dev.azure.com/scrthq/SCRT%20HQ/_build/latest?definitionId=2">
    <img src="https://dev.azure.com/scrthq/SCRT%20HQ/_apis/build/status/PSGSuite-CI"
      alt="Azure Pipelines" title="Azure Pipelines" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- Codacy -->
  <a href="https://www.codacy.com/app/scrthq/PSGSuite?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=scrthq/PSGSuite&amp;utm_campaign=Badge_Grade">
    <img src="https://api.codacy.com/project/badge/Grade/0d5203a1cf1945fe94c46b779eecb7f0"
      alt="Codacy" title="Codacy" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- PS Gallery -->
  <a href="https://www.PowerShellGallery.com/packages/PSGSuite">
    <img src="https://img.shields.io/powershellgallery/dt/PSGSuite.svg?style=flat"
      alt="PowerShell Gallery" title="PowerShell Gallery" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- Gitter -->
  <a href="https://gitter.im/PSGSuite/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge">
    <img src="https://badges.gitter.im/PSGSuite/Lobby.svg"
      alt="Gitter - Chat" title="Gitter - Chat" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- Slack -->
  <a href="https://scrthq-slack-invite.herokuapp.com/">
    <img src="https://img.shields.io/badge/chat-on%20slack-orange.svg?style=flat&logo=slack"
      alt="Slack - Chat" title="Slack - Chat" />
  </a>
</div>
<br />

***

## Documentation

Check out the [GitHub wiki for PSGSuite](https://github.com/scrthq/PSGSuite/wiki) for help with setting up as well as full function help!

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
Get-GSCalendarEventList           Get-GSCalendarEvent
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

### Most recent changes

#### 2.21.3

* [Issue #131](https://github.com/scrthq/PSGSuite/issues/131)
  * Fixed: Changed `CodeReceiver` to use `PromptCodeReceiver` when client is PowerShell Core, as `LocalServerCodeReceiver` does not appear to redirect correctly and auth fails. Same behavior in Core regardless of OS.
* Miscellaneous
  * Added: `OutputType` to all functions that return standard objects.

#### 2.21.2

* [Issue #136](https://github.com/scrthq/PSGSuite/issues/136)
  * Fixed: `Start-GSDriveFileUpload` failing when specifying a user other than the Admin user to do the upload as.

#### 2.21.1

* [Issue #131](https://github.com/scrthq/PSGSuite/issues/131) - _Free/standard Google Account support_
  * Fixed: Handling of scopes in `New-GoogleService` for authentication when a client_secrets.json file is used instead of the typical .p12 key.
  * Updated: Documentation to show how to use an account that is not a G Suite admin or G Suite user at all with PSGSuite
  * Updated: `*-PSGSuiteConfig` commands now store the client_secrets.json string contents directly on the encrypted config once provided either the path or the string contents directly, allowing users to remove any plain text credentials once loaded into the encrypted config.
  * Updated: `Get-GSToken` now uses `New-GoogleService` under the hood, so `client_secrets.json` will work with Contacts API.

#### 2.21.0

* [PR #130](https://github.com/scrthq/PSGSuite/pull/130) / [Issue #129](https://github.com/scrthq/PSGSuite/issues/129)
  * Added: Support for UserRelations management in `New-GSUser -Relations $relations` and `Update-GSUser -Relations $relations` via `Add-GSUserRelation` helper function. - _Thanks, [@mattwoolnough](https://github.com/mattwoolnough)!_
  * Added: Logic to `Update-GSUser` to enable clearing of all values for user properties `Phones`, `ExternalIds`, `Organizations`, and `Relations` by REST API call via passing `$null` as the value when calling `Update-GSUser`. - _Thanks, [@mattwoolnough](https://github.com/mattwoolnough)!_
* [Issue #129](https://github.com/scrthq/PSGSuite/issues/129)
  * Fixed: Documentation for `Get-GSSheetInfo` around the `Fields` parameter.
  * Added: Additional correction of casing for `Fields` values in `Get-GSSheetInfo` so that it will always submit the values using the correct case, even if providing the incorrect case as the value to the parameter.

#### 2.20.2

* [Issue #128](https://github.com/scrthq/PSGSuite/issues/128)
  * Added: `Update-GSMobileDevice` to allow taking action on Mobile Devices
  * Fixed: Bug in `Remove-GSMobileDevice` with incorrect variable name

#### 2.20.1

* [Issue #121](https://github.com/scrthq/PSGSuite/issues/121)
  * Added: `Update-GSGroupMember` to allow setting a group member's Role and/or DeliverySettings
* Miscellaneous
  * Added: GitHub release automation to deploy task
  * Added: Twitter update automation on new version release to deploy task

#### 2.20.0

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

#### 2.19.0

* [PR #113](https://github.com/scrthq/PSGSuite/pull/113)
  * Added: `Add-GSUserEmail` to support the Emails property. - _Thanks, [@sguilbault-sherweb](https://github.com/sguilbault-sherweb)!_
  * Updated: `Add-GSUser` and `Update-GSUser` to implement the newly supported `Emails` property. - _Thanks, [@sguilbault-sherweb](https://github.com/sguilbault-sherweb)!_
  * Fixed: Removed `if ($PSCmdlet.ParameterSetName -eq 'Get')` from `New-GSAdminRoleAssignment` that was making the cmdlet fail. - _Thanks, [@sguilbault-sherweb](https://github.com/sguilbault-sherweb)!_
  * Fixed: `New-GSAdminRoleAssignment` help section rewrite. (The help of this function was a copy of the `Get-GSAdminRoleAssignment` cmdlet) - _Thanks, [@sguilbault-sherweb](https://github.com/sguilbault-sherweb)!_

#### 2.18.1

* [Issue #87](https://github.com/scrthq/PSGSuite/issues/87)
  * Added: Additional scopes during Service creation for `Get-GSCourseParticipant` and `Get-GSClassroomUserProfile` to enable pulling of full user profile information. - _Thanks, [@jdstanberry](https://github.com/jdstanberry)!_
* [Issue #111](https://github.com/scrthq/PSGSuite/issues/111)
  * Added: `DisableReminder` switch parameter to `New-GSCalendarEvent` and `Update-GSCalendarEvent` to remove Reminder inheritance from the calendar the event is on as well as any Reminder overload definitions.
* [Issue #53](https://github.com/scrthq/PSGSuite/issues/53)
  * Updated: `Get-GSContactList` and `Remove-GSContact` Token retrieval and overall cleanup
* Various/Other
  * Updated: `Get-GSToken` to align parameters more with `New-GoogleService`

#### 2.18.0

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

#### 2.17.2

* [Issue #103](https://github.com/scrthq/PSGSuite/issues/103)
  * Fixed: `SendNotificationEmail` is now correctly defaulting to `$false`, but attempting to actually send the notification email results in an error. This is now corrected.

#### 2.17.1

* Validated deployment via Azure Pipelines

#### 2.17.0

* [Issue #102](https://github.com/scrthq/PSGSuite/issues/102)
  * Fixed: `$EncryptionKey` PSM1 parameter now stores the AES key correctly so SecureStrings are encrypted/decrypted as intended.
* [Issue #103](https://github.com/scrthq/PSGSuite/issues/103)
  * Updated: `SendNotificationEmail` parameter on `Add-GSDrivePermission` defaults to false for all User & Group permissions that are not ownership transfers.
  * Updated: Documentation for `SendNotificationEmail` parameter on `Add-GSDrivePermission` for clarity towards default Google API parameter values.
* Moved: `Get-GSToken` and `New-GoogleService` to Public functions under the Authentication section
* Added: More unit testing for `Get-GSUser`
* Updated: `psake` build script

#### 2.16.1

* Fixed: Module deployment segment in psake script deploying decompiled/broken module

#### 2.16.0

* Updated: Build script to compile module into a single PSM1 file for cleanliness and loading speed improvements

#### 2.15.4

* [Issue #96](https://github.com/scrthq/PSGSuite/issues/96)
  * Updated the following on `Get-GSGroup`:
    * Set default scope to `Customer` so that getting the list of groups expectedly gets all of them, not just the ones in your primary domain
    * Added `Domain` parameter to specify which domain to list groups from your customer account
    * Added `Filter` parameter to only list groups matching the Group query syntax
    * Moved the `Get-GSGroupListPrivate` private function into the body of `Get-GSGroup` for error clarity
* Others:
  * Moved the `Get-GSUserListPrivate` private function into the body of `Get-GSUser` for error clarity
  * Improved error handling for User and Message List functions when there are no results.

#### 2.15.3

* [Issue #87](https://github.com/scrthq/PSGSuite/issues/87)
  * Fixed `Add-GSCourseParticipant` error: `"Cannot convert the "student@uni.edu" value of type "System.String" to type "Google.Apis.Classroom.v1.Data.Student"."`
  * Set `$request.Fields = "*"` for `Get-GSCourseParticipant` and `Get-GSClassroomUserProfile` to return all available fields for the `Profile`, including `EmailAddress`
* [Issue #93](https://github.com/scrthq/PSGSuite/issues/93)
  * Added: `MaxToModify` parameter to `Remove-GSGmailMessage` and `Update-GSGmailMessageLabels` in the `Filter` parameter set to prevent removing/updating more messages than expected when using a filter to gather the list of messages to update.
* Added: `Id` alias for `User` parameter on `Get-GSUser` for better pipeline support

#### 2.15.2

* [Pull Request #94](https://github.com/scrthq/PSGSuite/pull/94) **Thanks, [@dwrusse](https://github.com/dwrusse)!**
  * Added `Update-GSGmailLabel` to enable updating of Gmail label properties
  * Added `Update-GSGmailMessageLabel` enable updating of labels attached to Gmail messages
* [Issue #93](https://github.com/scrthq/PSGSuite/issues/93)
  * Updated `Remove-GSGmailMessage` to include a `-Filter` parameter to allow removal of messages matching a filter in a single command
  * Improved pipeline support for `Remove-GSGmailMessage`

#### 2.15.1

* [Issue #87](https://github.com/scrthq/PSGSuite/issues/87)
  * Added `User` parameter to all Classroom functions to specify which user to authenticate the request as
* [Issue #90](https://github.com/scrthq/PSGSuite/issues/90)
  * Added `Update-GSUserPhoto`
  * Added `Remove-GSUserPhoto`

#### 2.15.0

* Updated Gmail Delegation functions to use the .NET SDK after Google announced delegation support for the Gmail API
* Cleaned up `Get-GSGmailDelegates` by removing the trailing `s` (now `Get-GSGmailDelegate`). Added the original function as an alias to the new function for backwards compatibility with scripts.
* Removed the `Raw` parameter from `Get-GSGmailDelegate` since it's no longer applicable.
* Enabled `Get-GSGmailDelegate` to perform both Get and List requests (previously only performed List requests)

#### 2.14.1

* [Issue #87](https://github.com/scrthq/PSGSuite/issues/87)
  * Removed `Add-Member` calls from `Get-GSCourseParticipant` to resolve item 3 on issue
  * Cleaned up `CourseStates` parameter on `Get-GSCourse` to validate against the Enum directly and removed the default parameter value to resolve item 2 on issue
  * Cleaned up `State` parameter on `Get-GSStudentGuardianInvitation` to validate against the Enum directly in an effort to prevent the same issue as item 2

#### 2.14.0

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

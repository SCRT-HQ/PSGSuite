# PSGSuite
<div align="center">
<img src="bin/img/psgsuite2.0.0.png" alt="PSGSuite 2.0.0 released!" />
</br>
</br>
  <!-- AppVeyor -->
  <a href="https://ci.appveyor.com/project/scrthq/psgsuite/branch/master">
    <img src="https://ci.appveyor.com/api/projects/status/u6pgrn4cs8iagcee/branch/master?svg=true"
      alt="AppVeyor" title="AppVeyor" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- Travis CI -->
  <a href="https://travis-ci.org/scrthq/PSGSuite">
    <img src="https://travis-ci.org/scrthq/PSGSuite.svg?branch=master"
      alt="Travis CI" title="Travis CI" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- PS Gallery -->
  <a href="https://www.PowerShellGallery.com/packages/PSGSuite">
    <img src="https://img.shields.io/powershellgallery/dt/PSGSuite.svg?style=flat"
      alt="PowerShell Gallery - Install PSGSuite" title="PowerShell Gallery - Install PSGSuite" />
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

## Changelog

[Full CHANGELOG here](https://github.com/scrthq/PSGSuite/blob/master/CHANGELOG.md)

### Most recent changes

#### 2.7.2

* Fixed: `Get-GSDrivePermission` fails when attempting to get Team Drive permissions.

#### 2.7.1

* Fixed: `Update-GSCalendarEvent` had default values set for LocalStartDateTime and LocalEndDateTime parameters, causing those to always update the event unexpectedly if a start and/or end datetime was not passed when running the command ([Issue #59](https://github.com/scrthq/PSGSuite/issues/59))

#### 2.7.0

* Added: `Get-GSCalendarACL` and `New-GSCalendarACL` for pulling/adding calendar ACL's.

#### 2.6.3

* Fixed: `Export-GSDriveFile -OutFilePath C:\doc.pdf -Type PDF` failing due to incorrect parameter validation.  ([Issue #51](https://github.com/scrthq/PSGSuite/issues/51))

#### 2.6.2

* Added: `Get-GSGmailProfile` and `Get-GSDriveProfile` to pull down information for a user's Gmail or Drive account.

#### 2.6.1

* Fixed: `Add-GSDrivePermission` error messages stating FileId is ReadOnly. ([Issue #47](https://github.com/scrthq/PSGSuite/issues/47))
* Fixed: `Get-GSGmailMessage -ParseMessage` broken on non-Windows OS's due to using $env:TEMP. Switched to converting the MimeMessage to a stream and parsing it that way for resolution and significant perf gains. ([Issue #48](https://github.com/scrthq/PSGSuite/issues/48))

#### 2.6.0

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

#### 2.5.4

* Added: `CustomSchemas` parameter to `New-GSUser` (Resolve [Issue #42](https://github.com/scrthq/PSGSuite/issues/42))

#### 2.5.3

* Fixed/Added: Specific domain support for listing users with `Get-GSUser -Filter $filter -Domain domain2.com` to allow customers with multiple domains to only list users for a specific domain instead of just the entire customer or domain saved in the config. (Resolve [Issue #32](https://github.com/scrthq/PSGSuite/issues/32))
* Added: Better verbose output in when listing users
* Fixed: Performance increase in `Get-GSDriveFileList` but returning DriveFile objects as it iterates through each page instead of storing in an array and returning the array at the end (Resolve [Issue #38](https://github.com/scrthq/PSGSuite/issues/38))

#### 2.5.2

* Fixed: `Update-GSUser -CustomSchemas @{schema = @{field = "value"}}` resulting in null array (Resolve [Issue #39](https://github.com/scrthq/PSGSuite/issues/39))

#### 2.5.1

* Fixed: `Add-GSGmailDelegate` and `Remove-GSGmailDelegate` returning 400 Bad Request responses (Resolve [Issue #35](https://github.com/scrthq/PSGSuite/issues/35))

#### 2.5.0

* Added: Custom Schema value setting for `Update-GSUser`
* Fixed: `Get-GSUser -Filter *` not returning the full user list with large organizations (Resolve [Issue #32](https://github.com/scrthq/PSGSuite/issues/32))

#### 2.4.0

* Added: Refactored Get-GSToken to work on all versions of PowerShell and confirmed Gmail Delegation commands working in PowerShell Core (Resolve [Issue #8](https://github.com/scrthq/PSGSuite/issues/8))

#### 2.3.0

* Added: `Get-GSUserAlias`,`New-GSUserAlias`,`Remove-GSUserAlias` for user alias management
* Added: `Get-GSGroupAlias`,`New-GSGroupAlias`,`Remove-GSGroupAlias` for group alias management
* Added: `Get-GSCalendarSubscription`, `Add-GSCalendarSubscription` and `Remove-GSCalendarSubscription` for managing calendar list entries
* Updated: `Start-GSDriveFileUpload` to fix recursive issues with trailing directory separators
* Updated: `Watch-GSDriveFileUpload` to show progress of total file upload vs batch upload

#### 2.2.1

* Fixed: `Update-GSGmailAutoForwardingSettings` returns a 403 due to incorrect scope [#25](https://github.com/scrthq/PSGSuite/issues/25)

#### 2.2.0

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

#### 2.1.5

* Added: Update-GSCalendarEvent
* Fixed: Error handling to only throw terminating errors when ErrorActionPreference is `Stop`

#### 2.1.3 / 2.1.4

* Fixed: Export-GSSheet -Value results in error [#19](https://github.com/scrthq/PSGSuite/issues/19)
* Updated: Added `-Attendees` and `-AttendeeEmails` parameters to New-GSCalendarEvent
* Added: Add-GSEventAttendee
* Added: Get-GSActivityReport
* Added: Get-GSUsageReport
* Added: Add-GSGmailForwardingAddress

#### 2.1.2

* Fixed: Module to load only public functions

#### 2.1.1

* Fixed: Documentation/comment based help for Get-GSUsageReport

#### 2.1.0

* Added: Get-GSActivityReport
* Added: Get-GSUsageReport
* Updated: Initial setup page to include Reports scopes

## License

[Apache 2.0](https://tldrlegal.com/license/apache-license-2.0-(apache-2.0))

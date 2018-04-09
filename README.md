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

The Gmail API does not yet support handling inbox delegation. The functionality addition has been pushed back again until Q3 of 2018. Once the Gmail API supports inbox delegation, those functions will be added.

* Please subscribe to [Issue #8](https://github.com/scrthq/PSGSuite/issues/8) for updates on this topic
* If you have scripts running that use the delegation functions, please have those scripts explicitly import the legacy version or avoid updating to 2.0.0 altogether until 2.1.0 is released with the delegation functions working.
* Delegation functions for reference:
    * Add-GSGmailDelegate
    * Get-GSGmailDelegates
    * Remove-GSGmailDelegate

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

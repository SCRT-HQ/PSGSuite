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

## Contributing

Interested in helping out with PSGSuite development? Please check out our [Contribution Guidelines](https://github.com/scrthq/PSGSuite/blob/master/CONTRIBUTING.md)!

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

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

#### 2.10.2

* Added: `Get-GSDocContent`, `Set-GSDocContent` & `Add-GSDocContent` to establish functional parity with `Get-Content`, `Set-Content` & `Add-Content` in regards to working with Google Docs ([Issue #56](https://github.com/scrthq/PSGSuite/issues/56))

#### 2.10.1

* Updated: Added `Path` parameter to `Update-GSDriveFile` to allow updating a file's contents in Drive using a local file path.

#### 2.10.0

* Added: `Clear-GSTasklist`, `Get-GSTask`, `Get-GSTasklist`, `Move-GSTask`, `New-GSTask`, `New-GSTasklist`, `Remove-GSTask`, `Remove-GSTasklist`, `Update-GSTask` & `Update-GSTasklist`
  * These will allow full use of the Tasks API from Google.
  * **Please see the updated [Initial Setup guide](https://github.com/scrthq/PSGSuite/wiki/Initial-Setup#adding-api-client-access-in-admin-console) to update your API access for the new Scope list and enable the Tasks API in your project in the Developer Console!**

#### 2.9.0

* Updated: Added `IsAdmin` switch parameter to `Update-GSUser`, allowing set or revoke SuperAdmin privileges for a user ([Issue #54](https://github.com/scrthq/PSGSuite/issues/54))
* Added: `Get-GSAdminRole`, `New-GSAdminRole`, `Remove-GSAdminRole`& `Update-GSAdminRole` to manage Admin Roles in G Suite ([Issue #54](https://github.com/scrthq/PSGSuite/issues/54))
* Added: `Get-GSAdminRoleAssignment`, `New-GSAdminRoleAssignment` & `Remove-GSAdminRoleAssignment` to manage Admin Role Assignments in G Suite ([Issue #54](https://github.com/scrthq/PSGSuite/issues/54))

#### 2.8.1

* Fixed: `Get-GSGroup` failing when using `List` ParameterSet and the `Fields` Parameter ([Issue #63](https://github.com/scrthq/PSGSuite/issues/63))

#### 2.8.0

* Added: `Remove-GSDrivePermission`. Thanks to [Jeremy McGee](https://github.com/jeremymcgee73)!

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

# Changelog 

<!-- TOC -->

- [Changelog](#changelog)
    - [2.2.0](#220)
    - [2.1.5](#215)
    - [2.1.3 / 2.1.4](#213-214)
    - [2.1.2](#212)
    - [2.1.1](#211)
    - [2.1.0](#210)
    - [2.0.3](#203)
    - [2.0.2](#202)
    - [2.0.1](#201)
    - [2.0.0](#200)
        - [New Functionality](#new-functionality)
        - [Breaking Changes in 2.0.0](#breaking-changes-in-200)
            - [Gmail Delegation Management Removed](#gmail-delegation-management-removed)
            - [Functions Removed](#functions-removed)
            - [Functions Aliased](#functions-aliased)

<!-- /TOC -->

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
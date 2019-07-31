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
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- Codacy -->
  <a href="https://www.codacy.com/app/scrthq/PSGSuite?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=scrthq/PSGSuite&amp;utm_campaign=Badge_Grade">
    <img src="https://api.codacy.com/project/badge/Grade/0d5203a1cf1945fe94c46b779eecb7f0"
      alt="Codacy" title="Codacy" />
  </a>
  </br>
  </br>
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

#### 2.31.0

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

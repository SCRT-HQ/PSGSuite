# PSGSuite-2.0.0

## NOTE

The module in **_this_ branch** is named `PSGSuite2`; this is a working module name to allow side-by-side comparison's with the current release while developing the next major version. The final 2.0.0 release will still be named `PSGSuite` once pushed to the PowerShell Gallery.


## Remaining TODO's

### Functions To Convert/Build

| Function                       | Conversion | New   | Complete |
| :----------------------------: | :--------: | :---: | :------: |
| Add-GSGmailDelegate            | ✔️         |       | ❌       |
| Add-GSGmailFilter              | ✔️         |       | ✔️       |
| Get-GSGmailDelegates           | ✔️         |       | ❌       |
| Get-GSGmailFilterList          | ✔️         |       | ❌       |
| Get-GSGmailLabelList           | ✔️         |       | ❌       |
| Remove-GSGmailDelegate         | ✔️         |       | ❌       |
| Remove-GSGmailFilter           | ✔️         |       | ❌       |
| Add-GSDriveFilePermissions     | ✔️         |       | ❌       |
| Clear-GSSheet                  | ✔️         |       | ❌       |
| Copy-GSDriveFile               | ✔️         |       | ❌       |
| Copy-GSSheet                   | ✔️         |       | ❌       |
| Get-GSDriveFile                | ✔️         |       | ❌       |
| Get-GSDriveFileInfo            | ✔️         |       | ❌       |
| Get-GSDriveFileList            | ✔️         |       | ❌       |
| Get-GSDriveFilePermissionsList | ✔️         |       | ❌       |
| Get-GSSheetInfo                | ✔️         |       | ❌       |
| Get-GSTeamDrive                | ✔️         |       | ❌       |
| Get-GSTeamDrivesList           | ✔️         |       | ❌       |
| Import-GSSheet                 | ✔️         |       | ❌       |
| New-GSDriveFile                | ✔️         |       | ❌       |
| New-GSSheet                    | ✔️         |       | ❌       |
| New-GSTeamDrive                | ✔️         |       | ❌       |
| Remove-GSTeamDrive             | ✔️         |       | ❌       |
| Update-GSDriveFile             | ✔️         |       | ❌       |
| Update-GSSheetValue            | ✔️         |       | ❌       |
| Update-GSTeamDrive             | ✔️         |       | ❌       |
| Copy-ToGSDrive                 |            | ✔️    | ❌       |

### Other Tasks

- [ ] Update documentation
- [ ] Build out ChangeLog to document any breaking changes
- [ ] Update Pester Tests
- [ ] Add in CI configuration for AppVeyor
    - [ ] Build out Travis CI tests for Linux/macOS?
- [ ] Clean up PSGSuite2 to PSGSuite in prep for deployment to PSGallery
- [ ] DEPLOY PSGSuite 2.0.0!
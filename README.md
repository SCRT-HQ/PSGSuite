# PSGSuite-2.0.0

## NOTE

The module in **_this_ branch** is named `PSGSuite2`; this is a working module name to allow side-by-side comparison's with the current release while developing the next major version. The final 2.0.0 release will still be named `PSGSuite` once pushed to the PowerShell Gallery.


## Remaining TODO's

### Functions To Convert/Build

| Function                       | Conversion | New      | Complete |
| :----------------------------: | :--------: | :------: | :------: |
| Add-GSGmailDelegate            | &#x2714;   |          | &#x274C; |
| Add-GSGmailFilter              | &#x2714;   |          | &#x274C; |
| Get-GSGmailDelegates           | &#x2714;   |          | &#x274C; |
| Get-GSGmailFilterList          | &#x2714;   |          | &#x274C; |
| Get-GSGmailLabelList           | &#x2714;   |          | &#x274C; |
| Remove-GSGmailDelegate         | &#x2714;   |          | &#x274C; |
| Remove-GSGmailFilter           | &#x2714;   |          | &#x274C; |
| Add-GSDriveFilePermissions     | &#x2714;   |          | &#x274C; |
| Clear-GSSheet                  | &#x2714;   |          | &#x274C; |
| Copy-GSDriveFile               | &#x2714;   |          | &#x274C; |
| Copy-GSSheet                   | &#x2714;   |          | &#x274C; |
| Get-GSDriveFile                | &#x2714;   |          | &#x274C; |
| Get-GSDriveFileInfo            | &#x2714;   |          | &#x274C; |
| Get-GSDriveFileList            | &#x2714;   |          | &#x274C; |
| Get-GSDriveFilePermissionsList | &#x2714;   |          | &#x274C; |
| Get-GSSheetInfo                | &#x2714;   |          | &#x274C; |
| Get-GSTeamDrive                | &#x2714;   |          | &#x274C; |
| Get-GSTeamDrivesList           | &#x2714;   |          | &#x274C; |
| Import-GSSheet                 | &#x2714;   |          | &#x274C; |
| New-GSDriveFile                | &#x2714;   |          | &#x274C; |
| New-GSSheet                    | &#x2714;   |          | &#x274C; |
| New-GSTeamDrive                | &#x2714;   |          | &#x274C; |
| Remove-GSTeamDrive             | &#x2714;   |          | &#x274C; |
| Update-GSDriveFile             | &#x2714;   |          | &#x274C; |
| Update-GSSheetValue            | &#x2714;   |          | &#x274C; |
| Update-GSTeamDrive             | &#x2714;   |          | &#x274C; |
| Copy-ToGSDrive                 |            | &#x2714; | &#x274C; |

### Other Tasks

- [ ] Update Pester Tests
- [ ] Add in CI configuration for AppVeyor
    - [ ] Build out Travis CI tests for Linux/macOS?
- [ ] Clean up PSGSuite2 to PSGSuite in prep for deployment to PSGallery
- [ ] DEPLOY PSGSuite 2.0.0!
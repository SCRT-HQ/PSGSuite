# Powershell Gallery

* [PowerShell Gallery](https://www.powershellgallery.com/packages/PSGSuite)

## Powershell Gallery Requirements

* [PowershellGet Module](https://learn.microsoft.com/en-us/powershell/module/powershellget/?view=powershellget-3.x)
    * Available in Windows 10 and later
    * Available in [Windows Management Framework 5.0](http://aka.ms/wmf5download)
    * Available in the PowerShell 3 and 4 MSI-based installer

???+ info

    Powershell Gallery versions might not include *all* pre-release versions. Please visit [GitHub Releases](../installation/github_releases.md) for versions that might not be available in the gallery.

```powershell {linenums="1"}
Install-Module -Name PSGSuite -Scope CurrentUser
```

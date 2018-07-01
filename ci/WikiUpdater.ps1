<# if (
    $env:BHProjectName -and $env:BHProjectName.Count -eq 1 -and
    $env:BHBuildSystem -ne 'Unknown' -and
    $env:BHBranchName -eq "master" -and
    $env:BHCommitMessage -match '!deploy' -and
    $env:APPVEYOR_BUILD_WORKER_IMAGE -like '*2017*' -and
    $env:APPVEYOR_PULL_REQUEST_NUMBER -eq $null 
) { #>
    git config --global credential.helper store *>1
    Add-Content "$HOME\.git-credentials" "https://$($env:git_access_token):x-oauth-basic@github.com`n"
    git config --global user.email "nate@scrthq.com" *>1
    git config --global user.name "Nate Ferrell" *>1
    Write-Host -ForegroundColor Magenta "~ ~ ~ UPDATING WIKI ~ ~ ~"
    $curLoc = (Get-Location).Path

    Write-Host "Installing and importing platyPS"

    Install-Module platyPS -Scope CurrentUser -AllowClobber -SkipPublisherCheck -Force
    Import-Module platyPS

    Set-Location "C:\projects"
    git clone https://github.com/scrthq/PSGSuite.wiki.git *>1
    Set-Location "C:\projects\PSGSuite.wiki"
    $strings = @('# Getting Started
* [Home](Home)
* [Initial Setup](Initial-Setup)
* [Using With Multiple Computers or Admins](Using-With-Multiple-Computers-or-Admins)
* [Google API to PSGSuite Function Map](API-to-Function-Map) _(Work in Progress)_

# Examples

### User Automation
* _Content needed_

### Drive Management
* _Content needed_

# Function Help
')

    Import-Module platyPS -Force
    Import-Module $env:BHPSModuleManifest

    New-MarkdownHelp -Module PSGSuite -OutputFolder .\docs -NoMetadata -Force -Verbose

    Get-ChildItem "$($env:BHModulePath)\Public" -Directory | Sort-Object Name | ForEach-Object {
        $strings += "### $($_.BaseName)"
        foreach ($function in (Get-ChildItem $_.FullName | Select-Object -ExpandProperty BaseName | Sort-Object)) {
            $strings += "* [$function]($function)"
        }
        $strings += ""
    }
    Set-Content -Path .\_Sidebar.md -Value $strings -Force

    git add . *>1
    git commit -m "updated docs and sidebar @ $(Get-Date -Format "o")" *>1
    git push *>1

    Set-Location $curLoc
<# }
else {
    "SKIPPING WIKI UPDATE!: To update the wiki, ensure that...`n" +
    "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
    "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
    "`t* You are not building a Pull Request (Current: $ENV:APPVEYOR_PULL_REQUEST_NUMBER) `n" +
    "`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage) `n" +
    "`t* Your build image is Visual Studio 2017 (Current: $ENV:APPVEYOR_BUILD_WORKER_IMAGE)" |
        Write-Host
} #>
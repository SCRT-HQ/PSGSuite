param($Task = 'Default')
if ($env:APPVEYOR) {
    $BS = "AppVeyor"
}
elseif ($env:TRAVIS) {
    $BS = "Travis CI"
}
else {
    $BS = "Unknown"
}

Write-Host -ForegroundColor Green "
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Current directory: $($pwd.Path)
Build system: $BS
PowerShell version: $($PSVersionTable.PSVersion.ToString())

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"

if ($PSVersionTable.PSVersion.Major -ge 6) {
    # Install InvokeBuild
    Install-Module InvokeBuild, Pester -Scope CurrentUser -Force -AllowClobber -SkipPublisherCheck
    Install-Module 'Configuration' -Scope CurrentUser -RequiredVersion 1.2.0 -Force -AllowClobber -SkipPublisherCheck

    # Build the code and perform tests
    Import-module InvokeBuild

    Set-Location $PSScriptRoot

    Invoke-Build -Safe -Result Result -File .\pwsh.build.ps1
    if ($Result.Error) {
        exit 1
    }
    else {
        exit 0
    }

}
else {
    # Grab nuget bits, install modules, set build variables, start build.
    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

    Install-Module Psake, PSDeploy, Pester, BuildHelpers, Coveralls -Force -Scope CurrentUser -AllowClobber -SkipPublisherCheck
    Install-Module 'Configuration' -Scope CurrentUser -RequiredVersion 1.2.0 -Force -AllowClobber -SkipPublisherCheck
    Import-Module Psake, BuildHelpers, Coveralls

    Set-BuildEnvironment

    Invoke-psake .\ci\psake.ps1 -taskList $Task -nologo
    exit ( [int]( -not $psake.build_success ) )
}

#Get-Item Env:BH* | Remove-Item
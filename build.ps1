[cmdletbinding()]
param(
    [parameter( Position = 0)]
    [ValidateSet('Init','Clean','Compile','Import','Test','TestOnly','Deploy','Skip')]
    [string[]]
    $Task = @('Init','Clean','Compile','Import'),
    [parameter()]
    [Alias('nr','nor')]
    [switch]$NoRestore,

    [switch]$UpdateModules,
    [switch]$Force,
    [switch]$Help
)
$env:_BuildStart = Get-Date -Format 'o'
$update = @{}
$verbose = @{}
if ($PSBoundParameters.ContainsKey('UpdateModules')) {
    $update['UpdateModules'] = $PSBoundParameters['UpdateModules']
}
if ($PSBoundParameters.ContainsKey('Verbose')) {
    $verbose['Verbose'] = $PSBoundParameters['Verbose']
}

. ([System.IO.Path]::Combine($PSScriptRoot,"ci","AzurePipelinesHelpers.ps1"))

if ($Help) {
    Add-Heading "Getting help"
    Write-BuildLog -c '"psake" | Resolve-Module @update @Verbose'
    'psake' | Resolve-Module @update @verbose
    Write-BuildLog "psake script tasks:"
    Get-PSakeScriptTasks -buildFile "$PSScriptRoot\psake.ps1" |
        Sort-Object -Property Name |
        Format-Table -Property Name, Description, Alias, DependsOn
}
else {
    $env:BuildProjectName = 'PSGSuite'
    $env:BuildScriptPath = $PSScriptRoot
    $env:NoNugetRestore = $NoRestore

    Add-EnvironmentSummary "Build started"

    Set-BuildVariables

    Add-Heading "Setting package feeds"

    $modHash = @{
        PackageManagement = '1.4.4'
        PowerShellGet     = '2.2.1'
    }
    foreach ($module in $modHash.Keys | Sort-Object) {
        Write-BuildLog "Updating $module module if needed"
        if ($null -eq (Get-Module $module -ListAvailable | Where-Object {[System.Version]$_.Version -ge [System.Version]($modHash[$module])})) {
            Write-BuildLog "$module is below the minimum required version! Updating"
            Install-Module $module -MinimumVersion $modHash[$module] -Force -AllowClobber -SkipPublisherCheck -Scope CurrentUser -Verbose:$false
        }
    }

    Invoke-CommandWithLog {Get-PackageProvider -Name Nuget -ForceBootstrap -Verbose:$false}
    Invoke-CommandWithLog {Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Verbose:$false}
    Invoke-CommandWithLog {$PSDefaultParameterValues = @{
        '*-Module:Verbose' = $false
        'Import-Module:ErrorAction' = 'Stop'
        'Import-Module:Force' = $true
        'Import-Module:Verbose' = $false
        'Install-Module:AllowClobber' = $true
        'Install-Module:ErrorAction' = 'Stop'
        'Install-Module:Force' = $true
        'Install-Module:Scope' = 'CurrentUser'
        'Install-Module:Verbose' = $false
    }}

    Add-Heading "Finalizing build prerequisites"
    if (
        $Task -eq 'Deploy' -and -not $Force -and (
            $ENV:BUILD_BUILDURI -notlike 'vstfs:*' -or
            $env:BUILD_SOURCEBRANCH -like '*pull*' -or
            $env:BUILD_SOURCEVERSIONMESSAGE -notmatch '!deploy' -or
            $env:BUILD_SOURCEBRANCHNAME -ne 'master' -or
            $PSVersionTable.PSVersion.Major -ne 5 -or
            $null -eq $env:NugetApiKey
        )
    ) {
        "Task is 'Deploy', but conditions are not correct for deployment:`n" +
        "    + Current build system is VSTS     : $($env:BUILD_BUILDURI -like 'vstfs:*') [$env:BUILD_BUILDURI]`n" +
        "    + Current branch is master         : $($env:BUILD_SOURCEBRANCHNAME -eq 'master') [$env:BUILD_SOURCEBRANCHNAME]`n" +
        "    + Source is not a pull request	    : $($env:BUILD_SOURCEBRANCH -notlike '*pull*') [$env:BUILD_SOURCEBRANCH]`n" +
        "    + Current PS major version is 5    : $($PSVersionTable.PSVersion.Major -eq 5) [$($PSVersionTable.PSVersion.ToString())]`n" +
        "    + NuGet API key is not null        : $($null -ne $env:NugetApiKey)`n" +
        "    + Build script is not Force ran    : $($Force)`n" +
        "    + Commit message matches '!deploy' : $($env:BUILD_SOURCEVERSIONMESSAGE -match '!deploy') [$env:BUILD_SOURCEVERSIONMESSAGE]`n" +
        "Skipping psake for this job!" | Write-Host -ForegroundColor Yellow
        exit 0
    }
    else {
        if ($Task -eq 'Deploy') {
            "Task is 'Deploy' and conditions are correct for deployment:`n" +
            "    + Build script is Force ran        : $($Force)`n" +
            "    + Current build system is VSTS     : $($env:BUILD_BUILDURI -like 'vstfs:*') [$env:BUILD_BUILDURI]`n" +
            "    + Current branch is master         : $($env:BUILD_SOURCEBRANCHNAME -eq 'master') [$env:BUILD_SOURCEBRANCHNAME]`n" +
            "    + Source is not a pull request     : $($env:BUILD_SOURCEBRANCH -notlike '*pull*') [$env:BUILD_SOURCEBRANCH]`n" +
            "    + Current PS major version is 5    : $($PSVersionTable.PSVersion.Major -eq 5) [$($PSVersionTable.PSVersion.ToString())]`n" +
            "    + NuGet API key is not null        : $($null -ne $env:NugetApiKey)`n" +
            "    + Commit message matches '!deploy' : $($env:BUILD_SOURCEVERSIONMESSAGE -match '!deploy') [$env:BUILD_SOURCEVERSIONMESSAGE]"| Write-Host -ForegroundColor Green
        }
        <#
        if (-not (Get-Module BuildHelpers -ListAvailable | Where-Object {$_.Version -eq '2.0.1'})) {
            Write-Verbose "Installing BuildHelpers v2.0.1" -Verbose
            Install-Module 'BuildHelpers' -RequiredVersion 2.0.1 -Scope CurrentUser -Repository PSGallery -AllowClobber -SkipPublisherCheck -Force
        }
        Write-Verbose "Importing BuildHelpers v2.0.1" -Verbose
        Import-Module 'BuildHelpers' -RequiredVersion 2.0.1
        #>
        Write-BuildLog "Resolving necessary modules"
        'psake' | Resolve-Module @update -Verbose
        Write-BuildLog "Modules successfully resolved"
        if ($Task -eq 'TestOnly') {
            $global:ExcludeTag = @('Module')
        }
        else {
            $global:ExcludeTag = $null
        }
        if ($Force) {
            $global:ForceDeploy = $true
        }
        else {
            $global:ForceDeploy = $false
        }
        Add-Heading "Invoking psake with task list: [ $($Task -join ', ') ]"
        $psakeParams = @{
            nologo = $true
            buildFile = "$PSScriptRoot\psake.ps1"
            taskList = $Task
        }
        Invoke-psake @psakeParams @verbose
        if (($Task -contains 'Import' -or $Task -contains 'Test') -and $psake.build_success) {
            Add-Heading "Importing $env:BuildProjectName to local scope"
            Import-Module ([System.IO.Path]::Combine($env:BHBuildOutput,$env:BHProjectName)) -Verbose:$false
        }
        Add-EnvironmentSummary "Build finished"
        exit ( [int]( -not $psake.build_success ) )
    }
}

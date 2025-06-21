[cmdletbinding()]
param(
    [parameter( Position = 0)]
    [ValidateSet('Init','Clean', 'Download', 'Generate', 'Compile','Import','Test','Full','Deploy','Skip','Docs')]
    [string[]]
    $Task = @('Init','Clean', 'Download', 'Generate', 'Compile','Import'),
    [parameter()]
    [Alias('nr','nor')]
    [switch]$NoRestore,

    [switch]$UpdateModules,
    [switch]$Force,
    [switch]$Help
)
$env:_BuildStart = Get-Date -Format 'o'
$ModuleName = 'PSGSuite'
$Dependencies = @{
    Configuration     = '1.3.1'
    psake             = '4.9.0'
}
if ($env:SYSTEM_STAGENAME -eq 'Build' -or -not (Test-Path Env:\TF_BUILD)) {
    $Dependencies['PowerShellGet'] = '2.2.1'
}
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

    $env:BuildProjectName = $ModuleName
    $env:BuildScriptPath = $PSScriptRoot

    if ($Task -contains 'Docs') {
        $env:NoNugetRestore = $true
    }
    else {
        $env:NoNugetRestore = $NoRestore
    }

    $global:PSDefaultParameterValues = @{
        '*-Module:Verbose' = $false
        'Import-Module:ErrorAction' = 'Stop'
        'Import-Module:Force' = $true
        'Import-Module:Verbose' = $false
        'Install-Module:AllowClobber' = $true
        'Install-Module:ErrorAction' = 'Stop'
        'Install-Module:Force' = $true
        'Install-Module:Scope' = 'CurrentUser'
        'Install-Module:Repository' = 'PSGallery'
        'Install-Module:Verbose' = $false
    }
    Get-PackageProvider -Name Nuget -ForceBootstrap -Verbose:$false
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Verbose:$false

    Add-EnvironmentSummary "Build started"
    Set-BuildVariables

    Add-Heading "Pulling module and build dependencies"
    [hashtable[]]$moduleDependencies = @()
    foreach ($module in $Dependencies.Keys) {
        $moduleDependencies += @{
            Name           = $module
            MinimumVersion = $Dependencies[$module]
        }
    }
    (Import-PowerShellDataFile ([System.IO.Path]::Combine($PSScriptRoot,$ModuleName,"$ModuleName.psd1"))).RequiredModules | ForEach-Object {
        $item = $_
        if ($item -is [hashtable] -and $Dependencies.Keys -notcontains $item.ModuleName) {
            Write-BuildLog "Adding new dependency from PSD1: $($item.ModuleName)"
            $hash = @{
                Name = $item.ModuleName
            }
            if ($item.ContainsKey('ModuleVersion')) {
                $hash['MinimumVersion'] = $item.ModuleVersion
            }
            $moduleDependencies += $hash
        }
        elseif ($item -is [string] -and $Dependencies.Keys -notcontains $item) {
            $moduleDependencies += @{
                Name = $item
            }
        }
    }
    try {
        $null = Get-PackageProvider -Name Nuget -ForceBootstrap -Verbose:$false -ErrorAction Stop
    }
    catch {
        throw
    }

    Add-Heading "Finalizing build prerequisites"
    if ($Task -eq 'Deploy' -and $null -eq $env:NugetApiKey) {
        "Task is 'Deploy', but conditions are not correct for deployment:`n" +
        "    + NuGet API key is not null     : $($null -ne $env:NugetApiKey)`n" +
        "Skipping psake for this job!" | Write-Host -ForegroundColor Yellow
        exit 0
    }
    else {
        if ($Task -eq 'Deploy') {
            "Task is 'Deploy' and conditions are correct for deployment:`n" +
            "    + NuGet API key is not null     : $($null -ne $env:NugetApiKey)"| Write-Host -ForegroundColor Green
        }
        Write-BuildLog "Resolving necessary modules"
        foreach ($module in $moduleDependencies) {
            Write-BuildLog "[$($module.Name)] Resolving"
            try {
                Import-Module @module
            }
            catch {
                Write-BuildLog "[$($module.Name)] Installing missing module"
                Install-Module @module -Repository PSGallery
                Import-Module @module
            }
        }
        Write-BuildLog "Modules resolved"
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
            buildFile = "$PSScriptRoot\psake.ps1"
            taskList = $Task
        }
        Invoke-psake @psakeParams @verbose -parameters @{NoRestore = $NoRestore}
        if (($Task -contains 'Import' -or $Task -contains 'Test') -and $psake.build_success) {
            Add-Heading "Importing $env:BuildProjectName to local scope"
            Import-Module ([System.IO.Path]::Combine($env:BHBuildOutput,$env:BHProjectName)) -Verbose:$false
        }
        Add-EnvironmentSummary "Build finished"
        exit ( [int]( -not $psake.build_success ) )
    }
}

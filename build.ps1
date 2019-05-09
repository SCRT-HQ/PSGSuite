
[cmdletbinding(DefaultParameterSetName = 'task')]
param(
    [parameter(ParameterSetName = 'task', Position = 0)]
    [ValidateSet('Init','Clean','Compile','Import','Test','TestOnly','Deploy','Skip')]
    [string[]]
    $Task = @('Init','Clean','Compile','Import'),

    [parameter(ParameterSetName = 'help')]
    [switch]$Help,

    [switch]$UpdateModules,
    [switch]$Force
)

$env:BuildProjectName = 'PSGSuite'
$env:_BuildStart = Get-Date -Format 'o'
$env:BuildScriptPath = $PSScriptRoot

Get-ChildItem (Join-Path $PSScriptRoot "ci") -Filter "*.ps1" | ForEach-Object {. $_.FullName}

Add-EnvironmentSummary "Build started"

Set-BuildVariables

Add-Heading "Setting package feeds"

if ($null -eq (Get-Module PowerShellGet -ListAvailable | Where-Object {$_.Version -ge [System.Version]'2.1.2'})) {
    Write-BuildLog "Updating PowerShellGet module"
    Invoke-CommandWithLog {Install-Module PowerShellGet -MinimumVersion 2.1.2 -Force -AllowClobber -SkipPublisherCheck -Scope CurrentUser -Verbose:$false}
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

<#
# build/init script borrowed from PoshBot x Brandon Olin

function Resolve-Module {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Name,

        [switch]$UpdateModules
    )

    begin {
        Get-PackageProvider -Name Nuget -ForceBootstrap -Verbose:$false | Out-Null
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Verbose:$false

        $PSDefaultParameterValues = @{
            '*-Module:Verbose' = $false
            'Find-Module:Repository' = 'PSGallery'
            'Import-Module:ErrorAction' = 'Stop'
            'Import-Module:Verbose' = $false
            'Import-Module:Force' = $true
            'Install-Module:ErrorAction' = 'Stop'
            'Install-Module:Force' = $true
            'Install-Module:Scope' = 'CurrentUser'
            'Install-Module:Verbose' = $false
            'Install-Module:AllowClobber' = $true
            'Install-Module:Repository' = 'PSGallery'
        }
    }

    process {
        foreach ($moduleName in $Name) {
            $versionToImport = ''

            Write-Verbose -Message "Resolving Module [$($moduleName)]"
            if ($Module = Get-Module -Name $moduleName -ListAvailable -Verbose:$false) {
                # Determine latest version on PSGallery and warn us if we're out of date
                $latestLocalVersion = ($Module | Measure-Object -Property Version -Maximum).Maximum
                $latestGalleryVersion = (Find-Module -Name $moduleName -Repository PSGallery |
                    Measure-Object -Property Version -Maximum).Maximum

                # Out we out of date?
                if ($latestLocalVersion -lt $latestGalleryVersion) {
                    if ($UpdateModules) {
                        Write-Verbose -Message "$($moduleName) installed version [$($latestLocalVersion.ToString())] is outdated. Installing gallery version [$($latestGalleryVersion.ToString())]"
                        if ($UpdateModules) {
                            Install-Module -Name $moduleName -RequiredVersion $latestGalleryVersion
                            $versionToImport = $latestGalleryVersion
                        }
                    } else {
                        Write-Warning "$($moduleName) is out of date. Latest version on PSGallery is [$latestGalleryVersion]. To update, use the -UpdateModules switch."
                    }
                } else {
                    $versionToImport = $latestLocalVersion
                }
            } else {
                Write-Verbose -Message "[$($moduleName)] missing. Installing..."
                Install-Module -Name $moduleName -Repository PSGallery
                $versionToImport = (Get-Module -Name $moduleName -ListAvailable | Measure-Object -Property Version -Maximum).Maximum
            }

            Write-Verbose -Message "$($moduleName) installed. Importing..."
            if (-not [string]::IsNullOrEmpty($versionToImport)) {
                Import-module -Name $moduleName -RequiredVersion $versionToImport
            } else {
                Import-module -Name $moduleName
            }
        }
    }
}
#>

$update = @{}
$verbose = @{}
if ($PSBoundParameters.ContainsKey('UpdateModules')) {
    $update['UpdateModules'] = $PSBoundParameters['UpdateModules']
}
if ($PSBoundParameters.ContainsKey('Verbose')) {
    $verbose['Verbose'] = $PSBoundParameters['Verbose']
}

if ($Help) {
    Add-Heading "Getting help"
    Write-BuildLog -c '"psake" | Resolve-Module @update -Verbose'
    'psake' | Resolve-Module @update -Verbose
    Write-BuildLog "psake script tasks:"
    Get-PSakeScriptTasks -buildFile "$PSScriptRoot\psake.ps1" |
        Sort-Object -Property Name |
        Format-Table -Property Name, Description, Alias, DependsOn
}
else {
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

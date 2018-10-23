
[cmdletbinding(DefaultParameterSetName = 'task')]
param(
    [parameter(ParameterSetName = 'task', Position = 0)]
    [ValidateSet('Init','Clean','Compile','Pester','PesterOnly','Deploy')]
    [string[]]
    $Task = @('Init','Clean','Compile','Pester'),

    [parameter(ParameterSetName = 'help')]
    [switch]$Help,

    [switch]$UpdateModules
)

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
            'Install-Module:ErrorAction' = 'Stop'
            'Install-Module:Force' = $true
            'Install-Module:Scope' = 'CurrentUser'
            'Install-Module:Verbose' = $false
            'Install-Module:AllowClobber' = $true
            'Import-Module:ErrorAction' = 'Stop'
            'Import-Module:Verbose' = $false
            'Import-Module:Force' = $true
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

'BuildHelpers', 'psake' | Resolve-Module -UpdateModules:$PSBoundParameters['UpdateModules'] -Verbose:$PSBoundParameters['Verbose']

if ($Help) {
    Get-PSakeScriptTasks -buildFile "$PSScriptRoot\psake.ps1" |
        Sort-Object -Property Name |
        Format-Table -Property Name, Description, Alias, DependsOn
}
else {
    Set-BuildEnvironment -Force
    $Task = if ($ENV:BHBuildSystem -eq 'VSTS' -and $env:BHCommitMessage -match '!deploy' -and $env:BHBranchName -eq "master" -and $PSVersionTable.PSVersion.Major -lt 6 -and -not [String]::IsNullOrEmpty($env:NugetApiKey)) {
        'Deploy'
    }
    elseif ($ENV:BHBuildSystem -ne 'VSTS' -and $Task -like 'Deploy*') {
        Write-Host ""
        Write-Warning "Current build system is $($ENV:BHBuildSystem). Defaulting to Default task..."
        Write-Host ""
        @('Init','Clean','Compile','Pester')
    }
    else {
        $Task
    }
    Write-Host -ForegroundColor Green "Modules successfully resolved..."
    Write-Host -ForegroundColor Green "Invoking psake with task list: [ $($Task -join ', ') ]`n"
    Invoke-psake -buildFile "$PSScriptRoot\psake.ps1" -taskList $Task -nologo -Verbose:$PSBoundParameters['Verbose']
    exit ( [int]( -not $psake.build_success ) )
}

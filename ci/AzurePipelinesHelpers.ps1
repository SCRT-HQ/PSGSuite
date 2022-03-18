New-Variable -Name IsCI -Value $($IsCI -or (Test-Path Env:\TF_BUILD)) -Scope Global -Force -Option AllScope

if ($false) {
    Write-Host "##[info] This is an info test!"
    Write-Host "##[section] This is colored green!"
    Write-Host "##[command] This is colored blue!"
    Write-Host "##[debug] This is colored purple!"
    Write-Host "##[warning] This is colored orange!"
    Write-Host "##vso[task.logissue type=warning;]This is colored orange - task.logissue!"
    Write-Host "##[error] This is colored red!"
    Write-Host "##vso[task.logissue type=error;]This is colored red - task.logissue!"
}

function Install-NuGetDependencies {
    [CmdletBinding()]
    Param (
        [parameter()]
        [String[]]
        $Destination,
        [parameter()]
        [String[]]
        $AddlSearchString
    )
    try {
        Import-Module PackageManagement -Force
        . ([System.IO.Path]::Combine($PSScriptRoot,"UpdateNuGetDependenciesJson.ps1"))
        $dllStgPath = Join-Path $PSScriptRoot "NuGetStaging"
        $packagesToInstall = Get-Content (Join-Path $PSScriptRoot "NuGetDependencies.json") -Raw | ConvertFrom-Json | Sort-Object BaseName
        if (-not (Test-Path $dllStgPath)) {
            New-Item $dllStgPath -Force -ItemType Directory | Out-Null
        }
        $nugHash = @{}
        foreach ($search in $AddlSearchString) {
            Write-BuildLog "Finding NuGet packages matching SearchString: $search"
            Register-PackageSource -Name NuGet -Location https://www.nuget.org/api/v2 -ProviderName NuGet -Force -Trusted -ForceBootstrap
            PackageManagement\Find-Package $search -Source NuGet -AllowPrereleaseVersions:$false | Where-Object {$_.Name -in $packagesToInstall.BaseName} | ForEach-Object {
                Write-BuildLog "Matched package: $($_.Name)"
                $nugHash[$_.Name] = $_
            }
        }
        $webClient = New-Object System.Net.WebClient
        foreach ($inst in $packagesToInstall) {
            try {
                $pkg = if ($nugHash.ContainsKey($inst.BaseName)) {
                    $nugHash[$inst.BaseName]
                }
                else {
                    [PSCustomObject]@{
                        Name = $inst.BaseName
                        Version = $inst.LatestVersion
                        TagId = $inst.BaseName + '#' + $inst.LatestVersion
                    }
                }
                Write-BuildLog ("[{0}.{1}] Downloading latest package from NuGet" -f $pkg.Name,$pkg.Version)
                $extPath = [System.IO.Path]::Combine($dllStgPath,"$($pkg.Name.ToLower().TrimEnd('.dll')).$($pkg.Version)")
                if (Test-Path ($extPath)) {
                    Remove-Item $extPath -Recurse -Force
                }
                New-Item -Path $extPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
                $zipPath = $extPath.TrimEnd('.dll') + '.zip'
                if (Test-Path ($zipPath)) {
                    Remove-Item $zipPath -Force
                }

                $pkgUrl = 'https://www.nuget.org/api/v2/package/'+ ($pkg.TagId.Replace('#','/'))
                $i = 0
                do {
                    $webClient.DownloadFile($pkgUrl,$zipPath)
                    #Invoke-WebRequest -Uri $pkgUrl -OutFile $zipPath
                    $i++
                }
                until ((Test-Path $zipPath) -or $i -ge 5)
                if ($i -ge 5) {
                    throw "Failed to download NuGet package from URL: $pkgUrl"
                }
                Unblock-File $zipPath
                Add-Type -AssemblyName System.IO.Compression
                [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath,$extPath)
                foreach ($dest in $Destination) {
                    foreach ($target in @('net45','netstandard1.3')) {
                        $targetPath = [System.IO.Path]::Combine($dest,'lib',$target)
                        if (-not (Test-Path $targetPath)) {
                            New-Item -Path $targetPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
                        }
                        $sourcePath = if ($pkg.Name -eq 'BouncyCastle.Crypto.dll') {
                            [System.IO.Path]::Combine($extPath,'lib')
                        }
                        else {
                            [System.IO.Path]::Combine($extPath,'lib',$target)
                        }
                        if (Test-Path $sourcePath) {
                            Get-ChildItem $sourcePath -Filter '*.dll' | Copy-Item -Destination $targetPath -Force
                        }
                        else {
                            Write-BuildError "$($pkg.Name) was not downloaded successfully from NuGet!" -ErrorAction Stop
                            exit 1
                        }
                    }
                }
            }
            catch {
                Write-Warning "Error when trying [$($inst.BaseName)]: $($_.Exception.Message)"
            }
            finally {
                if (Test-Path ($zipPath)) {
                    Remove-Item $zipPath -Force
                }
                if (Test-Path ($extPath)) {
                    Remove-Item $extPath -Recurse -Force
                }
            }
        }
        $webClient.Dispose()
    }
    finally {
        if (Test-Path $dllStgPath) {
            Remove-Item $dllStgPath -Recurse -Force
        }
    }
}

function Resolve-Module {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Name,

        [switch]$UpdateModules
    )
    Begin {
        $PSDefaultParameterValues = @{
            '*-Module:Verbose' = $false
            'Import-Module:ErrorAction' = 'Stop'
            'Import-Module:Force' = $true
            'Import-Module:Verbose' = $false
            'Install-Module:AllowClobber' = $true
            'Install-Module:ErrorAction' = 'Stop'
            'Install-Module:Force' = $true
            'Install-Module:Scope' = 'CurrentUser'
            'Install-Module:Verbose' = $false
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

function Get-PsakeTaskSectionFormatter {
    $sb = {
        param($String)
        "$((Add-Heading "Executing task: {0}" -PassThru) -join "`n")" -f $String
    }
    return $sb
}

function Add-Heading {
    param(
        [parameter(Position = 0,ValueFromRemainingArguments)]
        [String]
        $Title,
        [Switch]
        $Passthru
    )
    if (-not $env:_BuildStart) {
        $env:_BuildStart = Get-Date -Format 'o'
    }
    $date = "[$((Get-Date).ToString("HH:mm:ss")) +$(((Get-Date) - (Get-Date $env:_BuildStart)).ToString())]"
    $msgList = @(
        ''
        "##[section] $date $Title"
    )
    if ($Passthru) {
        $msgList
    }
    else {
        $msgList | Write-Host -ForegroundColor Cyan
    }
}
Set-Alias -Name Heading -Value Add-Heading -Force

function Add-EnvironmentSummary {
    param(
        [parameter(Position = 0,ValueFromRemainingArguments)]
        [String]
        $State
    )
    Add-Heading Build Environment Summary
    @(
        "Project : $env:BuildProjectName"
        "State   : $State"
        "Engine  : PowerShell $($PSVersionTable.PSVersion.ToString())"
        "Host OS : $(if($PSVersionTable.PSVersion.Major -le 5 -or $IsWindows){"Windows"}elseif($IsLinux){"Linux"}elseif($IsMacOS){"macOS"}else{"[UNKNOWN]"})"
        "PWD     : $PWD"
        ''
    ) | Write-Host
}
Set-Alias -Name Summary -Value Add-EnvironmentSummary -Force

function Write-BuildWarning {
    param(
        [parameter(Mandatory,Position = 0,ValueFromRemainingArguments,ValueFromPipeline)]
        [System.String]
        $Message
    )
    Process {
        Write-Warning $Message
        if ((Test-Path Env:\TF_BUILD)) {
            Write-Host "##vso[task.logissue type=warning;]$Message"
        }
        else {
        }
    }
}

function Write-BuildError {
    param(
        [parameter(Mandatory,Position = 0,ValueFromRemainingArguments,ValueFromPipeline)]
        [System.String]
        $Message
    )
    Process {
        if ((Test-Path Env:\TF_BUILD)) {
            Write-Host "##vso[task.logissue type=error;]$Message"
        }
        throw $Message
    }
}

function Write-BuildLog {
    [CmdletBinding()]
    param(
        [parameter(Mandatory,Position = 0,ValueFromRemainingArguments,ValueFromPipeline)]
        [System.Object]
        $Message,
        [parameter()]
        [Alias('c','Command')]
        [Switch]
        $Cmd,
        [parameter()]
        [Alias('w')]
        [Switch]
        $Warning,
        [parameter()]
        [Alias('s','e')]
        [Switch]
        $Severe,
        [parameter()]
        [Alias('x','nd','n')]
        [Switch]
        $Clean
    )
    Begin {
        if (-not $env:_BuildStart) {
            $env:_BuildStart = Get-Date -Format 'o'
        }
        if ($PSBoundParameters.ContainsKey('Debug') -and $PSBoundParameters['Debug'] -eq $true) {
            $fg = 'Yellow'
            $lvl = '##[debug]   '
        }
        elseif ($PSBoundParameters.ContainsKey('Verbose') -and $PSBoundParameters['Verbose'] -eq $true) {
            $fg = if ($Host.UI.RawUI.ForegroundColor -eq 'Gray') {
                'White'
            }
            else {
                'Gray'
            }
            $lvl = '##[verbose] '
        }
        elseif ($Severe) {
            $fg = 'Red'
            $lvl = '##[error]   '
        }
        elseif ($Warning) {
            $fg = 'Yellow'
            $lvl = '##[warning] '
        }
        elseif ($Cmd) {
            $fg = 'Magenta'
            $lvl = '##[command] '
        }
        else {
            $fg = if ($Host.UI.RawUI.ForegroundColor -eq 'Gray') {
                'White'
            }
            else {
                'Gray'
            }
            $lvl = '##[info]    '
        }
    }
    Process {
        $fmtMsg = if ($Clean){
            $Message -split "[\r\n]" | Where-Object {$_} | ForEach-Object {
                $lvl + $_
            }
        }
        else {
            $date = "[$((Get-Date).ToString("HH:mm:ss")) +$(((Get-Date) - (Get-Date $env:_BuildStart)).ToString())] "
            if ($Cmd) {
                $i = 0
                $Message -split "[\r\n]" | Where-Object {$_} | ForEach-Object {
                    if ($i -eq 0) {
                        $startIndex = if ($_ -match "^\s+") {
                            $new = $_ -replace "^\s+"
                            $_.Length - $new.Length
                        }
                        else {
                            0
                        }
                        $tag = 'PS > '
                    }
                    else {
                        $tag = '  >> '
                    }
                    $finalIndex = if ($startIndex -lt $_.Length) {
                        $startIndex
                    }
                    else{
                        0
                    }
                    $lvl + $date + $tag + ([String]$_).Substring($finalIndex)
                    $i++
                }
            }
            else {
                $Message -split "[\r\n]" | Where-Object {$_} | ForEach-Object {
                    $lvl + $date + $_
                }
            }
        }
        Write-Host -ForegroundColor $fg $($fmtMsg -join "`n")
    }
}
Set-Alias -Name Log -Value Write-BuildLog -Force

function Invoke-CommandWithLog {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory,Position=0)]
        [ScriptBlock]
        $ScriptBlock
    )
    Write-BuildLog -Command ($ScriptBlock.ToString() -join "`n")
    $ScriptBlock.Invoke()
}

function Set-EnvironmentVariable {
    param(
        [parameter(Position = 0)]
        [String]
        $Name,
        [parameter(Position = 1,ValueFromRemainingArguments)]
        [String[]]
        $Value
    )
    $fullVal = $Value -join " "
    Set-Item -Path Env:\$Name -Value $fullVal -Force
    if ((Test-Path Env:\TF_BUILD)) {
        "##vso[task.setvariable variable=$Name]$fullVal" | Write-Host
    }
}
Set-Alias -Name SetEnv -Value Set-EnvironmentVariable -Force

function Set-BuildVariables {
    $gitVars = if ((Test-Path Env:\TF_BUILD)) {
        @{
            BHBranchName = $env:BUILD_SOURCEBRANCHNAME
            BHPSModuleManifest = "$env:BuildScriptPath\$env:BuildProjectName\$env:BuildProjectName.psd1"
            BHPSModulePath = "$env:BuildScriptPath\$env:BuildProjectName"
            BHProjectName = $env:BuildProjectName
            BHBuildNumber = $env:BUILD_BUILDNUMBER
            BHModulePath = "$env:BuildScriptPath\$env:BuildProjectName"
            BHBuildOutput = "$env:BuildScriptPath\BuildOutput"
            BHBuildSystem = 'VSTS'
            BHProjectPath = $env:SYSTEM_DEFAULTWORKINGDIRECTORY
            BHCommitMessage = $env:BUILD_SOURCEVERSIONMESSAGE
        }
    }
    else {
        @{
            BHBranchName = $((git rev-parse --abbrev-ref HEAD).Trim())
            BHPSModuleManifest = "$env:BuildScriptPath\$env:BuildProjectName\$env:BuildProjectName.psd1"
            BHPSModulePath = "$env:BuildScriptPath\$env:BuildProjectName"
            BHProjectName = $env:BuildProjectName
            BHBuildNumber = 'Unknown'
            BHModulePath = "$env:BuildScriptPath\$env:BuildProjectName"
            BHBuildOutput = "$env:BuildScriptPath\BuildOutput"
            BHBuildSystem = [System.Environment]::MachineName
            BHProjectPath = $env:BuildScriptPath
            BHCommitMessage = $((git log --format=%B -n 1).Trim())
        }
    }
    foreach ($var in $gitVars.Keys) {
        if (-not (Test-Path Env:\$var)) {
            Set-EnvironmentVariable $var $gitVars[$var]
        }
    }
}

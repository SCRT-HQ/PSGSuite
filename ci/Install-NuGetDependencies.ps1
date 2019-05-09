function Install-NuGetDependencies {
    [CmdletBinding()]
    Param (
        [parameter()]
        [String[]]
        $Destination,
        [parameter()]
        [String]
        $BackupPath
    )
    $dllStgPath = Join-Path $pwd.Path "DLLStaging"
    $packagesToInstall = Import-Csv (Join-Path $PSScriptRoot "GoogleDLLVersions.csv") | Sort-Object BaseName
    if (-not (Test-Path $dllStgPath)) {
        New-Item $dllStgPath -Force -ItemType Directory | Out-Null
    }
    $nugHash = @{}
    Write-BuildLog "Finding Google NuGet packages..."
    Find-Package "Google.Apis*" -Source nuget.org -AllowPrereleaseVersions:$false -Verbose | Where-Object {$_.Name -in $packagesToInstall.BaseName} | ForEach-Object {
        Write-BuildLog "Matched Google package: $($_.Name)"
        $nugHash[$_.Name] = $_
    }
    foreach ($inst in $packagesToInstall) {
        try {
            $pkg = if ($nugHash.ContainsKey($inst.BaseName)) {
                $nugHash[$inst.BaseName]
            }
            else {
                [PSCustomObject]@{
                    Name = $inst.BaseName
                    Version = $inst.Version
                    TagId = $inst.BaseName + '#' + $inst.Version
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
                Invoke-WebRequest -Uri $pkgUrl -OutFile $zipPath
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
                        Get-ChildItem $sourcePath -Filter '*.dll' | Copy-Item -Destination $targetPath -Force -Verbose
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
}

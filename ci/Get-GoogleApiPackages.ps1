function Get-GoogleApiPackages {
    [CmdletBinding()]
    Param (
        [parameter()]
        [String[]]
        $Destination
    )
    Invoke-CommandWithLog {Remove-Module PSGSuite -ErrorAction SilentlyContinue -Force -Verbose:$false}
    $dllStgPath = Join-Path $pwd.Path "DLLStaging"
    if (-not (Test-Path $dllStgPath)) {
        New-Item $dllStgPath -Force -ItemType Directory | Out-Null
    }
    Write-BuildLog 'Updating Google.Apis libraries from NuGet.org'
    $nugHash = @{}
    Find-Package "Google.Apis*" -Source nuget.org -AllowPrereleaseVersions:$false -Verbose | ForEach-Object {
        $nugHash[$_.Name] = $_
    }
    $installed = (Get-ChildItem ([System.IO.Path]::Combine($sutLib,'net45')) -Filter 'Google.Apis*').BaseName | Sort-Object
    foreach ($inst in $installed) {
        try {
            $pkg = $nugHash[$inst]
            Write-BuildLog ("[{0}.{1}] Downloading latest package from NuGet" -f $pkg.Name,$pkg.Version)
            $extPath = [System.IO.Path]::Combine($dllStgPath,"$($pkg.Name.ToLower()).$($pkg.Version)")
            if (Test-Path ($extPath)) {
                Remove-Item $extPath -Recurse -Force
            }
            New-Item -Path $extPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
            $zipPath = $extPath + '.zip'
            if (Test-Path ($zipPath)) {
                Remove-Item $zipPath -Force
            }

            $pkgUrl = 'https://www.nuget.org/api/v2/package/'+ ($pkg.TagId.Replace('#','/'))
            Invoke-WebRequest -Uri $pkgUrl -OutFile $zipPath
            Unblock-File $zipPath
            Add-Type -AssemblyName System.IO.Compression
            [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath,$extPath)
            foreach ($dest in $Destination) {
                foreach ($target in @('net45','netstandard1.3')) {
                    $targetPath = "$dest\lib\$target"
                    if (-not (Test-Path $targetPath)) {
                        New-Item -Path $targetPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
                    }
                    Get-ChildItem ([System.IO.Path]::Combine($extPath,'lib',$target)) -Filter '*.dll' | Copy-Item -Destination $targetPath -Force -Verbose
                }
            }
        }
        catch {
            Write-Warning "Error when trying [$inst]: $($_.Exception.Message)"
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

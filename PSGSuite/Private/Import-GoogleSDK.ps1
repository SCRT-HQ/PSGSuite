function Import-GoogleSDK {
    [CmdletBinding()]
    Param()
    Process {
        $lib = Resolve-Path "$($script:ModuleRoot)\lib"
        $refs = @()
        $sdkPath = if ($PSVersionTable.PSVersion.Major -lt 6) {
            Write-Verbose "Importing the SDK's for net45"
            "$lib\net45"
        }
        else {
            Write-Verbose "Importing the SDK's for netstandard1.3"
            "$lib\netstandard1.3"
        }
        $dlls = Get-ChildItem $sdkPath -Filter "*.dll"
        $googleCore = ($dlls | Where-Object {$_.Name -eq 'Google.Apis.dll'})
        $googleCoreVersion = [System.Version]((Get-Item $googleCore.FullName).VersionInfo.FileVersion)
        $batches = @(
            # Load the non-Google DLLs first...
            ($dlls | Where-Object {$_.Name -notin $refs -and $_.Name -notmatch '^Google'})
            # Then load Google.Apis.dll...
            $googleCore
            # Then load the rest of the Google DLLs
            ($dlls | Where-Object {$_.Name -notin $refs -and $_.Name -match '^Google' -and $_.Name -ne 'Google.Apis.dll'})
        )
        foreach ($batch in $batches) {
            $batch | ForEach-Object {
                $sdk = $_.Name
                try {
                    $params = @{}
                    if ($_.Name -match '^Google' -and $_.Name -ne 'Google.Apis.dll' -and ([System.Version]((Get-Item $_.FullName).VersionInfo.FileVersion)) -ge $googleCoreVersion) {
                        $params['ReferencedAssemblies'] = ($dlls | Where-Object {$_.Name -eq 'Google.Apis.dll'}).FullName
                        Add-Type -Path $_.FullName @params -ErrorAction Stop
                    }
                    elseif ($_.Name -notmatch '^Google' -or $_.Name -eq 'Google.Apis.dll' -or ($_.Name -ne 'Google.Apis.dll' -and ([System.Version]((Get-Item $_.FullName).VersionInfo.FileVersion)) -ge $googleCoreVersion)) {
                        Add-Type -Path $_.FullName @params -ErrorAction Stop
                    }
                }
                catch [System.Reflection.ReflectionTypeLoadException] {
                    Write-Error "$($sdk): Unable to load assembly!"
                    Write-Host "Message: $($_.Exception.Message)"
                    Write-Host "StackTrace: $($_.Exception.StackTrace)"
                    Write-Host "LoaderExceptions: $($_.Exception.LoaderExceptions)"
                }
                catch {
                    Write-Error "$($sdk): $($_.Exception.Message)"
                }
            }
        }
    }
}

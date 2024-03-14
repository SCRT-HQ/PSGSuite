function Import-GoogleSDK {
    [CmdletBinding()]
    Param()
    Process {
        $lib = Resolve-Path "$($script:ModuleRoot)\lib"
        $refs = @()
        $sdkPath = if ($PSVersionTable.PSVersion.Major -le 5) {
            Write-Verbose "Importing the SDK's for net45"
            "$lib\net45"
        }
        else {
            Write-Verbose "Importing the SDK's for netstandard1.3"
            "$lib\netstandard1.3"
        }
        $dlls = Get-ChildItem $sdkPath -Filter "*.dll"
        $specialGoogleDlls = @('Google.Apis.Auth.dll', 'Google.Apis.Core.dll', 'Google.Apis.dll')
        $googleCore = ($dlls | Where-Object {$_.Name -eq 'Google.Apis.Core.dll'})
        $googleApis = ($dlls | Where-Object {$_.Name -eq 'Google.Apis.dll'})
        $googleAuth = ($dlls | Where-Object {$_.Name -eq 'Google.Apis.Auth.dll'})
        $googleCoreVersion = [System.Version]((Get-Item $googleCore.FullName).VersionInfo.FileVersion)
        $batches = @(
            # Load the non-Google DLLs first...
            ($dlls | Where-Object {$_.Name -notin $refs -and $_.Name -notmatch '^Google'})
            # Then load Google.Apis.Core.dll...
            $googleCore
            # Then load Google.Apis.dll...
            $googleApis
            # Then load Google.Apis.Auth.dll...
            $googleAuth
            # Then load the rest of the Google DLLs
            ($dlls | Where-Object {$_.Name -notin $refs -and $_.Name -match '^Google' -and $_.Name -notin $specialGoogleDlls})
        )
        foreach ($batch in $batches) {
            $batch | ForEach-Object {
                $sdk = $_.Name
                try {
                    $params = @{}
                    if ($_.Name -match '^Google' -and $_.Name -notin $specialGoogleDlls -and ([System.Version]((Get-Item $_.FullName).VersionInfo.FileVersion)) -ge $googleCoreVersion) {
                        $params['ReferencedAssemblies'] = ($dlls | Where-Object {$_.Name -eq 'Google.Apis.dll'}).FullName
                        Add-Type -Path $_.FullName @params -ErrorAction Stop
                    }
                    elseif ($_.Name -notmatch '^Google' -or $_.Name -eq 'Google.Apis.dll' -or ($_.Name -notin $specialGoogleDlls -and ([System.Version]((Get-Item $_.FullName).VersionInfo.FileVersion)) -ge $googleCoreVersion)) {
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

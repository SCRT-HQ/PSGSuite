function Import-GoogleSDK {
    [CmdletBinding()]
    Param(
        [string]$lib = (Resolve-Path "$($script:ModuleRoot)\lib")
    )
    Process {
        $refs = @()
        $sdkPath = $lib
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
                    Write-Verbose "Loading assembly: $($sdk)"
                    # Use Reflection.Assembly.LoadFrom to load assemblies
                    [Reflection.Assembly]::LoadFrom($_.FullName) | Out-Null
                    Write-Verbose "Successfully loaded: $($sdk)"
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
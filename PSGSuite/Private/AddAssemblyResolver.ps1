$lib = (Resolve-Path (Join-Path $PSScriptRoot 'lib')).Path
$sdkPath = if ($PSVersionTable.PSVersion.Major -lt 6) {
    Write-Verbose "Importing the SDK's for net45"
    "$lib\net45"
}
else {
    Write-Verbose "Importing the SDK's for netstandard1.3"
    "$lib\netstandard1.3"
}
$dlls = Get-ChildItem $sdkPath -Filter "*.dll"

# Load the core dependencies in first
$googleApisDll = [System.Reflection.Assembly]::LoadFrom(($dlls | Where-Object { $_.Name -eq 'Google.Apis.dll' }).FullName)
$googleApisAuthDll = [System.Reflection.Assembly]::LoadFrom(($dlls | Where-Object { $_.Name -eq 'Google.Apis.Auth.dll' }).FullName)

$onAssemblyResolveEventHandler = [System.ResolveEventHandler] {
    param($sender, $e)
    # You can make this condition more or less version specific as suits your requirements
    if ($e.Name.StartsWith("Google.Apis.Auth,")) {
        return $googleApisAuthDll
    }
    elseif ($e.Name.StartsWith("Google.Apis,")) {
        return $googleApisDll
    }
    else {
        foreach ($assembly in [System.AppDomain]::CurrentDomain.GetAssemblies()) {
            if ($assembly.FullName -eq $e.Name) {
                return $assembly
            }
        }
        return $null
    }
}
[System.AppDomain]::CurrentDomain.add_AssemblyResolve($onAssemblyResolveEventHandler)

foreach ($item in ($dlls | Where-Object { $_.Name -notmatch '^Google\.Apis(\.Auth){0,1}\.dll$' })) {
    $sdk = $item.Name
    try {
        $null = [System.Reflection.Assembly]::LoadFrom($item.FullName)
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
[System.AppDomain]::CurrentDomain.remove_AssemblyResolve($onAssemblyResolveEventHandler)

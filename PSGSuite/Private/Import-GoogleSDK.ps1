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
        Get-ChildItem $sdkPath -Filter "*.dll" | Where-Object {$_.Name -notin $refs} | ForEach-Object {
            $sdk = $_.Name
            try {
                Add-Type -Path $_.FullName -ErrorAction Stop
            }
            catch {
                Write-Error "$($sdk): $($_.Exception.Message)"
            }
        }
    }
}
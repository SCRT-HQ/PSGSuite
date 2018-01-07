function Import-GoogleSDK {
    [CmdletBinding()]
    Param()
    Process {
        $bin = "$($script:ModuleRoot)\bin"
        $refs = @()
        $sdkPath = if ($PSVersionTable.PSVersion.Major -lt 6) {
            Write-Verbose "Importing the Google SDK's for net45"
            "$bin\net45"
        }
        else {
            Write-Verbose "Importing the Google SDK's for netstandard1.3"
            "$bin\netstandard1.3"
        }
        Add-Type -Path "$bin\Newtonsoft.Json.dll"
        Get-ChildItem $sdkPath -Filter "*.dll" | Where-Object {$_.FullName -notin $refs} | ForEach-Object {
            try {
                Add-Type -Path $_.FullName -ErrorAction Stop
            }
            catch {
                Write-Error $_
            }
        }
    }
}
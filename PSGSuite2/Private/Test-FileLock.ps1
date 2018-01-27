function Test-FileLock {
    param (
        [parameter(Mandatory = $false)]
        [string]
        $Path
    )
    if ($Path) {
        $oFile = New-Object System.IO.FileInfo $Path
        if ((Test-Path -Path $Path) -eq $false) {
            return $false
        }
        try {
            $oStream = $oFile.Open([System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
            if ($oStream) {
                $oStream.Close()
            }
            return $false
        }
        catch {
            return $true
        }
    }
}
Import-GoogleSDK

if ($global:PSGSuiteKey -and $MyInvocation.BoundParameters['Debug']) {
    $prevDebugPref = $DebugPreference
    $DebugPreference = "Continue"
    Write-Debug "`$global:PSGSuiteKey is set to a $($global:PSGSuiteKey.Count * 8)-bit key!"
    $DebugPreference = $prevDebugPref
}

if (!(Test-Path (Join-Path "~" ".scrthq"))) {
    New-Item -Path (Join-Path "~" ".scrthq") -ItemType Directory -Force | Out-Null
}

if ($PSVersionTable.ContainsKey('PSEdition') -and $PSVersionTable.PSEdition -eq 'Core' -and !$Global:PSGSuiteKey -and !$IsWindows) {
    if (!(Test-Path (Join-Path (Join-Path "~" ".scrthq") "BlockCoreCLREncryptionWarning.txt"))) {
        Write-Warning "CoreCLR does not support DPAPI encryption! Setting a basic AES key to prevent errors. Please create a unique key as soon as possible as this will only obfuscate secrets from plain text in the Configuration, the key is not secure as is. If you would like to prevent this message from displaying in the future, run the following command:`n`nBlock-CoreCLREncryptionWarning`n"
    }
    $Global:PSGSuiteKey = [Byte[]]@(1..16)
    $ConfigScope = "User"
}

if ($Global:PSGSuiteKey -is [System.Security.SecureString]) {
    $Method = "SecureString"
    if (!$ConfigScope) {
        $ConfigScope = "Machine"
    }
}
elseif ($Global:PSGSuiteKey -is [System.Byte[]]) {
    $Method = "AES Key"
    if (!$ConfigScope) {
        $ConfigScope = "Machine"
    }
}
else {
    $Method = "DPAPI"
    $ConfigScope = "User"
}

Add-MetadataConverter -Converters @{
    [SecureString] = {
        $encParams = @{}
        if ($Global:PSGSuiteKey -is [System.Byte[]]) {
            $encParams["Key"] = $Global:PSGSuiteKey
        }
        elseif ($Global:PSGSuiteKey -is [System.Security.SecureString]) {
            $encParams["SecureKey"] = $Global:PSGSuiteKey
        }
        'ConvertTo-SecureString "{0}"' -f (ConvertFrom-SecureString $_ @encParams)
    }
    "Secure" = {
        param([string]$String)
        $encParams = @{}
        if ($Global:PSGSuiteKey -is [System.Byte[]]) {
            $encParams["Key"] = $Global:PSGSuiteKey
        }
        elseif ($Global:PSGSuiteKey -is [System.Security.SecureString]) {
            $encParams["SecureKey"] = $Global:PSGSuiteKey
        }
        ConvertTo-SecureString $String @encParams
    }
    "ConvertTo-SecureString" = {
        param([string]$String)
        $encParams = @{}
        if ($Global:PSGSuiteKey -is [System.Byte[]]) {
            $encParams["Key"] = $Global:PSGSuiteKey
        }
        elseif ($Global:PSGSuiteKey -is [System.Security.SecureString]) {
            $encParams["SecureKey"] = $Global:PSGSuiteKey
        }
        ConvertTo-SecureString $String @encParams
    }
}

try {
    $confParams = @{
        Scope = $ConfigScope
    }
    if ($ConfigName) {
        $confParams["ConfigName"] = $ConfigName
        $Script:ConfigName = $ConfigName
    }
    try {
        if ($global:PSGSuite) {
            Write-Warning "Using config $(if ($global:PSGSuite.ConfigName){"name '$($global:PSGSuite.ConfigName)' "})found in variable: `$global:PSGSuite"
            Write-Verbose "$(($global:PSGSuite | Format-List | Out-String).Trim())"
            if ($global:PSGSuite -is [System.Collections.Hashtable]) {
                $global:PSGSuite = New-Object PSObject -Property $global:PSGSuite
            }
            $script:PSGSuite = $global:PSGSuite
        }
        else {
            Get-PSGSuiteConfig @confParams -ErrorAction Stop
        }
    }
    catch {
        if (Test-Path "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml") {
            Get-PSGSuiteConfig -Path "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml" -ErrorAction Stop
            Write-Warning "No Configuration.psd1 found at scope '$ConfigScope'; falling back to legacy XML. If you would like to convert your legacy XML to the newer Configuration.psd1, run the following command:

Get-PSGSuiteConfig -Path '$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml' -PassThru | Set-PSGSuiteConfig
"
        }
        else {
            Write-Warning "There was no config returned! Please make sure you are using the correct key or have a configuration already saved."
        }
    }
}
catch {
    Write-Warning "There was no config returned! Please make sure you are using the correct key or have a configuration already saved."
}
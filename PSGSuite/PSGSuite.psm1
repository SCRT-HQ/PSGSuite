Param
(
    [parameter(Position = 0)]
    [System.Byte[]]
    $EncryptionKey = $(if (Get-Command Import-Key -ErrorAction SilentlyContinue) {
        Import-Key
    }
    else {
        $null
    }),
    [parameter(Position = 1)]
    [string]
    $ConfigName = $null
)
#Get public and private function definition files.
$Public = @(Get-ChildItem -Recurse -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Recurse -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
$ModuleRoot = $PSScriptRoot

#Execute a scriptblock to load each function instead of dot sourcing
foreach ($file in @($Public + $Private)) {
    try {
        $ExecutionContext.InvokeCommand.InvokeScript(
            $false, 
            (
                [scriptblock]::Create(
                    [io.file]::ReadAllText(
                        $file.FullName,
                        [Text.Encoding]::UTF8
                    )
                )
            ), 
            $null, 
            $null
        )
    }
    catch {
        Write-Error "[$($file.Basename)] $($_.Exception.Message.ToString())"
    }
}

Import-GoogleSDK

$aliasHash = @{
    'Get-GSCalendarResourceList'        = 'Get-GSResourceList'
    'Switch-PSGSuiteDomain'             = 'Switch-PSGSuiteConfig'
    'Get-GSUserSchemaInfo'              = 'Get-GSUserSchema'
    'Get-GSUserLicenseInfo'             = 'Get-GSUserLicense'
    'Get-GSGmailMessageInfo'            = 'Get-GmailMessage'
    'New-GSCalendarResource'            = 'New-GSResource'
    'Update-GSCalendarResource'         = 'Update-GSResource'
    'Get-GSShortURLInfo'                = 'Get-GSShortURL'
    'Move-GSGmailMessageToTrash'        = 'Remove-GSGmailMessage'
    'Remove-GSGmailMessageFromTrash'    = 'Restore-GSGmailMessage'
    'Get-GSGmailFilterList'             = 'Get-GSGmailFilter'
    'Get-GSGmailLabelList'              = 'Get-GSGmailLabel'
    'Get-GSDriveFileInfo'               = 'Get-GSDriveFile'
    'Get-GSTeamDrivesList'              = 'Get-GSTeamDrive'
    'Add-GSDriveFilePermissions'        = 'Add-GSDrivePermission'
    'Get-GSDriveFilePermissionsList'    = 'Get-GSDrivePermission'
    'Get-GSGroupList'                   = 'Get-GSGroup'
    'Get-GSGroupMemberList'             = 'Get-GSGroupMember'
    'Get-GSOrgUnitList'                 = 'Get-GSOrganizationalUnit'
    'Get-GSOU'                          = 'Get-GSOrganizationalUnit'
    'Get-GSOrganizationalUnitList'      = 'Get-GSOrganizationalUnit'
    'Get-GSOrgUnit'                     = 'Get-GSOrganizationalUnit'
    'Get-GSMobileDeviceList'            = 'Get-GSMobileDevice'
    'Get-GSDataTransferApplicationList' = 'Get-GSDataTransferApplication'
    'Get-GSResourceList'                = 'Get-GSResource'
    'Get-GSUserASPList'                 = 'Get-GSUserASP'
    'Get-GSUserList'                    = 'Get-GSUser'
    'Get-GSUserSchemaList'              = 'Get-GSUserSchema'
    'Get-GSUserTokenList'               = 'Get-GSUserToken'
    'Get-GSUserLicenseList'             = 'Get-GSUserLicense'
    'Update-GSSheetValue'               = 'Export-GSSheet'
    'Export-PSGSuiteConfiguration'      = 'Set-PSGSuiteConfig'
    'Import-PSGSuiteConfiguration'      = 'Get-PSGSuiteConfig'
    'Set-PSGSuiteDefaultDomain'         = 'Switch-PSGSuiteConfig'
}
foreach ($key in $aliasHash.Keys) {
    try {
        Set-Alias -Name $key -Value $aliasHash[$key] -Force
    }
    catch {
        Write-Error "[ALIAS: $($key)] $($_.Exception.Message.ToString())"
    }
}

if (!(Test-Path (Join-Path "~" ".scrthq"))) {
    New-Item -Path (Join-Path "~" ".scrthq") -ItemType Directory -Force | Out-Null
}

if ($PSVersionTable.ContainsKey('PSEdition') -and $PSVersionTable.PSEdition -eq 'Core' -and !$EncryptionKey -and !$IsWindows) {
    if (!(Test-Path (Join-Path (Join-Path "~" ".scrthq") "BlockCoreCLREncryptionWarning.txt"))) {
        Write-Warning "CoreCLR does not support DPAPI encryption! Setting a basic AES key to prevent errors. Please create a unique key as soon as possible as this will only obfuscate secrets from plain text in the Configuration, the key is not secure as is. If you would like to prevent this message from displaying in the future, run the following command:`n`nBlock-CoreCLREncryptionWarning`n"
    }
    $EncryptionKey = [Byte[]]@(1..16)
    $ConfigScope = "User"
}

if ($EncryptionKey -is [System.Security.SecureString]) {
    $Method = "SecureString"
    if (!$ConfigScope) {
        $ConfigScope = "Machine"
    }
}
elseif ($EncryptionKey -is [System.Byte[]]) {
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
        if ($script:EncryptionKey -is [System.Byte[]]) {
            $encParams["Key"] = $script:EncryptionKey
        }
        elseif ($script:EncryptionKey -is [System.Security.SecureString]) {
            $encParams["SecureKey"] = $script:EncryptionKey
        }
        'Secure "{0}"' -f (ConvertFrom-SecureString $_ @encParams)
    }
    "Secure" = {
        param([string]$String)
        $encParams = @{}
        if ($script:EncryptionKey -is [System.Byte[]]) {
            $encParams["Key"] = $script:EncryptionKey
        }
        elseif ($script:EncryptionKey -is [System.Security.SecureString]) {
            $encParams["SecureKey"] = $script:EncryptionKey
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
        Get-PSGSuiteConfig @confParams -ErrorAction Stop
    }
    catch {
        if (Test-Path "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml") {
            Get-PSGSuiteConfig -Path "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml" -ErrorAction Stop
            Write-Warning "No Configuration.psd1 found at scope '$ConfigScope'; falling back to legacy XML. If you would like to convert your legacy XML to the newer Configuration.psd1, run the following command:`n`nGet-PSGSuiteConfig -Path '$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml' -PassThru | Set-PSGSuiteConfig`n"
        }
        else {
            Write-Warning "There was no config returned! Please make sure you are using the correct key or have a configuration already saved."
        }
    }
}
catch {
    Write-Warning "There was no config returned! Please make sure you are using the correct key or have a configuration already saved."
}
finally {
    Export-ModuleMember -Function $Public.Basename -Alias *
}
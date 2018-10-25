Param
(
    [parameter(Position = 0,ValueFromRemainingArguments = $true)]
    [AllowNull()]
    [Byte[]]
    $EncryptionKey = $null,
    [parameter(Position = 1)]
    [AllowNull()]
    [String]
    $ConfigName
)
$ModuleRoot = $PSScriptRoot
New-Variable -Name PSGSuiteKey -Value $EncryptionKey -Scope Global -Force

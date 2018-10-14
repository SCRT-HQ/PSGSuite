Param
(
    [parameter(Position = 0)]
    [System.Byte[]]
    $EncryptionKey = $(if (Get-Command Import-SCRTKey -ErrorAction SilentlyContinue) {
        Import-SCRTKey
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

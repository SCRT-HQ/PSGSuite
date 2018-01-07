function Block-CoreCLREncryptionWarning {
    New-Item -Path (Join-Path (Join-Path "~" ".scrthq") "BlockCoreCLREncryptionWarning.txt") -ItemType File -Force | Out-Null
}
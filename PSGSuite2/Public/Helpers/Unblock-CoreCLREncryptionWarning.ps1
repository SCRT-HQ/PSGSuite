function Unblock-CoreCLREncryptionWarning {
    if (Test-Path (Join-Path (Join-Path "~" ".scrthq") "BlockCoreCLREncryptionWarning.txt")) {
        Remove-Item -Path (Join-Path (Join-Path "~" ".scrthq") "BlockCoreCLREncryptionWarning.txt") -Force
    }
}
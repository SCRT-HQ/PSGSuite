function Unblock-CoreCLREncryptionWarning {
    <#
    .SYNOPSIS
    Unblocks CoreCLR encryption warning to ensure it appears if applicable (specific to PSGSuite)
    
    .DESCRIPTION
    Unblocks CoreCLR encryption warning to ensure it appears if applicable (specific to PSGSuite) by removing the following file if it exists: ~\.scrthq\BlockCoreCLREncryptionWarning.txt
    
    .EXAMPLE
    Unblock-CoreCLREncryptionWarning

    Removes the breadcrumb file to let PSGSuite know that you want to receive the CoreCLR encryption warning if applicable
    #>
    if (Test-Path (Join-Path (Join-Path "~" ".scrthq") "BlockCoreCLREncryptionWarning.txt")) {
        Remove-Item -Path (Join-Path (Join-Path "~" ".scrthq") "BlockCoreCLREncryptionWarning.txt") -Force
    }
}
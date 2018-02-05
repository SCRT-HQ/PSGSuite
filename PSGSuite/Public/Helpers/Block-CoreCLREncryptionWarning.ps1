function Block-CoreCLREncryptionWarning {
    <#
    .SYNOPSIS
    Blocks CoreCLR encryption warning from reappearing (specific to PSGSuite)
    
    .DESCRIPTION
    Blocks CoreCLR encryption warning from reappearing (specific to PSGSuite) by creating a blank txt file in the path: ~\.scrthq
    
    .EXAMPLE
    Block-CoreCLREncryptionWarning

    Creates the breadcrumb file to let PSGSuite know that you've acknowledged the CoreCLR encryption warning and it does not need to be displayed every time the module is imported
    #>
    New-Item -Path (Join-Path (Join-Path "~" ".scrthq") "BlockCoreCLREncryptionWarning.txt") -ItemType File -Force | Out-Null
}
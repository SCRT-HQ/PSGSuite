# Programmatically generated from template 'Module\Aliases.ps1'
# This file will be overwritten during the module build process.

$aliasHash = #    Alias  =>  =>  =>  =>  =>  =>  =>  =>  Function
@{
    'Add-GSDriveFilePermissions'        = 'Add-GSDrivePermission'
    'Export-PSGSuiteConfiguration'      = 'Set-PSGSuiteConfig'
    'Get-GSCalendarEventList'           = 'Get-GSCalendarEvent'
    'Get-GSCalendarResourceList'        = 'Get-GSResourceList'
    'Get-GSDataTransferApplicationList' = 'Get-GSDataTransferApplication'
    'Get-GSDriveFileInfo'               = 'Get-GSDriveFile'
    'Get-GSDriveFilePermissionsList'    = 'Get-GSDrivePermission'
    'Get-GSGmailDelegates'              = 'Get-GSGmailDelegate'
    'Get-GSGmailFilterList'             = 'Get-GSGmailFilter'
    'Get-GSGmailLabelList'              = 'Get-GSGmailLabel'
    'Get-GSGmailMessageInfo'            = 'Get-GSGmailMessage'
    'Get-GSGmailSendAsSettings'         = 'Get-GSGmailSendAsAlias'
    'Get-GSGmailSignature'              = 'Get-GSGmailSendAsAlias'
    'Get-GSGroupList'                   = 'Get-GSGroup'
    'Get-GSGroupMemberList'             = 'Get-GSGroupMember'
    'Get-GSMobileDeviceList'            = 'Get-GSMobileDevice'
    'Get-GSOrganizationalUnitList'      = 'Get-GSOrganizationalUnit'
    'Get-GSOrgUnit'                     = 'Get-GSOrganizationalUnit'
    'Get-GSOrgUnitList'                 = 'Get-GSOrganizationalUnit'
    'Get-GSOU'                          = 'Get-GSOrganizationalUnit'
    'Get-GSResourceList'                = 'Get-GSResource'
    'Get-GSTeamDrive'                   = 'Get-GSDrive'
    'Get-GSTeamDrivesList'              = 'Get-GSDrive'
    'Get-GSUserASPList'                 = 'Get-GSUserASP'
    'Get-GSUserLicenseInfo'             = 'Get-GSUserLicense'
    'Get-GSUserLicenseList'             = 'Get-GSUserLicense'
    'Get-GSUserList'                    = 'Get-GSUser'
    'Get-GSUserSchemaInfo'              = 'Get-GSUserSchema'
    'Get-GSUserSchemaList'              = 'Get-GSUserSchema'
    'Get-GSUserTokenList'               = 'Get-GSUserToken'
    'Import-PSGSuiteConfiguration'      = 'Get-PSGSuiteConfig'
    'Move-GSGmailMessageToTrash'        = 'Remove-GSGmailMessage'
    'New-GSCalendarResource'            = 'New-GSResource'
    'New-GSTeamDrive'                   = 'New-GSDrive'
    'Remove-GSGmailMessageFromTrash'    = 'Restore-GSGmailMessage'
    'Remove-GSTeamDrive'                = 'Remove-GSDrive'
    'Set-PSGSuiteDefaultDomain'         = 'Switch-PSGSuiteConfig'
    'Switch-PSGSuiteDomain'             = 'Switch-PSGSuiteConfig'
    'Update-GSCalendarResource'         = 'Update-GSResource'
    'Update-GSGmailSendAsSettings'      = 'Update-GSGmailSendAsAlias'
    'Update-GSSheetValue'               = 'Export-GSSheet'
    'Update-GSTeamDrive'                = 'Update-GSDrive'
}

foreach ($key in $aliasHash.Keys) {
    try {
        New-Alias -Name $key -Value $aliasHash[$key] -Force
    }
    catch {
        Write-Error "[ALIAS: $($key)] $($_.Exception.Message.ToString())"
    }
}

Export-ModuleMember -Alias '*'

# Programmatically generated from template 'OAuthScopes.ps1'
# This file will be overwritten during the module build process.

# Scope data that is used by the Get-PSGSuiteOAuthScope function.
$script:_PSGSuiteOAuthScopes = @'
[
  {
    "Function": "Remove-GSStudentGuardian",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.guardianlinks.students"
  },
  {
    "Function": "Remove-GSUserLicense",
    "Service": "Google.Apis.Licensing.v1.LicensingService",
    "Scope": "https://www.googleapis.com/auth/apps.licensing"
  },
  {
    "Function": "New-GSGroup",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "New-GSDomainAlias",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.domain"
  },
  {
    "Function": "Update-GSGmailImapSettings",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Get-GSCalendarACL",
    "Service": "Google.Apis.Calendar.v3.CalendarService",
    "Scope": "https://www.googleapis.com/auth/calendar"
  },
  {
    "Function": "Unblock-CoreCLREncryptionWarning",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Start-GSDriveFileUpload",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Show-PSGSuiteConfig",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Remove-GSDrivePermission",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Remove-GSGroup",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Update-GSResource",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.resource.calendar"
  },
  {
    "Function": "Set-GSDocContent",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Update-GSDriveRevision",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Remove-GSGroupAlias",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Clear-GSSheet",
    "Service": "Google.Apis.Sheets.v4.SheetsService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Remove-GSAdminRole",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.rolemanagement"
  },
  {
    "Function": "New-GSDriveFile",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Get-GSGroupAlias",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Get-GSUserLicense",
    "Service": "Google.Apis.Licensing.v1.LicensingService",
    "Scope": "https://www.googleapis.com/auth/apps.licensing"
  },
  {
    "Function": "Update-GSSheet",
    "Service": "Google.Apis.Sheets.v4.SheetsService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Get-GSUserToken",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Get-GSUserToken",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.security"
  },
  {
    "Function": "Get-GSGmailVacationSettings",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Remove-GSDriveRevision",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Update-GSUserPhoto",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Remove-GSUserPhoto",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Remove-GSGmailDelegate",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.sharing"
  },
  {
    "Function": "Get-GSDriveFile",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Update-GSCalendarEvent",
    "Service": "Google.Apis.Calendar.v3.CalendarService",
    "Scope": "https://www.googleapis.com/auth/calendar"
  },
  {
    "Function": "New-GSCourse",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.courses"
  },
  {
    "Function": "Remove-GSCalendarEvent",
    "Service": "Google.Apis.Calendar.v3.CalendarService",
    "Scope": "https://www.googleapis.com/auth/calendar"
  },
  {
    "Function": "Remove-GSDriveFile",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Add-GSCalendarEventReminder",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Remove-GSUserAlias",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Add-GSPrincipalGroupMembership",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Remove-GSCalendarAcl",
    "Service": "Google.Apis.Calendar.v3.CalendarService",
    "Scope": "https://www.googleapis.com/auth/calendar"
  },
  {
    "Function": "Update-GSGmailPopSettings",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Get-GSCourseInvitation",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.rosters"
  },
  {
    "Function": "Remove-GSUserASP",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Remove-GSUserASP",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.security"
  },
  {
    "Function": "Remove-GSAdminRoleAssignment",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.rolemanagement"
  },
  {
    "Function": "Add-GSUserAddress",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Get-GSChatSpace",
    "Service": "Google.Apis.HangoutsChat.v1.HangoutsChatService",
    "Scope": "https://www.googleapis.com/auth/chat.bot"
  },
  {
    "Function": "Get-GSChatSpace",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Get-GSChatSpace",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.readonly"
  },
  {
    "Function": "Block-CoreCLREncryptionWarning",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "New-GSGroupAlias",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Send-GSChatMessage",
    "Service": "Google.Apis.HangoutsChat.v1.HangoutsChatService",
    "Scope": "https://www.googleapis.com/auth/chat.bot"
  },
  {
    "Function": "Update-GSMobileDevice",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.device.mobile"
  },
  {
    "Function": "Update-GSGroupMember",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Export-GSDriveFile",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Get-GSDriveRevision",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Get-GSDriveFileUploadStatus",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Watch-GSDriveUpload",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Get-GSChatMessage",
    "Service": "Google.Apis.HangoutsChat.v1.HangoutsChatService",
    "Scope": "https://www.googleapis.com/auth/chat.bot"
  },
  {
    "Function": "Get-GSOrganizationalUnit",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.orgunit"
  },
  {
    "Function": "New-GSPresentationUpdateRequest",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Import-GSSheet",
    "Service": "Google.Apis.Sheets.v4.SheetsService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "New-GSGmailSendAsAlias",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.sharing"
  },
  {
    "Function": "Update-GSDrive",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Remove-GSOrganizationalUnit",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.orgunit"
  },
  {
    "Function": "Copy-GSDriveFile",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Remove-GSGmailSendAsAlias",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.sharing"
  },
  {
    "Function": "Restore-GSUser",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Restore-GSUser",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.readonly"
  },
  {
    "Function": "New-GSGmailSMIMEInfo",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "New-GSGmailSMIMEInfo",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.sharing"
  },
  {
    "Function": "Update-GSGroup",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Get-GSGmailAutoForwardingSettings",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Add-GSChatTextParagraph",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Get-GSUserAlias",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Get-GSUserAlias",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.readonly"
  },
  {
    "Function": "Remove-GSChatMessage",
    "Service": "Google.Apis.HangoutsChat.v1.HangoutsChatService",
    "Scope": "https://www.googleapis.com/auth/chat.bot"
  },
  {
    "Function": "Add-GSChatOnClick",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Update-GSGmailVacationSettings",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Remove-GSGmailFilter",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Add-GSChatKeyValue",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Get-GSUsageReport",
    "Service": "Google.Apis.Admin.Reports.reports_v1.ReportsService",
    "Scope": "https://www.googleapis.com/auth/admin.reports.usage.readonly"
  },
  {
    "Function": "Get-GSUserSchema",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Get-GSUserSchema",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.userschema"
  },
  {
    "Function": "Get-GSGmailPopSettings",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "New-GSDrive",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Add-GSCustomerPostalAddress",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Update-GSUserSchema",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Update-GSUserSchema",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.userschema"
  },
  {
    "Function": "Get-GSDomain",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.domain"
  },
  {
    "Function": "Get-GSGroupSettings",
    "Service": "Google.Apis.Groupssettings.v1.GroupssettingsService",
    "Scope": "https://www.googleapis.com/auth/apps.groups.settings"
  },
  {
    "Function": "Get-GSGroupSettings",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Get-GSGmailFilter",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Get-GSStudentGuardian",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.guardianlinks.students"
  },
  {
    "Function": "Update-GSGmailSendAsAlias",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Update-GSGmailSendAsAlias",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.sharing"
  },
  {
    "Function": "Add-GSDocContent",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Remove-GSUserToken",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Remove-GSUserToken",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.security"
  },
  {
    "Function": "Get-GSCourse",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.courses"
  },
  {
    "Function": "Clear-PSGSuiteServiceCache",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Get-GSGmailSendAsAlias",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Set-PSGSuiteConfig",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Add-GSCalendarSubscription",
    "Service": "Google.Apis.Calendar.v3.CalendarService",
    "Scope": "https://www.googleapis.com/auth/calendar"
  },
  {
    "Function": "Import-PSGSuiteConfig",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "New-GSUserSchema",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "New-GSUserSchema",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.userschema"
  },
  {
    "Function": "Get-GSDriveFolderSize",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Invoke-GSUserOffboarding",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Invoke-GSUserOffboarding",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.security"
  },
  {
    "Function": "Invoke-GSUserOffboarding",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.readonly"
  },
  {
    "Function": "Invoke-GSUserOffboarding",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.device.mobile"
  },
  {
    "Function": "Invoke-GSUserOffboarding",
    "Service": "Google.Apis.Licensing.v1.LicensingService",
    "Scope": "https://www.googleapis.com/auth/apps.licensing"
  },
  {
    "Function": "Remove-GSDrive",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Add-GSChatCard",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Update-GSCourse",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.courses"
  },
  {
    "Function": "Remove-GSCourseParticipant",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.rosters"
  },
  {
    "Function": "Get-GSDrivePermission",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Get-GSActivityReport",
    "Service": "Google.Apis.Admin.Reports.reports_v1.ReportsService",
    "Scope": "https://www.googleapis.com/auth/admin.reports.audit.readonly"
  },
  {
    "Function": "Set-GSUserSchema",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Set-GSUserSchema",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.userschema"
  },
  {
    "Function": "Get-GSGmailLanguageSettings",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Revoke-GSStudentGuardianInvitation",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.guardianlinks.students"
  },
  {
    "Function": "Get-GSUserASP",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Get-GSUserASP",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.security"
  },
  {
    "Function": "Get-GSDrive",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Add-GSUserPhone",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Set-GSUserLicense",
    "Service": "Google.Apis.Licensing.v1.LicensingService",
    "Scope": "https://www.googleapis.com/auth/apps.licensing"
  },
  {
    "Function": "Get-GSResource",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.resource.calendar"
  },
  {
    "Function": "New-GSUserVerificationCodes",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "New-GSUserVerificationCodes",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.security"
  },
  {
    "Function": "Set-GSGroupSettings",
    "Service": "Google.Apis.Groupssettings.v1.GroupssettingsService",
    "Scope": "https://www.googleapis.com/auth/apps.groups.settings"
  },
  {
    "Function": "New-GSDomain",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.domain"
  },
  {
    "Function": "Get-PSGSuiteConfig",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "New-GSCalendarACL",
    "Service": "Google.Apis.Calendar.v3.CalendarService",
    "Scope": "https://www.googleapis.com/auth/calendar"
  },
  {
    "Function": "Add-GSCourseParticipant",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.rosters"
  },
  {
    "Function": "Get-GSMobileDevice",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.device.mobile"
  },
  {
    "Function": "Remove-GSGroupMember",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Get-GSStudentGuardianInvitation",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.guardianlinks.students"
  },
  {
    "Function": "Get-GSSheetInfo",
    "Service": "Google.Apis.Sheets.v4.SheetsService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Get-GSDocContent",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Start-GSDataTransfer",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Start-GSDataTransfer",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.readonly"
  },
  {
    "Function": "Start-GSDataTransfer",
    "Service": "Google.Apis.Admin.DataTransfer.datatransfer_v1.DataTransferService",
    "Scope": "https://www.googleapis.com/auth/admin.datatransfer"
  },
  {
    "Function": "Update-GSUser",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Update-GSUser",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.readonly"
  },
  {
    "Function": "Remove-GSUserSchema",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Remove-GSUserSchema",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.userschema"
  },
  {
    "Function": "Add-GSGmailForwardingAddress",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.sharing"
  },
  {
    "Function": "Get-GSDriveFileList",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Add-GSGmailSmtpMsa",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Get-GSGmailSMIMEInfo",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Add-GSGmailFilter",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Update-GSGmailSignature",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Update-GSGmailSignature",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.sharing"
  },
  {
    "Function": "Update-GSOrganizationalUnit",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.orgunit"
  },
  {
    "Function": "Compare-ModuleVersion",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "New-GSAdminRole",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.rolemanagement"
  },
  {
    "Function": "Confirm-GSCourseInvitation",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.rosters"
  },
  {
    "Function": "Get-GSCalendarEvent",
    "Service": "Google.Apis.Calendar.v3.CalendarService",
    "Scope": "https://www.googleapis.com/auth/calendar"
  },
  {
    "Function": "Remove-GSCourse",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.courses"
  },
  {
    "Function": "Update-GSCalendarSubscription",
    "Service": "Google.Apis.Calendar.v3.CalendarService",
    "Scope": "https://www.googleapis.com/auth/calendar"
  },
  {
    "Function": "Sync-GSUserCache",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Sync-GSUserCache",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.readonly"
  },
  {
    "Function": "Add-GSUserOrganization",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Update-GSUserLicense",
    "Service": "Google.Apis.Licensing.v1.LicensingService",
    "Scope": "https://www.googleapis.com/auth/apps.licensing"
  },
  {
    "Function": "Update-GSChatMessage",
    "Service": "Google.Apis.HangoutsChat.v1.HangoutsChatService",
    "Scope": "https://www.googleapis.com/auth/chat.bot"
  },
  {
    "Function": "Get-GSDataTransfer",
    "Service": "Google.Apis.Admin.DataTransfer.datatransfer_v1.DataTransferService",
    "Scope": "https://www.googleapis.com/auth/admin.datatransfer"
  },
  {
    "Function": "New-GSCourseInvitation",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.rosters"
  },
  {
    "Function": "Revoke-GSUserVerificationCodes",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Revoke-GSUserVerificationCodes",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.security"
  },
  {
    "Function": "Stop-GSDriveFileUpload",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Remove-GSGmailSMIMEInfo",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Edit-GSPresentation",
    "Service": "Google.Apis.Slides.v1.SlidesService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Edit-GSPresentation",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Add-GSChatButton",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Get-GSClassroomUserProfile",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.profile.emails"
  },
  {
    "Function": "Get-GSClassroomUserProfile",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.profile.photos"
  },
  {
    "Function": "Get-GSClassroomUserProfile",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.rosters"
  },
  {
    "Function": "Get-GSGmailDelegate",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Get-GSGmailDelegate",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Remove-GSCourseAlias",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.courses"
  },
  {
    "Function": "Remove-GSCourseInvitation",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.rosters"
  },
  {
    "Function": "Get-GSCalendarSubscription",
    "Service": "Google.Apis.Calendar.v3.CalendarService",
    "Scope": "https://www.googleapis.com/auth/calendar"
  },
  {
    "Function": "Get-GSCourseParticipant",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.profile.emails"
  },
  {
    "Function": "Get-GSCourseParticipant",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.profile.photos"
  },
  {
    "Function": "Get-GSCourseParticipant",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.rosters"
  },
  {
    "Function": "New-GSUserAlias",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Show-GSDrive",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Copy-GSSheet",
    "Service": "Google.Apis.Sheets.v4.SheetsService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Get-GSPresentation",
    "Service": "Google.Apis.Slides.v1.SlidesService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Get-GSPresentation",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Update-GSChromeOSDevice",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.device.chromeos"
  },
  {
    "Function": "Remove-GSCalendarSubscription",
    "Service": "Google.Apis.Calendar.v3.CalendarService",
    "Scope": "https://www.googleapis.com/auth/calendar"
  },
  {
    "Function": "Remove-GSUser",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "New-GSOrganizationalUnit",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.orgunit"
  },
  {
    "Function": "Add-GSUserLocation",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Add-GSGmailDelegate",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Add-GSGmailDelegate",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.sharing"
  },
  {
    "Function": "Remove-GSDomainAlias",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.domain"
  },
  {
    "Function": "Update-GSDriveFile",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Add-GSChatCardSection",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Add-GSCalendarNotification",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Update-GSGmailLanguageSettings",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Add-GSUserSchemaField",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Get-GSGmailForwardingAddress",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Add-GSSheetValues",
    "Service": "Google.Apis.Sheets.v4.SheetsService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Get-PSGSuiteServiceCache",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "New-GSStudentGuardianInvitation",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.guardianlinks.students"
  },
  {
    "Function": "New-GSCourseAlias",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.courses"
  },
  {
    "Function": "Add-GSChatCardAction",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Remove-GSDomain",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.domain"
  },
  {
    "Function": "Get-GSDriveProfile",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Hide-GSDrive",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "New-GSSheet",
    "Service": "Google.Apis.Sheets.v4.SheetsService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "New-GSCalendarEvent",
    "Service": "Google.Apis.Calendar.v3.CalendarService",
    "Scope": "https://www.googleapis.com/auth/calendar"
  },
  {
    "Function": "Get-PSGSuiteOAuthScope",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Get-GSUserPhoto",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Get-GSUserPhoto",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.readonly"
  },
  {
    "Function": "Switch-PSGSuiteConfig",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Update-GSGmailAutoForwardingSettings",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.sharing"
  },
  {
    "Function": "Export-GSSheet",
    "Service": "Google.Apis.Sheets.v4.SheetsService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "Get-GSUser",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Get-GSUser",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.readonly"
  },
  {
    "Function": "Add-GSDrivePermission",
    "Service": "Google.Apis.Drive.v3.DriveService",
    "Scope": "https://www.googleapis.com/auth/drive"
  },
  {
    "Function": "New-GSResource",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.resource.calendar"
  },
  {
    "Function": "Get-GSDomainAlias",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.domain"
  },
  {
    "Function": "Export-PSGSuiteConfig",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Remove-GSResource",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.resource.calendar"
  },
  {
    "Function": "Get-GSGroup",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Get-GSChromeOSDevice",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.device.chromeos"
  },
  {
    "Function": "Update-GSCustomer",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.customer"
  },
  {
    "Function": "Update-GSAdminRole",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.rolemanagement"
  },
  {
    "Function": "New-GSAdminRoleAssignment",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.rolemanagement"
  },
  {
    "Function": "New-GSAdminRoleAssignment",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "New-GSAdminRoleAssignment",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.readonly"
  },
  {
    "Function": "Get-GSCourseAlias",
    "Service": "Google.Apis.Classroom.v1.ClassroomService",
    "Scope": "https://www.googleapis.com/auth/classroom.courses"
  },
  {
    "Function": "Get-GSGroupMember",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Get-GSChatConfig",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Add-GSUserExternalId",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Get-GSCalendar",
    "Service": "Google.Apis.Calendar.v3.CalendarService",
    "Scope": "https://www.googleapis.com/auth/calendar"
  },
  {
    "Function": "Add-GSGroupMember",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Get-GSUserVerificationCodes",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Get-GSUserVerificationCodes",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.security"
  },
  {
    "Function": "New-GSUser",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Test-GSGroupMembership",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Add-GSEventAttendee",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Remove-GSPrincipalGroupMembership",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Get-GSAdminRoleAssignment",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.rolemanagement"
  },
  {
    "Function": "Get-GSAdminRoleAssignment",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.rolemanagement.readonly"
  },
  {
    "Function": "Get-GSAdminRoleAssignment",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user"
  },
  {
    "Function": "Get-GSAdminRoleAssignment",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.user.readonly"
  },
  {
    "Function": "Add-GSUserEmail",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Add-GSUserIm",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Update-GSGroupSettings",
    "Service": "Google.Apis.Groupssettings.v1.GroupssettingsService",
    "Scope": "https://www.googleapis.com/auth/apps.groups.settings"
  },
  {
    "Function": "Update-GSGroupSettings",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.group"
  },
  {
    "Function": "Get-GSGmailImapSettings",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.basic"
  },
  {
    "Function": "Get-GSAdminRole",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.rolemanagement"
  },
  {
    "Function": "Add-GSChatImage",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Add-GSUserRelation",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Get-GSChatMember",
    "Service": "Google.Apis.HangoutsChat.v1.HangoutsChatService",
    "Scope": "https://www.googleapis.com/auth/chat.bot"
  },
  {
    "Function": "Send-GSGmailSendAsConfirmation",
    "Service": "Google.Apis.Gmail.v1.GmailService",
    "Scope": "https://www.googleapis.com/auth/gmail.settings.sharing"
  },
  {
    "Function": "New-GoogleService",
    "Service": null,
    "Scope": null
  },
  {
    "Function": "Remove-GSMobileDevice",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.device.mobile"
  },
  {
    "Function": "Get-GSDataTransferApplication",
    "Service": "Google.Apis.Admin.DataTransfer.datatransfer_v1.DataTransferService",
    "Scope": "https://www.googleapis.com/auth/admin.datatransfer"
  },
  {
    "Function": "Get-GSCustomer",
    "Service": "Google.Apis.Admin.Directory.directory_v1.DirectoryService",
    "Scope": "https://www.googleapis.com/auth/admin.directory.customer"
  }
]
'@ | ConvertFrom-Json

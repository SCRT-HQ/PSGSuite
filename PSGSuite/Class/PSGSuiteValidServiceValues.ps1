# Programmatically generated from template 'OAuthScopes.ps1'
# This file will be overwritten during the module build process.

# Class that provides parameter validation for the Google API services that are used by PSGSuite.
class PSGSuiteValidServiceValues : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $Values = @(
            'Google.Apis.Admin.DataTransfer.datatransfer_v1.DataTransferService',
            'Google.Apis.Admin.Directory.directory_v1.DirectoryService',
            'Google.Apis.Admin.Reports.reports_v1.ReportsService',
            'Google.Apis.Calendar.v3.CalendarService',
            'Google.Apis.Classroom.v1.ClassroomService',
            'Google.Apis.Drive.v3.DriveService',
            'Google.Apis.Gmail.v1.GmailService',
            'Google.Apis.Groupssettings.v1.GroupssettingsService',
            'Google.Apis.HangoutsChat.v1.HangoutsChatService',
            'Google.Apis.Licensing.v1.LicensingService',
            'Google.Apis.Sheets.v4.SheetsService',
            'Google.Apis.Slides.v1.SlidesService'
        )
        return $Values
    }
}

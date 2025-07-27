# Programmatically generated from template 'oauthscopes.ps1'
# This file will be overwritten during the module build process.

# Class that provides parameter validation for the list of OAuth scopes that are used by all PSGSuite functions.
class PSGSuiteValidOAuthScopeValues : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $Values = @(
            'https://www.googleapis.com/auth/admin.datatransfer',
            'https://www.googleapis.com/auth/admin.directory.customer',
            'https://www.googleapis.com/auth/admin.directory.device.chromeos',
            'https://www.googleapis.com/auth/admin.directory.device.mobile',
            'https://www.googleapis.com/auth/admin.directory.domain',
            'https://www.googleapis.com/auth/admin.directory.group',
            'https://www.googleapis.com/auth/admin.directory.orgunit',
            'https://www.googleapis.com/auth/admin.directory.resource.calendar',
            'https://www.googleapis.com/auth/admin.directory.rolemanagement',
            'https://www.googleapis.com/auth/admin.directory.rolemanagement.readonly',
            'https://www.googleapis.com/auth/admin.directory.user',
            'https://www.googleapis.com/auth/admin.directory.user.readonly',
            'https://www.googleapis.com/auth/admin.directory.user.security',
            'https://www.googleapis.com/auth/admin.directory.userschema',
            'https://www.googleapis.com/auth/admin.reports.audit.readonly',
            'https://www.googleapis.com/auth/admin.reports.usage.readonly',
            'https://www.googleapis.com/auth/apps.groups.settings',
            'https://www.googleapis.com/auth/apps.licensing',
            'https://www.googleapis.com/auth/calendar',
            'https://www.googleapis.com/auth/chat.bot',
            'https://www.googleapis.com/auth/classroom.courses',
            'https://www.googleapis.com/auth/classroom.guardianlinks.students',
            'https://www.googleapis.com/auth/classroom.profile.emails',
            'https://www.googleapis.com/auth/classroom.profile.photos',
            'https://www.googleapis.com/auth/classroom.rosters',
            'https://www.googleapis.com/auth/drive',
            'https://www.googleapis.com/auth/gmail.settings.basic',
            'https://www.googleapis.com/auth/gmail.settings.sharing',
            'https://www.googleapis.com/auth/userinfo.email',
            'openid'
        )
        return $Values
    }
}

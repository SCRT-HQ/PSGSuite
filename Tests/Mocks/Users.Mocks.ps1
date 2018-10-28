# Load DirectoryService class for mocking New-GoogleService
. ([System.IO.Path]::Combine($PSScriptRoot,'..','Classes','DirectoryService.MockClass.ps1'))

Mock 'New-GoogleService' -ModuleName PSGSuite -ParameterFilter {$ServiceType -eq 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'} -MockWith {
    Write-Verbose "Mocking New-GoogleService for ServiceType '$ServiceType' using the DirectoryService class"
    return [DirectoryService]::new()
}

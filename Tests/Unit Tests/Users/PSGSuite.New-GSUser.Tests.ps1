<#
    * Unit test files should be wrapped with InModuleScope
    * Each unit test file should have the following above the Describe block(s):
        1. A call to dot-source the core mocks and classes
        2. A call to dot-source the appropriate Service mock and classes for the function being tested
#>

InModuleScope PSGSuite {

    #region: Load service and config mocks and validate mock via $null ApplicationName
    Write-Verbose "Loading Core mocks"
    . ([System.IO.Path]::Combine("$env:BHProjectPath","Tests","Mocks","Core.Mocks.ps1"))
    Write-Verbose "Loading DirectoryService mock"
    . ([System.IO.Path]::Combine("$env:BHProjectPath","Tests","Mocks","DirectoryService.Mocks.ps1"))
    Describe 'DirectoryService' -Tag 'Core' {
        Context 'When a mocked Directory service is created' {
            It 'ApplicationName should be $null' {
                $service = New-GoogleService -ServiceType 'Google.Apis.Admin.Directory.directory_v1.DirectoryService' -Scope 'Mock' -User 'MockUser@test.com' -Verbose
                $service.ApplicationName | Should -BeNullOrEmpty
            }
        }
    }
    #endregion

    Describe 'New-GSUser mock tests' -Tag 'Directory' {
        Context 'When New-GSUser creates a user' {
            $testCase = @('user1@domain.com','user1.1@domain.com','user1.2@domain.com','user2@domain.com','user2.1@domain.com','user2.2@domain.com','user1@domain2.com','user2@domain2.com','admin@domain.com') | Foreach-Object {@{item = $_}}
            It "Should fail to create existing user <item>" -TestCases $testCase {
                param($item)
                {New-GSUser -PrimaryEmail $item -GivenName 'Test' -FamilyName 'User' -Password (ConvertTo-SecureString '1234567890' -AsPlainText -Force) -Verbose} | Should -Throw -ExpectedMessage "User $item already exists!"
            }
            It "Should create a new user and have it be available immediately" {
                $newEmail = "userX@domain.com"
                {Get-GSUser $newEmail -ErrorAction Stop} | Should -Throw -ExpectedMessage "User $newEmail not found!"
                {New-GSUser -PrimaryEmail $newEmail -GivenName 'Test' -FamilyName 'User' -Password (ConvertTo-SecureString '1234567890' -AsPlainText -Force) -Verbose} | Should -Not -Throw
                {Get-GSUser $newEmail -ErrorAction Stop} | Should -Not -Throw
            }
        }
    }
}

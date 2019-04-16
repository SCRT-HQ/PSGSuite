<#
    * Unit test files should be wrapped with InModuleScope
    * Each unit test file should have the following above the Describe block(s):
        1. A call to dot-source the core mocks and classes
        2. A call to dot-source the appropriate Service mock and classes for the function being tested
#>

InModuleScope PSGSuite {

    #region: Load service and config mocks and validate mock via $null ApplicationName
    Write-Verbose "Loading Core mocks"
    . ([System.IO.Path]::Combine("$env:BHProjectPath","Tests","0. Mocks","Core.Mocks.ps1"))
    Write-Verbose "Loading DirectoryService mock"
    . ([System.IO.Path]::Combine("$env:BHProjectPath","Tests","0. Mocks","DirectoryService.Mocks.ps1"))
    Describe 'DirectoryService' -Tag 'Core' {
        Context 'When a mocked Directory service is created' {
            It 'ApplicationName should be $null' {
                $service = New-GoogleService -ServiceType 'Google.Apis.Admin.Directory.directory_v1.DirectoryService' -Scope 'Mock' -User 'MockUser@test.com'
                $service.ApplicationName | Should -BeNullOrEmpty
            }
        }
    }
    #endregion

    Describe 'Get-GSUser mock tests' -Tag 'Directory' {
        Context 'When Get-GSUser lists users' {
            $result = Get-GSUser -Filter *
            $testCase = @('user1@domain.com','user1.1@domain.com','user1.2@domain.com','user2@domain.com','user2.1@domain.com','user2.2@domain.com','user1@domain2.com','user2@domain2.com','admin@domain.com') | Foreach-Object {@{item = $_}}
            It "[Full list] PrimaryEmail should contain <item>" -TestCases $testCase {
                param($item)
                $result.PrimaryEmail | Should -Contain $item
            }
            It '[Full list] PrimaryEmail should not contain "user3@domain.com"' {
                $result.PrimaryEmail | Should -Not -Contain 'user3@domain.com'
            }
            $result = Get-GSUser -SearchBase "/Users/2" -SearchScope Subtree
            $testCase = @('user2@domain.com','user2.1@domain.com','user2.2@domain.com') | Foreach-Object {@{item = $_}}
            It "[Filtered list] PrimaryEmail should contain <item>" -TestCases $testCase {
                param($item)
                $result.PrimaryEmail | Should -Contain $item
            }
            $testCase = @('user1@domain.com','user1.1@domain.com','user1.2@domain.com','user1@domain2.com','user3@domain.com') | Foreach-Object {@{item = $_}}
            It "[Filtered list] PrimaryEmail should not contain <item>" -TestCases $testCase {
                param($item)
                $result.PrimaryEmail | Should -Not -Contain $item
            }
        }
        Context 'When Get-GSUser lists users from a specific domain' {
            $result = Get-GSUser -Filter * -Domain domain2.com
            $testCase = @('user1@domain2.com','user2@domain2.com') | Foreach-Object {@{item = $_}}
            It "[Domain list] PrimaryEmail should contain <item>" -TestCases $testCase {
                param($item)
                $result.PrimaryEmail | Should -Contain $item
            }
            It '[Domain list] PrimaryEmail should not contain "user1@domain.com"' {
                $result.PrimaryEmail | Should -Not -Contain 'user1@domain.com'
            }
        }
        Context 'When Get-GSUser gets specific users' {
            $testCase = @('user1@domain.com','user1.1@domain.com','user1.2@domain.com','user2@domain.com','user2.1@domain.com','user2.2@domain.com','admin@domain.com') | Foreach-Object {@{item = $_}}
            It "Should not throw when getting <item>" -TestCases $testCase {
                param($item)
                {Get-GSUser -User $item} | Should -Not -Throw
            }
            It "Should return correct PrimaryEmail when getting <item>" -TestCases $testCase {
                param($item)
                $result = Get-GSUser -User $item
                $result.PrimaryEmail | Should -BeExactly $item
            }
            $testCase = @('user1@domain.com','user2@domain.com') | Foreach-Object {@{item = $_}}
            It "Should return correct OrgUnitPath when getting <item>" -TestCases $testCase {
                param($item)
                $namePart = $item -replace '@.*'
                $id = $namePart.SubString($namePart.Length -1)
                $result = Get-GSUser -User $item
                $result.OrgUnitPath | Should -BeExactly "/Users/$id"
            }
            It 'Should throw when getting user3@domain.com' {
                {Get-GSUser -User 'user3@domain.com'} | Should -Throw -ExpectedMessage "User user3@domain.com not found!"
            }
            It 'Should get the AdminEmail user when no user or filter is specified' {
                (Get-GSUser).PrimaryEmail | Should -BeExactly 'admin@domain.com'
            }
        }
    }
}

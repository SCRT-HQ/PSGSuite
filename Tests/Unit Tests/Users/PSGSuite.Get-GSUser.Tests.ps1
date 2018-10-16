InModuleScope PSGSuite {
    . ([System.IO.Path]::Combine("$env:BHProjectPath","Tests","Mocks","Users.Mocks.ps1"))
    Describe 'Directory function mock tests' {
        Context 'When a mocked Directory service is created' {
            It 'ApplicationName should be $null' {
                $service = New-GoogleService -ServiceType 'Google.Apis.Admin.Directory.directory_v1.DirectoryService' -Scope 'Mock' -User 'MockUser@test.com' -Verbose
                $service.ApplicationName | Should -BeNullOrEmpty
            }
        }
        Context 'When Get-GSUser lists users' {
            $result = Get-GSUser -Filter * -Verbose
            $testCase = @('user1@domain.com','user1.1@domain.com','user1.2@domain.com','user2@domain.com','user2.1@domain.com','user2.2@domain.com') | Foreach-Object {@{item = $_}}
            It "[Full list] PrimaryEmail should contain <item>" -TestCases $testCase {
                param($item)
                $result.PrimaryEmail | Should -Contain $item
            }
            It '[Full list] PrimaryEmail should not contain "user3@domain.com"' {
                $result.PrimaryEmail | Should -Not -Contain 'user3@domain.com'
            }
            $result = Get-GSUser -SearchBase "/Users/2" -SearchScope Subtree -Verbose
            $testCase = @('user2@domain.com','user2.1@domain.com','user2.2@domain.com') | Foreach-Object {@{item = $_}}
            It "[Filtered list] PrimaryEmail should contain <item>" -TestCases $testCase {
                param($item)
                $result.PrimaryEmail | Should -Contain $item
            }
            $testCase = @('user1@domain.com','user1.1@domain.com','user1.2@domain.com','user3@domain.com') | Foreach-Object {@{item = $_}}
            It "[Filtered list] PrimaryEmail should not contain <item>" -TestCases $testCase {
                param($item)
                $result.PrimaryEmail | Should -Not -Contain $item
            }
        }
        Context 'When Get-GSUser gets a user' {
            $testCase = @('user1@domain.com','user1.1@domain.com','user1.2@domain.com','user2@domain.com','user2.1@domain.com','user2.2@domain.com') | Foreach-Object {@{item = $_}}
            It "Should not throw when getting <item>" -TestCases $testCase {
                param($item)
                {Get-GSUser -User $item -Verbose} | Should -Not -Throw
            }
            It "Should return correct PrimaryEmail when getting <item>" -TestCases $testCase {
                param($item)
                $result = Get-GSUser -User $item -Verbose
                $result.PrimaryEmail | Should -BeExactly $item
            }
            $testCase = @('user1@domain.com','user2@domain.com') | Foreach-Object {@{item = $_}}
            It "Should return correct OrgUnitPath when getting <item>" -TestCases $testCase {
                param($item)
                $namePart = $item -replace '@.*'
                $id = $namePart.SubString($namePart.Length -1)
                $result = Get-GSUser -User $item -Verbose
                $result.OrgUnitPath | Should -BeExactly "/Users/$id"
            }
            It 'Should throw when getting user3@domain.com' {
                {Get-GSUser -User 'user3@domain.com' -Verbose} | Should -Throw "User not found!"
            }
        }
    }
}

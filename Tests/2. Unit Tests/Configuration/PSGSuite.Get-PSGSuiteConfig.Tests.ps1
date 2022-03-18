<#
    * Unit test files should be wrapped with InModuleScope
    * Each unit test file should have the following above the Describe block(s):
        1. A call to dot-source the core mocks and classes
        2. A call to dot-source the appropriate Service mock and classes for the function being tested
#>

InModuleScope PSGSuite {
    # Not importing the Core Mocks described above because we're testing some of that core
    $ConfigDir = [System.IO.Path]::Combine("$env:BHProjectPath", "Tests", "2. Unit Tests", "Configuration")
    Describe 'Get-PSGSuiteConfig mock tests' -Tag 'Configuration' {
        Context 'When Get-PSGSuiteConfig retreives a config with only JSONServiceKey' {
            $ConfigPSD1 = [System.IO.Path]::Combine($ConfigDir, "JSONServiceOnly.psd1")
            $config = Get-PSGSuiteConfig -Path $ConfigPSD1 -PassThru -NoImport
            It "Should return JSONServiceAccountKey"  {
                $config.JSONServiceAccountKey | Should -Not -BeNullOrEmpty
            }
            It "Should return ServiceAccountClientID as client_id from JSONServiceAccountKey" {
                $config.ServiceAccountClientID | Should -Be '6789'
            }
            It "Should return AppEmail as client_email from JSONServiceAccountKey"  {
                $config.AppEmail | Should -Be 'service@psgsuite.io'
            }
            It "Should return AdminEmail as client_email from JSONServiceAccountKey"  {
                $config.AdminEmail | Should -Be 'service@psgsuite.io'
            }
        }
        Context 'When Get-PSGSuiteConfig retreives a config with JSONServiceKey and AdminEmail' {
            $ConfigPSD1 = [System.IO.Path]::Combine($ConfigDir, "JSONServiceAndAdminEmail.psd1")
            $config = Get-PSGSuiteConfig -Path $ConfigPSD1 -PassThru -NoImport
            It "Should return JSONServiceAccountKey"  {
                $config.JSONServiceAccountKey | Should -Not -BeNullOrEmpty
            }
            It "Should return ServiceAccountClientID as client_id from JSONServiceAccountKey" {
                $config.ServiceAccountClientID | Should -Be '6789'
            }
            It "Should return AppEmail as client_email from JSONServiceAccountKey"  {
                $config.AppEmail | Should -Be 'service@psgsuite.io'
            }
            It "Should return AdminEmail from Config"  {
                $config.AdminEmail | Should -Be 'admin@psgsuite.io'
            }
        }
        Context 'When Get-PSGSuiteConfig retreives a config with only AppEmail defined' {
            $ConfigPSD1 = [System.IO.Path]::Combine($ConfigDir, "AppEmailOnly.psd1")
            $config = Get-PSGSuiteConfig -Path $ConfigPSD1 -PassThru -NoImport
            It "Should return AppEmail as from config"  {
                $config.AppEmail | Should -Be 'app@psgsuite.io'
            }
            It "Should return AdminEmail as AppEmail from config when no AppEmail present"  {
                $config.AdminEmail | Should -Be 'app@psgsuite.io'
            }
        }
        Context 'When Get-PSGSuiteConfig retreives a config with only ClientSecrets defined' {
            $ConfigPSD1 = [System.IO.Path]::Combine($ConfigDir, "ClientSecrets.psd1")
            $config = Get-PSGSuiteConfig -Path $ConfigPSD1 -PassThru -NoImport
            It "Should return ClientSecrets"  {
                $config.ClientSecrets | Should -Not -BeNullOrEmpty
            }
            It "Should return ServiceAccountClientID as installed.client_id from Client Secrets"  {
                $config.ServiceAccountClientID | Should -Be '123-abc.apps.googleusercontent.com'
            }
        }
    }
}

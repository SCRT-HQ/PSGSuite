<#
    * Unit test files should be wrapped with InModuleScope
    * Each unit test file should have the following above the Describe block(s):
        1. A call to dot-source the core mocks and classes
        2. A call to dot-source the appropriate Service mock and classes for the function being tested
#>

InModuleScope PSGSuite {
    # Not importing the Core Mocks described above because we're testing some of that core
    $ConfigDir = [System.IO.Path]::Combine("$env:BHProjectPath", "Tests", "2. Unit Tests", "Configuration")
    Describe 'Import-PSGSuiteConfig mock tests' -Tag 'Configuration' {
        # Validating that the config is properly run through Get-GSDecryptedConfig by checking implied
        # properties of returned configs
        Context 'When Import-PSGSuiteConfig imports a config via file' {
            $ConfigJSON = [System.IO.Path]::Combine($ConfigDir, "JSONConfiguration.json")
            $config = Import-PSGSuiteConfig -Path $ConfigJSON -PassThru -Temporary
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
        Context 'When Import-PSGSuiteConfig imports a config via JSON' {
            # This does the same thing that importing via file does just front loading the converstion to JSON
            $ConfigJSON = [System.IO.Path]::Combine($ConfigDir, "JSONConfiguration.json")
            $JSON = Get-Content -raw $ConfigJSON
            $config = Import-PSGSuiteConfig -JSON $JSON -PassThru -Temporary
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
        Context 'When Import-PSGSuiteConfig imports a config via Object' {
            #This assembles an object by reading a service key directly and creating a config based on that
            $JSONServiceKey = [System.IO.Path]::Combine($ConfigDir, "JSONServiceKey.json")
            $ServiceKey = Get-Content -raw $JSONServiceKey
            $config = Import-PSGSuiteConfig -Object ([pscustomobject]@{JSONServiceAccountKey = $servicekey}) -PassThru -Temporary
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
    }
}

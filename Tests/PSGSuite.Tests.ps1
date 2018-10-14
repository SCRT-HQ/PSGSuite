$PSVersion = $PSVersionTable.PSVersion.Major
$ModuleName = "PSGSuite"
$projectRoot = Resolve-Path "$PSScriptRoot\.."
$ModulePath = Resolve-Path "$projectRoot\out\$ModuleName"
$decompiledModulePath = Resolve-Path "$projectRoot\$ModuleName"
$env:EnablePSGSuiteDebug = $true

# Verbose output for non-master builds on appveyor
# Handy for troubleshooting.
# Splat @Verbose against commands as needed (here or in pester tests)
$Verbose = @{}
if ($ENV:BHBranchName -eq "development" -or $env:BHCommitMessage -match "!verbose") {
    $Verbose.add("Verbose",$True)
}

$moduleRoot = Split-Path (Resolve-Path "$ModulePath\*\*.psd1")

Import-Module $ModulePath -Force -Verbose:$false

Describe "Module tests: $ModuleName" {
    Context "Confirm private functions are not exported on module import" {
        It "Should throw when checking for New-MimeMessage in the exported commands" {
            {Get-Command -Name New-MimeMessage -Module PSGSuite -ErrorAction Stop} | Should -Throw "The term 'New-MimeMessage' is not recognized as the name of a cmdlet, function, script file, or operable program."
        }
    }
    Context "Confirm files are valid Powershell syntax" {
        $scripts = Get-ChildItem $decompiledModulePath -Include *.ps1,*.psm1,*.psd1 -Recurse

        $testCase = $scripts | Foreach-Object {@{file = $_}}
        It "Script <file> should be valid Powershell" -TestCases $testCase {
            param($file)

            $file.fullname | Should Exist

            $contents = Get-Content -Path $file.fullname -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
            $errors.Count | Should Be 0
        }
    }
    Context "Confirm all aliases are created" {
        $aliasHash = . "$decompiledModulePath\Aliases\PSGSuite.Aliases.ps1"

        $testCase = $aliasHash.Keys | ForEach-Object {@{Name = $_;Value = $aliasHash[$_]}}

        It "Alias <Name> should exist for command <Value>" -TestCases $testCase {
            param($Name,$Value)

            {Get-Alias $Name -ErrorAction Stop} | Should -Not -Throw
            (Get-Alias $Name).ReferencedCommand.Name | Should -Be $Value
        }
    }
    Context "Confirm there are no duplicate function names in private and public folders" {
        It 'Should have no duplicate functions' {
            $functions = Get-ChildItem "$decompiledModulePath\Public" -Recurse -Include *.ps1 | Select-Object -ExpandProperty BaseName
            $functions += Get-ChildItem "$decompiledModulePath\Private" -Recurse -Include *.ps1 | Select-Object -ExpandProperty BaseName
            ($functions | Group-Object | Where-Object {$_.Count -gt 1}).Count | Should -BeLessThan 1
        }
    }
}

Describe "Function contents" {
    Context "All non-helper public functions should use Write-Verbose" {
        $scripts = Get-ChildItem "$decompiledModulePath\Public" -Include *.ps1 -Recurse | Where-Object {$_.FullName -notlike "*Helpers*"}
        $testCase = $scripts | Foreach-Object {@{file = $_;Name = $_.BaseName}}
        It "Function <Name> should contain verbose output" -TestCases $testCase {
            param($file,$Name)
            $file.fullname | Should -FileContentMatch 'Write-Verbose'
        }
    }
    Context "All 'Remove' functions should SupportsShouldProcess" {
        $scripts = Get-ChildItem "$decompiledModulePath\Public" -Include 'Remove-*.ps1' -Recurse | Where-Object {$_.FullName -notlike "*Helpers*"}
        $testCase = $scripts | Foreach-Object {@{file = $_;Name = $_.BaseName}}
        It "Function <Name> should contain SupportsShouldProcess" -TestCases $testCase {
            param($file,$Name)
            $file.fullname | Should -FileContentMatch 'SupportsShouldProcess'
        }
    }
    Context "All 'Remove' functions should contain 'PSCmdlet.ShouldProcess'" {
        $scripts = Get-ChildItem "$decompiledModulePath\Public" -Include 'Remove-*.ps1' -Recurse | Where-Object {$_.FullName -notlike "*Helpers*"}
        $testCase = $scripts | Foreach-Object {@{file = $_;Name = $_.BaseName}}
        It "Function <Name> should contain PSCmdlet.ShouldProcess" -TestCases $testCase {
            param($file,$Name)
            $file.fullname | Should -FileContentMatch 'PSCmdlet.ShouldProcess'
        }
    }
}

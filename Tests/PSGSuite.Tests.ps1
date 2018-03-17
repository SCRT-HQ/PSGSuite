$PSVersion = $PSVersionTable.PSVersion.Major
$ModuleName = "PSGSuite"
$projectRoot = Resolve-Path "$PSScriptRoot\.."
$ModulePath = Resolve-Path "$projectRoot\$ModuleName"

# Verbose output for non-master builds on appveyor
# Handy for troubleshooting.
# Splat @Verbose against commands as needed (here or in pester tests)
$Verbose = @{}
if ($ENV:BHBranchName -eq "development" -or $env:BHCommitMessage -match "!verbose") {
    $Verbose.add("Verbose",$True)
}

Import-Module 'Configuration' -RequiredVersion 1.2.0
Import-Module $ModulePath -Force

Describe "Previous build validation" {
    Context "Failure breadcrumb from previous build" {
        It "Should not exist" {
            "$projectRoot\BuildFailed.txt" | Should -Not -Exist
        }
    }
}

Describe "Module tests: $ModuleName" {
    Context "Confirm private functions are not exported on module import" {
        It "Should throw when checking for New-GoogleService in the exported commands" {
            {Get-Command -Name New-GoogleService -Module PSGSuite -ErrorAction Stop} | Should -Throw "The term 'New-GoogleService' is not recognized as the name of a cmdlet, function, script file, or operable program."
        }
    }
    Context "Confirm files are valid Powershell syntax" {
        $scripts = Get-ChildItem $ModulePath -Include *.ps1,*.psm1,*.psd1 -Recurse

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
        $aliasHash = . "$ModulePath\Aliases\PSGSuite.Aliases.ps1"

        $testCase = $aliasHash.Keys | ForEach-Object {@{Name = $_;Value = $aliasHash[$_]}}

        It "Alias <Name> should exist for command <Value>" -TestCases $testCase {
            param($Name,$Value)

            {Get-Alias $Name -ErrorAction Stop} | Should -Not -Throw
            (Get-Alias $Name).ReferencedCommand.Name | Should -Be $Value
        }
    }
    Context "Confirm there are no duplicate function names in private and public folders" {
        It 'Should have no duplicate functions' {
            $functions = Get-ChildItem "$moduleRoot\Public" -Recurse -Include *.ps1 | Select-Object -ExpandProperty BaseName
            $functions += Get-ChildItem "$moduleRoot\Private" -Recurse -Include *.ps1 | Select-Object -ExpandProperty BaseName
            ($functions | Group-Object | Where-Object {$_.Count -gt 1}).Count | Should -BeLessThan 1
        }
    }
}

Describe "Function contents" {
    Context "All non-helper public functions should use Write-Verbose" {
        $scripts = Get-ChildItem "$ModulePath\Public" -Include *.ps1 -Recurse | Where-Object {$_.FullName -notlike "*Helpers*"}

        $testCase = $scripts | Foreach-Object {@{file = $_;Name = $_.BaseName}}         
        It "Function <Name> should contain verbose output" -TestCases $testCase {
            param($file,$Name)

            $file.fullname | Should -FileContentMatch 'Write-Verbose'
        }
    }
}
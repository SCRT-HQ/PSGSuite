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
        $scripts = Get-ChildItem $projectRoot -Include *.ps1,*.psm1,*.psd1 -Recurse

        # TestCases are splatted to the script so we need hashtables
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


    }
}
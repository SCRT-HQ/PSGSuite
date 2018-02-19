$PSVersion = $PSVersionTable.PSVersion.Major
$ModuleName = "PSGSuite"
$projectRoot = Resolve-Path "$PSScriptRoot\.."
$ModulePath = Resolve-Path "$projectRoot\$ModuleName"

# Verbose output for non-master builds on appveyor
# Handy for troubleshooting.
# Splat @Verbose against commands as needed (here or in pester tests)
$Verbose = @{}
if ($ENV:BHBranchName -eq "dev" -or $env:BHCommitMessage -match "!verbose" -or $ENV:TRAVIS_COMMIT_MESSAGE -match "!verbose" -or $ENV:TRAVIS_BRANCH -eq "dev" ) {
    $Verbose.add("Verbose",$True)
}

$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psd1")
Import-Module 'Configuration' -RequiredVersion 1.2.0
Import-Module $ModulePath -Force

Describe "Previous build validation" {
    Context "Failure breadcrumb from previous build" {
        It "Should not exist" {
            "$projectRoot\BuildFailed.txt" | Should -Not -Exist
        }
    }
}

<# Describe "Failure test for PS Core" {
    Context "Test full build failure in PS Core" {
        if ($PSVersion -ge 6) {
            It "Should throw and fail the entire build if PSVersion -ge 6" {
                {throw "PSVersion: $PSVersion"} | Should -Not -Throw
            }
        }
    }
} #>

Describe "Module tests: $ModuleName" {
    if ($ENV:BHBranchName -eq 'master') {
        Context "Confirm private functions are not imported on master branch" {
            {Get-Command -Name New-GoogleService -Module PSGSuite -ErrorAction Stop} | Should -Throw "The term 'New-GoogleService' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and try again."
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
}
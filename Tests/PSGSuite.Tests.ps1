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

Import-Module $ModulePath -Force

Describe "Module tests: $ModuleName" {
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
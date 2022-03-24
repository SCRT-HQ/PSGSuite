$projectRoot = Resolve-Path "$PSScriptRoot\..\.."
$ModulePath = Resolve-Path "$projectRoot\BuildOutput\$($env:BHProjectName)"
$decompiledModulePath = Resolve-Path "$projectRoot\$($env:BHProjectName)"

# Verbose output for non-master builds on appveyor
# Handy for troubleshooting.
# Splat @Verbose against commands as needed (here or in pester tests)
$Verbose = @{}
if ($ENV:BHBranchName -eq "development" -or $env:BHCommitMessage -match "!verbose") {
    $Verbose.add("Verbose",$True)
}

$moduleRoot = Split-Path (Resolve-Path "$ModulePath\*\*.psd1")

Import-Module $ModulePath -Force -Verbose:$false


Describe "Module tests: $($env:BHProjectName)" -Tag 'Module' {
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
    Context "Confirm private functions are not exported on module import" {
        $testCase = Get-ChildItem "$decompiledModulePath\Private" -Recurse -Include *.ps1 | Foreach-Object {@{item = $_.BaseName}}
        It "Should throw when checking for '<item>' in the module commands" -TestCases $testCase {
            param($item)
            {Get-Command -Name $item -Module $env:BHProjectName -ErrorAction Stop} | Should -Throw -ExceptionType ([System.Management.Automation.CommandNotFoundException])
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

Describe "Function contents" -Tag 'Module' {
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

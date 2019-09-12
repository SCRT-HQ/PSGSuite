
if ($ENV:BUILD_BUILDURI -like 'vstfs:*') {
    $projectRoot = Resolve-Path "$PSScriptRoot\..\.."
    $ModulePath = Resolve-Path "$projectRoot\BuildOutput\$($env:BHProjectName)"
    $decompiledModulePath = Resolve-Path "$projectRoot\$($env:BHProjectName)"

    $Verbose = @{}
    if ($ENV:BHBranchName -eq "development" -or $env:BHCommitMessage -match "!verbose") {
        $Verbose.add("Verbose",$True)
    }
    $moduleRoot = Split-Path (Resolve-Path "$ModulePath\*\*.psd1")

    Import-Module $ModulePath -Force -Verbose:$false
    Import-PSGSuiteConfig -Json $env:PSGSuiteConfigJson -Temporary -Verbose

    $u = Get-GSUser
    $u | Select-Object @{N="GivenName";E={$_.Name.GivenName}},OrgUnitPath,Kind

    Send-GmailMessage -From $u.PrimaryEmail -To $u.PrimaryEmail -Subject "Hello from Azure Pipelines + PS Version $($PSVersionTable.PSVersion.ToString())!" -Body "<pre>`n$((Get-ChildItem Env: | Where-Object {$_.Name -match '^(BUILD_|BH).*$'} | Format-Table -AutoSize | Out-String).Trim())`n</pre>" -BodyAsHtml -Verbose
}
<#
Describe "Function contents" -Tag 'Module' {
    Context "Get-GSUser should return a user" {
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
#>

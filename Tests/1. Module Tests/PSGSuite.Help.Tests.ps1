$ModuleName = 'PSGSuite'
$ProjectRoot = Resolve-Path "$PSScriptRoot\..\.." | Select-Object -ExpandProperty Path
$SourceModulePath = Resolve-Path "$ProjectRoot\$ModuleName" | Select-Object -ExpandProperty Path
$TargetModulePath = Get-ChildItem "$ProjectRoot\BuildOutput\$($ModuleName)" | Sort-Object { [Version]$_.Name } | Select-Object -Last 1 -ExpandProperty FullName

Describe "Public Function Help tests" {
    # Adapted from Francois' post here: https://lazywinadmin.com/2016/05/using-pester-to-test-your-comment-based.html
    Import-Module "$TargetModulePath\$($ModuleName).psd1" -Force -ErrorAction SilentlyContinue
    # Make sure the assemblies are present in the current scope otherwise function help will fail
    $dllFolder = [System.IO.Path]::Combine($TargetModulePath,'lib')
    # $dllFolder = if ($PSVersionTable.PSVersion.Major -le 5) {
    #     [System.IO.Path]::Combine($TargetModulePath,'lib','net45')
    # }
    # else {
    #     [System.IO.Path]::Combine($TargetModulePath,'lib','netstandard1.3')
    # }
    Get-ChildItem $dllFolder -Filter '*.dll' -Recurse | ForEach-Object {
        Add-Type -Path $_.FullName -IgnoreWarnings
    }
    $FunctionsList = (Get-Module $ModuleName).ExportedFunctions.Keys
    foreach ($Function in $FunctionsList) {
        $Help = Get-Help -Name $Function -Full
        $AST = [System.Management.Automation.Language.Parser]::ParseInput((Get-Content function:$Function), [ref]$null, [ref]$null)
        Context "$Function - Help" {
            It "Synopsis" {
                $Help.Synopsis | Should -Not -BeNullOrEmpty
            }
            It "Description" {
                $Help.Description | Should -Not -BeNullOrEmpty
            }
            $RiskMitigationParameters = 'Whatif', 'Confirm'
            $HelpParameters = $Help.Parameters.Parameter | Where-Object {$_.Name -notin $RiskMitigationParameters}
            $ASTParameters = $ast.ParamBlock.Parameters.Name.variablepath.userpath
            It "Parameter - Compare Count Help/AST" {
                $HelpParameters.Name.Count -eq $ASTParameters.Count | Should Be $true
            }
            If (-not [String]::IsNullOrEmpty($ASTParameters)) { # IF ASTParameters are found
                $HelpParameters | ForEach-Object {
                    It "Parameter $($_.Name) - Should contain description" {
                        $_.Description | Should -Not -BeNullOrEmpty
                    }
                }

            }
            It "Example - Count should be greater than 0" {
                $Help.Examples.Example.Code.Count | Should -BeGreaterThan 0
            }
            foreach ($Example in $Help.examples.example) {
                it "Example - Remarks on $(($Example.Title -replace '--------------------------').Trim())" {
                    $Example.Remarks | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}

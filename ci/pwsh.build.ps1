<#
.Synopsis
	Build script invoked by Invoke-Build.

.Description
	TODO: Declare build script parameters as usual by param().
	The parameters are specified for Invoke-Build on invoking.
#>

# TODO: [CmdletBinding()] is optional but recommended for strict name checks.
[CmdletBinding()]
param(
)
# PSake makes variables declared here available in other scriptblocks
# Init some things
# TODO: Move some properties to script param() in order to use as parameters.

    # Find the build folder based on build system
    if ($pwd.Path -like "*ci*") {
        Set-Location ..
    }
    $ProjectRoot = $pwd.Path

    $Timestamp = Get-Date -Uformat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"
    $lines = '----------------------------------------------------------------------'

    $Verbose = @{}
    if($ENV:TRAVIS_COMMIT_MESSAGE -match "!verbose")
    {
        $Verbose = @{Verbose = $True}
    }

# TODO: Default task. If it is the first then any name can be used instead.
task Init {
    $lines
    Set-Location $ProjectRoot
    "Build System Details:"
    Get-Item ENV:TRAVIS*
    "`n"
    $lines
    "PSVersionTable"
    $PSVersionTable | Format-List
}

task Build {
    $lines
    "`n`tSTATUS: Testing with PowerShell $PSVersion"

    # Gather test results. Store them in a variable and file
    $TestResults = Invoke-Pester -Path $ProjectRoot\Tests -PassThru -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile"

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if($TestResults.FailedCount -gt 0)
    {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
    "`n"
}

task . Init, Build
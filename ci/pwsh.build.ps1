<#
.Synopsis
	Build script invoked by Invoke-Build.

.Description
	The parameters are specified for Invoke-Build on invoking.
#>
[CmdletBinding()]
param(
)
# PSake makes variables declared here available in other scriptblocks
# Init some things

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

task Init {
    $lines
    Set-Location $ProjectRoot
    "Build System Details:"
    Get-Item ENV:TRAVIS*
    "`n"
    $lines
    "PSVersionTable"
    $PSVersionTable
}

task Build {
    $lines
    "`n`tSTATUS: Testing with PowerShell $PSVersion"

    # Gather test results. Store them in a variable and file
    $TestResults = Invoke-Pester -Path $ProjectRoot\Tests -PassThru -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile"

    # In Appveyor?  Upload our tests! #Abstract this into a function?
    If($env:APPVEYOR)
    {
        (New-Object 'System.Net.WebClient').UploadFile(
            ([Uri]"https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)"),
            (Join-Path $ProjectRoot $TestFile) )
    }

    Remove-Item "$ProjectRoot\$TestFile" -Force -ErrorAction SilentlyContinue

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if($TestResults.FailedCount -gt 0)
    {
        New-Item -Path "$projectRoot\BuildFailed.txt" -Name "BuildFailed.txt" -ItemType File -Force
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
    "`n"
}

task . Init, Build
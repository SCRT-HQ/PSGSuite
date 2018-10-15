# PSake makes variables declared here available in other scriptblocks
# Init some things
Properties {
    # Find the build folder based on build system
    $ProjectRoot = $ENV:BHProjectPath
    if (-not $ProjectRoot) {
        if ($pwd.Path -like "*ci*") {
            Set-Location ..
        }
        $ProjectRoot = $pwd.Path
    }
    $sut = $env:BHModulePath
    $tests = "$projectRoot\Tests"
    $Timestamp = Get-Date -Uformat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"
    $lines = '----------------------------------------------------------------------'
    $outputDir = Join-Path -Path $projectRoot -ChildPath 'out'
    $outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
    $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
    $outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion
    $pathSeperator = [IO.Path]::PathSeparator
    $Verbose = @{}
    if ($ENV:BHCommitMessage -match "!verbose") {
        $Verbose = @{Verbose = $True}
    }
}

#Task Default -Depends Init,Test,Build,Deploy
task default -depends Test

task Init {
    "`nSTATUS: Testing with PowerShell $psVersion"
    "Build System Details:"
    Get-Item ENV:BH*
    "`n"
    Set-Location $ProjectRoot

    'Configuration', 'PSDeploy', 'Pester' | Foreach-Object {
        if (-not (Get-Module -Name $_ -ListAvailable -Verbose:$false -ErrorAction SilentlyContinue)) {
            Install-Module -Name $_ -Repository PSGallery -Scope CurrentUser -AllowClobber -SkipPublisherCheck -Confirm:$false -ErrorAction Stop
        }
        elseif ($_ -eq 'Pester') {
            Install-Module -Name $_ -Repository PSGallery -Scope CurrentUser -AllowClobber -SkipPublisherCheck -Confirm:$false -ErrorAction Stop -Force
        }
        Import-Module -Name $_ -Verbose:$false -Force -ErrorAction Stop
    }
} -description 'Initialize build environment'

task Test -Depends Init, Compile, Pester -description 'Run test suite'

task Clean -depends Init {
    Remove-Module -Name $env:BHProjectName -Force -ErrorAction SilentlyContinue

    if (Test-Path -Path $outputDir) {
        Get-ChildItem -Path $outputDir -Recurse -File | Where-Object {$_.BaseName -eq $env:BHProjectName} | Remove-Item -Force -Recurse
    } else {
        New-Item -Path $outputDir -ItemType Directory > $null
    }
    "    Cleaned previous output directory [$outputDir]"
} -description 'Cleans module output directory'

task Compile -depends Clean {
    # Create module output directory
    $functionsToExport = @('Get-GSToken','New-GoogleService')
    $aliasesToExport = (. $sut\Aliases\PSGSuite.Aliases.ps1).Keys
    $modDir = New-Item -Path $outputModDir -ItemType Directory -ErrorAction SilentlyContinue
    New-Item -Path $outputModVerDir -ItemType Directory -ErrorAction SilentlyContinue > $null

    # Append items to psm1
    Write-Verbose -Message 'Creating psm1...'
    $psm1 = Copy-Item -Path (Join-Path -Path $sut -ChildPath 'PSGSuite.psm1') -Destination (Join-Path -Path $outputModVerDir -ChildPath "$($ENV:BHProjectName).psm1") -PassThru

    Get-ChildItem -Path (Join-Path -Path $sut -ChildPath 'Private') -Recurse -File | ForEach-Object {
        "$(Get-Content $_.FullName -Raw)`n" | Add-Content -Path $psm1 -Encoding UTF8
    }
    "if (`$env:EnablePSGSuiteDebug) {Export-ModuleMember -Function @('Get-GSToken','New-GoogleService')}`n" | Add-Content -Path $psm1 -Encoding UTF8
    Get-ChildItem -Path (Join-Path -Path $sut -ChildPath 'Public') -Recurse -File | ForEach-Object {
        "$(Get-Content $_.FullName -Raw)`nExport-ModuleMember -Function '$($_.BaseName)'`n" | Add-Content -Path $psm1 -Encoding UTF8
        $functionsToExport += $_.BaseName
    }

    New-Item -Path "$outputModVerDir\lib" -ItemType Directory -ErrorAction SilentlyContinue > $null
    Copy-Item -Path "$sut\lib\*" -Destination "$outputModVerDir\lib" -Recurse -ErrorAction SilentlyContinue
    $aliasHashContents = (Get-Content "$sut\Aliases\PSGSuite.Aliases.ps1" -Raw).Trim()

    # Set remainder of PSM1 contents
    @"

Import-GoogleSDK

`$aliasHash = $aliasHashContents

foreach (`$key in `$aliasHash.Keys) {
    try {
        New-Alias -Name `$key -Value `$aliasHash[`$key] -Force
    }
    catch {
        Write-Error "[ALIAS: `$(`$key)] `$(`$_.Exception.Message.ToString())"
    }
}

Export-ModuleMember -Alias '*'

if (!(Test-Path (Join-Path "~" ".scrthq"))) {
    New-Item -Path (Join-Path "~" ".scrthq") -ItemType Directory -Force | Out-Null
}

if (`$PSVersionTable.ContainsKey('PSEdition') -and `$PSVersionTable.PSEdition -eq 'Core' -and !`$EncryptionKey -and !`$IsWindows) {
    if (!(Test-Path (Join-Path (Join-Path "~" ".scrthq") "BlockCoreCLREncryptionWarning.txt"))) {
        Write-Warning "CoreCLR does not support DPAPI encryption! Setting a basic AES key to prevent errors. Please create a unique key as soon as possible as this will only obfuscate secrets from plain text in the Configuration, the key is not secure as is. If you would like to prevent this message from displaying in the future, run the following command:`n`nBlock-CoreCLREncryptionWarning`n"
    }
    `$EncryptionKey = [Byte[]]@(1..16)
    `$ConfigScope = "User"
}

if (`$EncryptionKey -is [System.Security.SecureString]) {
    `$Method = "SecureString"
    if (!`$ConfigScope) {
        `$ConfigScope = "Machine"
    }
}
elseif (`$EncryptionKey -is [System.Byte[]]) {
    `$Method = "AES Key"
    if (!`$ConfigScope) {
        `$ConfigScope = "Machine"
    }
}
else {
    `$Method = "DPAPI"
    `$ConfigScope = "User"
}

Add-MetadataConverter -Converters @{
    [SecureString] = {
        `$encParams = @{}
        if (`$script:EncryptionKey -is [System.Byte[]]) {
            `$encParams["Key"] = `$script:EncryptionKey
        }
        elseif (`$script:EncryptionKey -is [System.Security.SecureString]) {
            `$encParams["SecureKey"] = `$script:EncryptionKey
        }
        'Secure "{0}"' -f (ConvertFrom-SecureString `$_ @encParams)
    }
    "Secure" = {
        param([string]`$String)
        `$encParams = @{}
        if (`$script:EncryptionKey -is [System.Byte[]]) {
            `$encParams["Key"] = `$script:EncryptionKey
        }
        elseif (`$script:EncryptionKey -is [System.Security.SecureString]) {
            `$encParams["SecureKey"] = `$script:EncryptionKey
        }
        ConvertTo-SecureString `$String @encParams
    }
}
try {
    `$confParams = @{
        Scope = `$ConfigScope
    }
    if (`$ConfigName) {
        `$confParams["ConfigName"] = `$ConfigName
        `$Script:ConfigName = `$ConfigName
    }
    try {
        Get-PSGSuiteConfig @confParams -ErrorAction Stop
    }
    catch {
        if (Test-Path "`$ModuleRoot\`$env:USERNAME-`$env:COMPUTERNAME-`$env:PSGSuiteDefaultDomain-PSGSuite.xml") {
            Get-PSGSuiteConfig -Path "`$ModuleRoot\`$env:USERNAME-`$env:COMPUTERNAME-`$env:PSGSuiteDefaultDomain-PSGSuite.xml" -ErrorAction Stop
            Write-Warning "No Configuration.psd1 found at scope '`$ConfigScope'; falling back to legacy XML. If you would like to convert your legacy XML to the newer Configuration.psd1, run the following command:`n`nGet-PSGSuiteConfig -Path '`$ModuleRoot\`$env:USERNAME-`$env:COMPUTERNAME-`$env:PSGSuiteDefaultDomain-PSGSuite.xml' -PassThru | Set-PSGSuiteConfig`n"
        }
        else {
            Write-Warning "There was no config returned! Please make sure you are using the correct key or have a configuration already saved."
        }
    }
}
catch {
    Write-Warning "There was no config returned! Please make sure you are using the correct key or have a configuration already saved."
}

"@ | Add-Content -Path $psm1 -Encoding UTF8

    # Copy over manifest
    Copy-Item -Path $env:BHPSModuleManifest -Destination $outputModVerDir

    # Update FunctionsToExport on manifest
    Update-ModuleManifest -Path (Join-Path $outputModVerDir "$($env:BHProjectName).psd1") -FunctionsToExport ($functionsToExport | Sort-Object) -AliasesToExport ($aliasesToExport | Sort-Object)

    if ((Get-Item (Join-Path $outputModVerDir "$($env:BHProjectName).psd1")).BaseName -cne $env:BHProjectName) {
        Rename-Item (Join-Path $outputModVerDir "$($env:BHProjectName).psd1") -NewName "$($env:BHProjectName).psd1" -Force
    }
    "    Created compiled module at [$outputModDir]"
    "    Output version directory contents"
    Get-ChildItem $outputModVerDir
} -description 'Compiles module from source'

task Pester -Depends Compile {
    Push-Location
    Set-Location -PassThru $outputModDir
    if(-not $ENV:BHProjectPath) {
        Set-BuildEnvironment -Path $PSScriptRoot\..
    }

    $origModulePath = $env:PSModulePath
    if ( $env:PSModulePath.split($pathSeperator) -notcontains $outputDir ) {
        $env:PSModulePath = ($outputDir + $pathSeperator + $origModulePath)
    }

    Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue -Verbose:$false
    Import-Module -Name $outputModDir -Force -Verbose:$false
    $testResultsXml = Join-Path -Path $outputDir -ChildPath $TestFile
    $testResults = Invoke-Pester -Path $tests -PassThru -OutputFile $testResultsXml -OutputFormat NUnitXml

    # Upload test artifacts to AppVeyor
    If ($ENV:APPVEYOR) {
        (New-Object 'System.Net.WebClient').UploadFile(
            ([Uri]"https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)"),
            $testResultsXml
        )
    }
    Remove-Item $testResultsXml -Force -ErrorAction SilentlyContinue

    if ($testResults.FailedCount -gt 0) {
        $testResults | Format-List
        Write-Error -Message 'One or more Pester tests failed. Build cannot continue!'
    }
    Pop-Location
    $env:PSModulePath = $origModulePath
} -description 'Run Pester tests'

Task Deploy -Depends Pester {
    if ($ENV:BHBuildSystem -eq 'AppVeyor' -and $env:BHCommitMessage -match '!deploy' -and $env:BHBranchName -eq "master") {
        # Load the module, read the exported functions, update the psd1 FunctionsToExport
        $commParsed = $env:BHCommitMessage | Select-String -Pattern '\sv\d\.\d\.\d\s'
        if ($commParsed) {
            $commitVer = $commParsed.Matches.Value.Trim().Replace('v','')
        }
        $curVer = (Get-Module $env:BHProjectName).Version
        $nextGalVer = Get-NextNugetPackageVersion -Name $env:BHProjectName -PackageSourceUrl 'https://www.powershellgallery.com/api/v2/'

        $versionToDeploy = if ($commitVer -and ([System.Version]$commitVer -lt $nextGalVer)) {
            Write-Host -ForegroundColor Yellow "Version in commit message is $commitVer, which is less than the next Gallery version and would result in an error. Possible duplicate deployment build, skipping module bump and negating deployment"
            $env:BHCommitMessage = $env:BHCommitMessage.Replace('!deploy','')
            $null
        }
        elseif ($commitVer -and ([System.Version]$commitVer -gt $nextGalVer)) {
            Write-Host -ForegroundColor Green "Module version to deploy: $commitVer [from commit message]"
            [System.Version]$commitVer
        }
        elseif ($curVer -ge $nextGalVer) {
            Write-Host -ForegroundColor Green "Module version to deploy: $curVer [from manifest]"
            $curVer
        }
        elseif ($env:BHCommitMessage -match '!hotfix') {
            Write-Host -ForegroundColor Green "Module version to deploy: $nextGalVer [commit message match '!hotfix']"
            $nextGalVer
        }
        elseif ($env:BHCommitMessage -match '!minor') {
            $minorVers = [System.Version]("{0}.{1}.{2}" -f $nextGalVer.Major,([int]$nextGalVer.Minor + 1),0)
            Write-Host -ForegroundColor Green "Module version to deploy: $minorVers [commit message match '!minor']"
            $minorVers
        }
        elseif ($env:BHCommitMessage -match '!major') {
            $majorVers = [System.Version]("{0}.{1}.{2}" -f ([int]$nextGalVer.Major + 1),0,0)
            Write-Host -ForegroundColor Green "Module version to deploy: $majorVers [commit message match '!major']"
            $majorVers
        }
        else {
            Write-Host -ForegroundColor Green "Module version to deploy: $nextGalVer [PSGallery next version]"
            $nextGalVer
        }
        # Bump the module version
        if ($versionToDeploy) {
            Update-Metadata -Path (Join-Path $outputModVerDir "$($env:BHProjectName).psd1") -PropertyName ModuleVersion -Value $versionToDeploy
            "    Publishing version [$($versionToDeploy)] to PSGallery..."
            Publish-Module -Path $outputModVerDir -NuGetApiKey $env:NugetApiKey -Repository PSGallery
        }
        else {
            Write-Host -ForegroundColor Yellow "No module version matched! Negating deployment to prevent errors"
            $env:BHCommitMessage = $env:BHCommitMessage.Replace('!deploy','')
        }
        $lines

    }
    else {
        Write-Host -ForegroundColor Magenta "Build system is not AppVeyor, commit message does not contain '!deploy' and/or branch is not 'master' -- skipping module update!"
    }

    $lines

    <# $Params = @{
        Path    = $ProjectRoot
        Force   = $true
        Recurse = $false
    }
    Invoke-PSDeploy @Verbose @Params #>
} -description 'Deploy module to PSGallery'

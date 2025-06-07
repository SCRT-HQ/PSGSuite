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
    $moduleName = "PSGSuite"
    $sut = $env:BHModulePath
    $tests = "$projectRoot\Tests"
    $Timestamp = Get-Date -UFormat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.ToString()
    $TestFile = "TestResults.xml"
    $lines = '----------------------------------------------------------------------'
    $outputDir = $env:BHBuildOutput
    $outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
    $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
    $outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion
    $pathSeperator = [IO.Path]::PathSeparator
    $NuGetSearchStrings = @(
        "Google.Apis*"
    )
    $Verbose = @{}
    if ($ENV:BHCommitMessage -match "!verbose") {
        $Verbose = @{Verbose = $True }
    }
}

. ([System.IO.Path]::Combine($PSScriptRoot, "ci", "AzurePipelinesHelpers.ps1"))

Set-BuildVariables

FormatTaskName (Get-PsakeTaskSectionFormatter)

#Task Default -Depends Init,Test,Build,Deploy
Task default -Depends Test

Task Skip {
    "    Skipping psake for this job!"
}

Task Init {
    Set-Location $ProjectRoot
    Write-BuildLog "Build System Details:"
    Write-BuildLog "$((Get-ChildItem Env: | Where-Object {$_.Name -match "^(BUILD_|SYSTEM_|BH)"} | Sort-Object Name | Format-Table Name,Value -AutoSize | Out-String).Trim())"
    if ($env:BHProjectName -cne $moduleName) {
        $env:BHProjectName = $moduleName
    }

    'Configuration' | ForEach-Object {
        Install-Module -Name $_ -Repository PSGallery -Scope CurrentUser -AllowClobber -SkipPublisherCheck -Confirm:$false -ErrorAction Stop -Force
        Import-Module -Name $_ -Verbose:$false -ErrorAction Stop -Force
    }
} -Description 'Initialize build environment'

Task Clean -Depends Init {
    $zipPath = [System.IO.Path]::Combine($PSScriptRoot, "$($env:BHProjectName).zip")
    if (Test-Path $zipPath) {
        Remove-Item $zipPath -Force
    }
    Remove-Module -Name $env:BHProjectName -Force -ErrorAction SilentlyContinue

    if (Test-Path -Path $outputDir) {
        if ("$env:NoNugetRestore" -eq 'True') {
            Write-BuildLog "Skipping DLL clean due to `$env:NoNugetRestore = $env:NoNugetRestore"
            Get-ChildItem -Path $outputDir -Recurse -File | Where-Object { $_.FullName -notlike "$outputModVerDir\lib*" } | Sort-Object { $_.FullName.Length } -Descending | ForEach-Object {
                try {
                    Remove-Item $_.FullName -Force -Recurse
                }
                catch {
                    Write-Warning "Unable to delete: '$($_.FullName)'"
                }
            }
        }
        else {
            Remove-Item $outputDir -Recurse -Force
        }
    }
    if (-not (Test-Path $outputDir)) {
        New-Item -Path $outputDir -ItemType Directory | Out-Null
    }
    "    Cleaned previous output directory [$outputDir]"
} -Description 'Cleans module output directory'


Task Download -Depends Clean {
    if ("$env:NoNugetRestore" -ne 'True') {
        New-Item -Path "$outputModVerDir\lib" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
        Write-BuildLog "Installing NuGet dependencies..."
        Install-NuGetDependencies -Destination $outputModVerDir -AddlSearchString $NuGetSearchStrings -Verbose
    }
    else {
        Write-BuildLog "Skipping NuGet Restore due to `$env:NoNugetRestore = '$env:NoNugetRestore'"
    }
} -Description 'Downloads module third-party dependencies'

Task Generate -Depends Clean, Download {
    # Load the Google SDKs for use during dynamic content generation
    Write-BuildLog "Importing the Google SDK"
    . (Join-Path $Sut 'Private\Import-GoogleSDK.ps1')
    Import-GoogleSDK -Lib (Join-Path $outputModVerDir 'lib')

    # Dynamically generate module content by executing all .ps1 files in the template folder.
    # Each template is expected to output a string value that will be saved in the corresponding file in the source folder.
    # Child scope is used to minimise interference and pollution of build variables.
    $TemplatesPath = Join-Path $PSScriptRoot "ci" "templates"
    $SourceDirectory = $Sut

    $DefaultPriority = 5
    $TemplatePriorities = @{
        1 = @()
        2 = @()
        3 = @()
        4 = @()
        5 = @()
        6 = @()
        7 = @()
        8 = @()
        9 = @()
    }
    Get-ChildItem -Path $TemplatesPath -Filter "*.ps1" -Recurse -File | ForEach-Object {
        If ($_.Name -match "^(?<priority>[1-9])-"){
            $TemplatePriorities[[int]$Matches.priority] += $_
        } else {
            $TemplatePriorities[$DefaultPriority] += $_
        }
    }

    $ExecutionOrder = @()
    ForEach ($Priority in @(1..9)){
        $TemplatePriorities[$Priority] = $TemplatePriorities[$Priority] | Sort-Object
        $TemplatePriorities[$Priority] | ForEach-Object {
            $ExecutionOrder += $_
        }
    }
    
    $ExecutionOrder | ForEach-Object {
        
        $RelativeTemplatePath = $_.FullName.Substring($TemplatesPath.Length + 1)
        $RelativeDirectory = $_.DirectoryName.Substring($TemplatesPath.Length)
        If ($RelativeDirectory -match '^[\\/]'){
            $RelativeDirectory = $RelativeDirectory.Substring(1)
        }
        
        Write-BuildLog "Executing template: $RelativeTemplatePath"
        $TemplateResult = & $_.FullName -SourceDirectory $PSScriptRoot
        
        If ($TemplateResult){
            
            $OutputDirectory = Join-Path $SourceDirectory $RelativeDirectory
            
            If ($TemplateResult -is [hashtable]){
                
                ForEach ($key in $TemplateResult.keys){
                    
                    If ($Key -match '^[\\/]'){
                        $OutputPath = Join-Path $SourceDirectory $Key
                    } else {
                        $OutputPath = Join-Path $OutputDirectory $(Split-Path $Key -Leaf)
                    }

                    if (-not (Test-Path (Split-Path $OutputPath -Parent))){
                        New-Item -Path (Split-Path $OutputPath -Parent) -ItemType Directory -Force | Out-Null
                    }

                    $OutputValue = $TemplateResult[$Key]
                    @"
# Programmatically generated from template '$RelativeTemplatePath'
# This file will be overwritten during the module build process.

$OutputValue
"@ | Out-File -Path $OutputPath -Encoding UTF8 -Force
                    Write-BuildLog "Template output written to: $OutputPath"

                }

            } else {
                If ($_.Name -Match "^[1-9]-"){
                    $OutputPath = Join-Path $OutputDirectory $_.Name.Substring(2)
                } else {
                    $OutputPath = Join-Path $OutputDirectory $_.Name
                }

                if (-not (Test-Path (Split-Path $OutputPath -Parent))){
                    New-Item -Path (Split-Path $OutputPath -Parent) -ItemType Directory -Force | Out-Null
                }
                
                @"
# Programmatically generated from template '$RelativeTemplatePath'
# This file will be overwritten during the module build process.

$TemplateResult
"@ | Out-File -Path $OutputPath -Encoding UTF8 -Force
                Write-BuildLog "Template output written to: $OutputPath"

            }
            
        } else {
            Write-BuildLog "Template did not output any content" -Severe
        }

    Write-BuildLog "Completed template: $RelativeTemplatePath"
    }
} -Description "Generates module content from template files"

Task Compile -Depends Clean, Download, Generate {
    # Create module output directory
    $functionsToExport = @()
    $aliasesToExport = (. $sut\Aliases\PSGSuite.Aliases.ps1).Keys
    if (-not (Test-Path $outputModVerDir)) {
        $modDir = New-Item -Path $outputModDir -ItemType Directory -ErrorAction SilentlyContinue
        New-Item -Path $outputModVerDir -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    }

    # Append items to psm1
    Write-BuildLog 'Creating psm1...'
    $psm1 = Copy-Item -Path (Join-Path -Path $sut -ChildPath 'PSGSuite.psm1') -Destination (Join-Path -Path $outputModVerDir -ChildPath "$($ENV:BHProjectName).psm1") -PassThru

    foreach ($scope in @('Class', 'Private', 'Public', 'Module')) {
        Write-BuildLog "Copying contents from files in source folder to PSM1: $($scope)"
        $gciPath = Join-Path $sut $scope
        if (Test-Path $gciPath) {
            Get-ChildItem -Path $gciPath -Filter "*.ps1" -Recurse -File | ForEach-Object {
                Write-BuildLog "Working on: $scope$([System.IO.Path]::DirectorySeparatorChar)$($_.FullName.Replace("$gciPath$([System.IO.Path]::DirectorySeparatorChar)",'') -replace '\.ps1$')"
                [System.IO.File]::AppendAllText($psm1, ("$([System.IO.File]::ReadAllText($_.FullName))`n"))
                if ($scope -eq 'Public') {
                    $functionsToExport += $_.BaseName
                    [System.IO.File]::AppendAllText($psm1, ("Export-ModuleMember -Function '$($_.BaseName)'`n"))
                }
            }
        }
    }

    Invoke-CommandWithLog { Remove-Module $env:BHProjectName -ErrorAction SilentlyContinue -Force -Verbose:$false }

    # Copy over manifest
    Copy-Item -Path $env:BHPSModuleManifest -Destination $outputModVerDir

    # Update FunctionsToExport on manifest
    Update-ModuleManifest -Path (Join-Path $outputModVerDir "$($env:BHProjectName).psd1") -FunctionsToExport ($functionsToExport | Sort-Object) -AliasesToExport ($aliasesToExport | Sort-Object)

    if ((Get-ChildItem $outputModVerDir | Where-Object { $_.Name -eq "$($env:BHProjectName).psd1" }).BaseName -cne $env:BHProjectName) {
        "    Renaming manifest to correct casing"
        Rename-Item (Join-Path $outputModVerDir "$($env:BHProjectName).psd1") -NewName "$($env:BHProjectName).psd1" -Force
    }
    "    Created compiled module at [$outputModDir]"
    "    Output version directory contents"
    Get-ChildItem $outputModVerDir | Format-Table -AutoSize
} -Description 'Compiles module from source'

Task Docs -Depends Init {
    'platyPS', 'PSGSuite' | ForEach-Object {
        "    Installing $_ if missing"
        $_ | Resolve-Module -Verbose
        Import-Module $_
    }
    $docPath = Join-Path $PSScriptRoot 'docs'
    $funcPath = Join-Path $docPath 'Function Help'
    $docStage = Join-Path $PSScriptRoot 'docstage'
    $sitePath = Join-Path $PSScriptRoot 'site'

    "    Setting index.md content from README"
    Get-Content (Join-Path $PSScriptRoot 'README.md') -Raw | Set-Content (Join-Path $docPath 'index.md') -Force
    if (-not (Test-Path $docPath)) {
        "    Creating Doc Path: $docPath"
        New-Item $docPath -ItemType Directory -Force | Out-Null
    }
    if (-not (Test-Path $sitePath)) {
        "    Creating Site Path: $sitePath"
        New-Item $sitePath -ItemType Directory -Force | Out-Null
    }
    if (Test-Path $docstage) {
        "    Clearing out Doc Stage Path: $docstage"
        Remove-Item $docstage -Recurse -Force
    }
    "    Creating a fresh Doc Stage folder: $docstage"
    New-Item $docstage -ItemType Directory -Force | Out-Null

    New-MarkdownHelp -Module PSGSuite -NoMetadata -OutputFolder $docstage -Force -AlphabeticParamsOrder -ExcludeDontShow -Verbose | Out-Null

    $env:PSModulePath = $origPSModulePath

    $stagesDocs = Get-ChildItem $docstage -Recurse -Filter "*.md"
    foreach ($folder in (Get-ChildItem (Join-Path -Path $sut -ChildPath 'Public') -Directory)) {
        $docFolder = Join-Path $funcPath $folder.BaseName
        if (-not (Test-Path $docFolder)) {
            "    Creating Doc Folder: $docFolder"
            New-Item $docFolder -ItemType Directory -Force | Out-Null
        }
        else {
            "    Cleaning up existing Doc Folder"
            Get-ChildItem $docFolder -Recurse | Remove-Item -Recurse -Force
        }
        foreach ($func in (Get-ChildItem $folder.FullName -Recurse -Filter "*.ps1")) {
            if ($doc = $stagesDocs | Where-Object { $_.BaseName -eq $func.BaseName }) {
                "    Moving function doc '$($func.BaseName)' to doc folder: $docFolder"
                Move-Item $doc.FullName -Destination $docFolder -Force | Out-Null
            }
        }
    }
    Set-Location $PSScriptRoot
    if ($null -eq (python -m mkdocs --version)) {
        python -m pip install --user wheel
        python -m pip install --user mkdocs
        python -m pip install --user mkdocs-material
        python -m pip install --user mkdocs-minify-plugin
        python -m pip install --user pymdown-extensions
    }
    python -m mkdocs gh-deploy --message "[skip ci] Deploying Docs update @ $(Get-Date) to https://psgsuite.io" --verbose --force --ignore-version | Tee-Object -Variable mkdocs
    if ($errors = ($mkdocs -split "`n") | Where-Object { $_ -match 'Error\s+\-\s+' }) {
        Write-BuildError ($errors -join "`n")
    }
}

Task Import -Depends Compile {
    '    Testing import of compiled module'
    Import-Module (Join-Path $outputModVerDir "$($env:BHProjectName).psd1")
} -Description 'Imports the newly compiled module'

$pesterScriptBlock = {
    $dependencies = @(
        @{
            Name           = 'Pester'
            MinimumVersion = '4.10.1'
            MaximumVersion = '4.99.99'
        }
    )
    foreach ($module in $dependencies) {
        Write-BuildLog "[$($module.Name)] Resolving"
        try {
            if ($imported = Get-Module $($module.Name)) {
                Write-BuildLog "[$($module.Name)] Removing imported module"
                $imported | Remove-Module
            }
            Import-Module @module
        }
        catch {
            Write-BuildLog "[$($module.Name)] Installing missing module"
            Install-Module @module -Repository PSGallery -Force -SkipPublisherCheck
            Import-Module @module
        }
    }
    Push-Location
    Set-Location -PassThru $outputModDir
    if (-not $ENV:BHProjectPath) {
        Set-BuildEnvironment -Path $PSScriptRoot\..
    }

    $origModulePath = $env:PSModulePath
    if ( $env:PSModulePath.split($pathSeperator) -notcontains $outputDir ) {
        $env:PSModulePath = ($outputDir + $pathSeperator + $origModulePath)
    }

    Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue -Verbose:$false
    Import-Module -Name $outputModDir -Force -Verbose:$false
    $testResultsXml = Join-Path -Path $outputDir -ChildPath $TestFile
    $pesterParams = @{
        OutputFormat = 'NUnitXml'
        OutputFile   = $testResultsXml
        PassThru     = $true
        Path         = $tests
    }
    if ($PSVersionTable.PSVersion.Major -lt 6) {
        ### $pesterParams['CodeCoverage'] = (Join-Path $outputModVerDir "$($env:BHProjectName).psm1")
    }
    if ($global:ExcludeTag) {
        $pesterParams['ExcludeTag'] = $global:ExcludeTag
        "    Invoking Pester and excluding tag(s) [$($global:ExcludeTag -join ', ')]..."
    }
    else {
        '    Invoking Pester...'
    }
    $testResults = Invoke-Pester @pesterParams
    '    Pester invocation complete!'
    if ($testResults.FailedCount -gt 0) {
        $testResults.TestResult | Where-Object { -not $_.Passed } | Format-List
        Write-BuildError -Message 'One or more Pester tests failed. Build cannot continue!'
    }
    Pop-Location
    $env:PSModulePath = $origModulePath
}

Task Full -Depends Compile $pesterScriptBlock -Description 'Run Pester tests'

Task Test -Depends Init $pesterScriptBlock -Description 'Run Pester tests only [no module compilation]'

$deployScriptBlock = {
    function Publish-GitHubRelease {
        <#
            .SYNOPSIS
            Publishes a release to GitHub Releases. Borrowed from https://www.herebedragons.io/powershell-create-github-release-with-artifact
        #>
        [CmdletBinding()]
        Param (
            [parameter(Mandatory = $true)]
            [String]
            $VersionNumber,
            [parameter(Mandatory = $false)]
            [String]
            $CommitId = 'main',
            [parameter(Mandatory = $true)]
            [String]
            $ReleaseNotes,
            [parameter(Mandatory = $true)]
            [ValidateScript( { Test-Path $_ })]
            [String]
            $ArtifactPath,
            [parameter(Mandatory = $true)]
            [String]
            $GitHubUsername,
            [parameter(Mandatory = $true)]
            [String]
            $GitHubRepository,
            [parameter(Mandatory = $true)]
            [String]
            $GitHubApiKey,
            [parameter(Mandatory = $false)]
            [Switch]
            $PreRelease,
            [parameter(Mandatory = $false)]
            [Switch]
            $Draft
        )
        $releaseData = @{
            tag_name         = [string]::Format("v{0}", $VersionNumber)
            target_commitish = $CommitId
            name             = [string]::Format("$($env:BHProjectName) v{0}", $VersionNumber)
            body             = $ReleaseNotes
            draft            = [bool]$Draft
            prerelease       = [bool]$PreRelease
        }

        $auth = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($gitHubApiKey + ":x-oauth-basic"))

        $releaseParams = @{
            Uri         = "https://api.github.com/repos/$GitHubUsername/$GitHubRepository/releases"
            Method      = 'POST'
            Headers     = @{
                Authorization = $auth
            }
            ContentType = 'application/json'
            Body        = (ConvertTo-Json $releaseData -Compress)
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $result = Invoke-RestMethod @releaseParams
        $uploadUri = $result | Select-Object -ExpandProperty upload_url
        $uploadUri = $uploadUri -creplace '\{\?name,label\}'
        $artifact = Get-Item $ArtifactPath
        $uploadUri = $uploadUri + "?name=$($artifact.Name)"
        $uploadFile = $artifact.FullName

        $uploadParams = @{
            Uri         = $uploadUri
            Method      = 'POST'
            Headers     = @{
                Authorization = $auth
            }
            ContentType = 'application/zip'
            InFile      = $uploadFile
        }
        $result = Invoke-RestMethod @uploadParams
    }
    # if ($null -eq (Get-Module PoshTwit -ListAvailable)) {
    #     "    Installing PoshTwit module..."
    #     Install-Module PoshTwit -Scope CurrentUser
    # }
    # Import-Module PoshTwit -Verbose:$false
    # Load the module, read the exported functions, update the psd1 FunctionsToExport
    $commParsed = $env:BHCommitMessage | Select-String -Pattern '\sv\d+\.\d+\.\d+\s'
    if ($commParsed) {
        $commitVer = $commParsed.Matches.Value.Trim().Replace('v', '')
    }
    $curVer = (Get-Module $env:BHProjectName).Version
    $galVer = (Find-Module $env:BHProjectName -Repository PSGallery).Version.ToString()
    $galVerSplit = $galVer.Split('.')
    $nextGalVer = [System.Version](($galVerSplit[0..($galVerSplit.Count - 2)] -join '.') + '.' + ([int]$galVerSplit[-1] + 1))

    $versionToDeploy = if ($commitVer -and ([System.Version]$commitVer -lt $nextGalVer)) {
        Write-Host -ForegroundColor Yellow "Version in commit message is $commitVer, which is less than the next Gallery version and would result in an error. Possible duplicate deployment build, skipping module bump and negating deployment"
        $env:BHCommitMessage = $env:BHCommitMessage.Replace('!deploy', '')
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
        $minorVers = [System.Version]("{0}.{1}.{2}" -f $nextGalVer.Major, ([int]$nextGalVer.Minor + 1), 0)
        Write-Host -ForegroundColor Green "Module version to deploy: $minorVers [commit message match '!minor']"
        $minorVers
    }
    elseif ($env:BHCommitMessage -match '!major') {
        $majorVers = [System.Version]("{0}.{1}.{2}" -f ([int]$nextGalVer.Major + 1), 0, 0)
        Write-Host -ForegroundColor Green "Module version to deploy: $majorVers [commit message match '!major']"
        $majorVers
    }
    else {
        Write-Host -ForegroundColor Green "Module version to deploy: $nextGalVer [PSGallery next version]"
        $nextGalVer
    }
    # Bump the module version
    if ($versionToDeploy) {
        try {
            if (-not [String]::IsNullOrEmpty($env:NugetApiKey)) {
                "    Publishing version [$($versionToDeploy)] to PSGallery..."
                Update-Metadata -Path (Join-Path $outputModVerDir "$($env:BHProjectName).psd1") -PropertyName ModuleVersion -Value $versionToDeploy
                Publish-Module -Path $outputModVerDir -NuGetApiKey $env:NugetApiKey -Repository PSGallery
                "    Deployment successful!"
            }
            else {
                "    [SKIPPED] Deployment of version [$($versionToDeploy)] to PSGallery"
            }
            $commitId = git rev-parse --verify HEAD
            # if ($ENV:BHBuildSystem -eq 'VSTS' -and -not [String]::IsNullOrEmpty($env:TwitterAccessSecret) -and -not [String]::IsNullOrEmpty($env:TwitterAccessToken) -and -not [String]::IsNullOrEmpty($env:TwitterConsumerKey) -and -not [String]::IsNullOrEmpty($env:TwitterConsumerSecret)) {
            #     "    Publishing tweet about new release..."
            #     $manifest = Import-PowerShellDataFile -Path (Join-Path $outputModVerDir "$($env:BHProjectName).psd1")
            #     $text = "#$($env:BHProjectName) v$($versionToDeploy) is now available on the #PSGallery! https://www.powershellgallery.com/packages/$($env:BHProjectName)/$($versionToDeploy) #PowerShell"
            #     $manifest.PrivateData.PSData.Tags | Foreach-Object {
            #         $text += " #$($_)"
            #     }
            #     if ($text.Length -gt 280) {
            #         "    Trimming [$($text.Length - 280)] extra characters from tweet text to get to 280 character limit..."
            #         $text = $text.Substring(0,280)
            #     }
            #     "    Tweet text: $text"
            #     Publish-Tweet -Tweet $text -ConsumerKey $env:TwitterConsumerKey -ConsumerSecret $env:TwitterConsumerSecret -AccessToken $env:TwitterAccessToken -AccessSecret $env:TwitterAccessSecret
            #     "    Tweet successful!"
            # }
            # else {
            #     "    [SKIPPED] Twitter update of new release"
            # }
            if (-not [String]::IsNullOrEmpty($env:GitHubPAT)) {
                "    Creating Release ZIP..."
                $zipPath = [System.IO.Path]::Combine($PSScriptRoot, "$($env:BHProjectName).zip")
                if (Test-Path $zipPath) {
                    Remove-Item $zipPath -Force
                }
                Add-Type -Assembly System.IO.Compression.FileSystem
                [System.IO.Compression.ZipFile]::CreateFromDirectory($outputModDir, $zipPath)
                "    Publishing Release v$($versionToDeploy) @ commit Id [$($commitId)] to GitHub..."
                $ReleaseNotes = "# Changelog`n`n"
                $ReleaseNotes += (git log -1 --pretty=%B | Select-Object -Skip 2) -join "`n"
                $ReleaseNotes += "`n`n***`n`n# Instructions`n`n"
                $ReleaseNotes += @"
**IMPORTANT: You MUST have the module '[Configuration](https://github.com/poshcode/Configuration)' installed as a prerequisite! Installing the module from the repo source or the release page does not automatically install dependencies!!**

1. [Click here](https://github.com/scrthq/$($env:BHProjectName)/releases/download/v$($versionToDeploy.ToString())/$($env:BHProjectName).zip) to download the *$($env:BHProjectName).zip* file attached to the release.
2. **If on Windows**: Right-click the downloaded zip, select Properties, then unblock the file.
    > _This is to prevent having to unblock each file individually after unzipping._
3. Unzip the archive.
4. (Optional) Place the module folder somewhere in your ``PSModulePath``.
    > _You can view the paths listed by running the environment variable ```$env:PSModulePath``_
5. Import the module, using the full path to the PSD1 file in place of ``$($env:BHProjectName)`` if the unzipped module folder is not in your ``PSModulePath``:
    ``````powershell
    # In `$env:PSModulePath
    Import-Module $($env:BHProjectName)

    # Otherwise, provide the path to the manifest:
    Import-Module -Path C:\MyPSModules\$($env:BHProjectName)\$($versionToDeploy.ToString())\$($env:BHProjectName).psd1
    ``````
"@
                $gitHubParams = @{
                    VersionNumber    = $versionToDeploy.ToString()
                    CommitId         = $commitId
                    ReleaseNotes     = $ReleaseNotes
                    ArtifactPath     = $zipPath
                    GitHubUsername   = 'SCRT-HQ'
                    GitHubRepository = $env:BHProjectName
                    GitHubApiKey     = $env:GitHubPAT
                    Draft            = $false
                }
                Publish-GitHubRelease @gitHubParams
                "    Release creation successful!"
            }
            else {
                "    [SKIPPED] Publishing Release v$($versionToDeploy) @ commit Id [$($commitId)] to GitHub"
            }
        }
        catch {
            Write-Error $_ -ErrorAction Stop
        }
    }
    else {
        Write-Host -ForegroundColor Yellow "No module version matched! Negating deployment to prevent errors"
        $env:BHCommitMessage = $env:BHCommitMessage.Replace('!deploy', '')
    }
}

Task Deploy -Depends Init $deployScriptBlock -Description 'Deploy module to PSGallery' -PreAction {
    Import-Module -Name $outputModDir -Force -Verbose:$false
}

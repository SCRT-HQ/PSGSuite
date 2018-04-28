# Generic module deployment.
# This stuff should be moved to psake for a cleaner deployment view

# ASSUMPTIONS:

 # folder structure of:
 # - RepoFolder
 #   - This PSDeploy file
 #   - ModuleName
 #     - ModuleName.psd1

 # Nuget key in $ENV:NugetApiKey

 # Set-BuildEnvironment from BuildHelpers module has populated ENV:BHProjectName

# Publish to gallery with a few restrictions
if(
    $env:BHProjectName -and $env:BHProjectName.Count -eq 1 -and
    $env:BHBuildSystem -ne 'Unknown' -and
    $env:BHBranchName -eq "master" -and
    $env:BHCommitMessage -match '!deploy' -and
    $env:APPVEYOR_BUILD_WORKER_IMAGE -like '*2017*' -and
    $env:APPVEYOR_PULL_REQUEST_NUMBER -eq $null
)
{
    Deploy Module {
        By PSGalleryModule {
            FromSource $ENV:BHProjectName
            To PSGallery
            WithOptions @{
                ApiKey = $ENV:NugetApiKey
            }
        }
    }
}
else
{
    "Skipping deployment: To deploy, ensure that...`n" +
    "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
    "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
    "`t* You are not building a Pull Request (Current: $ENV:APPVEYOR_PULL_REQUEST_NUMBER) `n" +
    "`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage) `n" +
    "`t* Your build image is Visual Studio 2017 (Current: $ENV:APPVEYOR_BUILD_WORKER_IMAGE)" |
        Write-Host
}

# Publish to AppVeyor if we're in AppVeyor
if(
    $env:BHProjectName -and $ENV:BHProjectName.Count -eq 1 -and
    $env:BHBuildSystem -eq 'AppVeyor'
   )
{
    Deploy DeveloperBuild {
        By AppVeyorModule {
            FromSource $ENV:BHProjectName
            To AppVeyor
            WithOptions @{
                Version = $env:APPVEYOR_BUILD_VERSION
            }
        }
    }
}
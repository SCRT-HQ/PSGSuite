# Contributing to PSGSuite

<!-- TOC -->

- [Contributing to PSGSuite](#contributing-to-psgsuite)
    - [Git and Pull requests](#git-and-pull-requests)
    - [Overview](#overview)
        - [Step by Step](#step-by-step)
        - [Contributing Guidelines](#contributing-guidelines)
        - [Updating the Wiki](#updating-the-wiki)
    - [Getting Started](#getting-started)
        - [Enabling Debug Mode](#enabling-debug-mode)
        - [Google .NET SDK Documentation](#google-net-sdk-documentation)
    - [Keeping in Touch](#keeping-in-touch)

<!-- /TOC -->

Thank you for your interest in helping PSGSuite grow! Below you'll find some guidelines around developing additional features and squashing bugs, including some how-to's to get started quick, general style guidelines, etc.

## Git and Pull requests

* Contributions are submitted, reviewed, and accepted using Github pull requests. [Read this article](https://help.github.com/articles/using-pull-requests) for some details. We use the _Fork and Pull_ model, as described there. More info can be found here: [Forking Projects](https://guides.github.com/activities/forking/)
* Please make sure to leave the `Allow edits from maintainers` box checked when submitting PR's so that any edits can be made by maintainers of the repo directly to the source branch and into the same PR. More info can be found here: [Allowing changes to a pull request branch created from a fork](https://help.github.com/articles/allowing-changes-to-a-pull-request-branch-created-from-a-fork/#enabling-repository-maintainer-permissions-on-existing-pull-requests)

## Overview

### Step by Step

Here's the overall flow of making contributions:  
1. Fork the repo
2. Make your edits / additions on your fork
3. Push your changes back to your fork on GitHub
4. Submit a pull request
5. Pull request is reviewed. Any necessary edits / suggestions will be made
6. Once changes are approved, the pull request is merged into the origin's master branch and deployed to the PowerShell Gallery once CI tests pass in AppVeyor

### Contributing Guidelines

Please follow these guidelines for any content being added:

* **ALL functions must...**
    * work in the supported PowerShell versions by this module
    * work in any OS;
        * any code that includes paths must build the path using OS-agnostic methods, i.e. by using `Resolve-Path`, `Join-Path` and `Split-Path`
        * paths also need to use correct casing, as some OS's are case-sensitive in terms of paths
* **Public functions must...** 
    * include comment-based help (this is used to drive the Wiki updates on deployment)
    * include Write-Verbose calls to describe what the function is doing (CI tests will fail the build if any don't)
    * be placed in the correct APU/use-case folder in the Public sub-directory of the module path (if it's a new API/use-case, create the new folder as well)
    * use `SupportsShouldProcess` if...
        * the function's verb is `Remove` or `Set`. 
        * it can be included on `Update` functions as well, if felt that the actions executed by the function should be guarded
        * `Get` functions should **never** need `SupportsShouldProcess`
* **Every Pull Request must...**
    > These can be added in during the pull request review process, but are nice to have if possible
    * have the module version bumped appropriately in the manifest (Major for any large updates, Minor for any new functionality, Patch for any hotfixes)
    * have an entry in the Changelog describing what was added, updated and/or fixed with this version number
        * *Please follow the same format already present*
    * have an entry in the ReadMe's `Most recent changes` section describing what was added, updated and/or fixed with this version number
        * *Please follow the same format already present*
        * *This can be copied over from the Changelog entry*

### Updating the Wiki

* Wiki updates are scripted during deployment builds, so there is no need to manually update the Wiki. 
* Any new or updated comment-based help content will be transformed to Markdown using `platyPS` and pushed to the Wiki repo when deployment conditions are met.

## Getting Started

### Enabling Debug Mode

To enable debug mode and export the `New-GoogleService` function with the module, you can run the `Debub Mode.ps1` script in the `tools` folder in the root of the repo or the following lines of code from the root of the repo in PowerShell:

```powershell
$env:EnablePSGSuiteDebug = $true
Import-Module (Join-Path (Join-Path "." "PSGSuite") "PSGSuite.psd1") -Force
```

Debug mode is useful as it gives you access to the `New-GoogleService` function. This is normally a private function that is used by most other functions to create `Google Service` object with which to create and execute requests with. For example:

```powershell
$serviceParams = @{
    # This needs to be one of the scopes that the request method invoked by the function needs
    Scope       = 'https://www.googleapis.com/auth/admin.directory.user'
    # This is the Google SDK Service Type used by all classes/methods in that category.
    # Most of the calls in PSGSuite use the below DirectoryService, as that houses the Google Admin SDK
    ServiceType = 'Google.Apis.Admin.Directory.directory_v1.DirectoryService'
}

# Create the Google Service object and store that in the $service variable
$service = New-GoogleService @serviceParams

# Create the request object using the $service and store that in the $request variable
$request = $service.Users.List()

# Execute the request to return the results
$request.Execute()
```

### Google .NET SDK Documentation

PSGSuite uses Google's .NET SDK's for 99% of its functions. The easiest way to pull up the documentation for the function you are writing is by doing the following (*using the Admin Directory API as an example*):

1. Find Google's API information for the function you're writing
    * Usually the first result when searching for specific API's in Google:
        * Search: `google admin directory api`
        * Result: [G Suite Admin SDK Directory API](https://developers.google.com/admin-sdk/directory/)
2. Open the **Guides** tab
3. Click the **.NET** section under the `Quickstarts` header in the side menu
4. Scroll to the bottom of the page and click the link for the **.NET reference documentation** under the **Further reading** header. For the Admin Directory API, it's: [Directory API .NET reference documentation](https://developers.google.com/resources/api-libraries/documentation/admin/directory_v1/csharp/latest/)
5. Click the **Classes** dropdown on the top-left of the page, then click **Class List**
6. Find the resource class you are looking for. Resource classes all end in `Resource`, i.e. `UsersResource` or `OrgunitResource`.
7. Find the request method specific to your function. Request methods all end in `Request`, i.e. `ListRequest` or `InsertRequest`.


## Keeping in Touch

For any questions, comments or concerns outside of opening an issue, please join us in the `#psgsuite` channel on the SCRT HQ Slack; Team: `scrthq.slack.com`. [Click here](https://scrthq-slack-invite.herokuapp.com/) to get an invite!
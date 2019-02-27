# Contributing to PSGSuite

<!-- TOC -->

* [Contributing to PSGSuite](#contributing-to-psgsuite)
  * [Git and Pull requests](#git-and-pull-requests)
  * [Overview](#overview)
    * [Step by Step (High-Level)](#step-by-step-high-level)
    * [Contributing Guidelines](#contributing-guidelines)
    * [Updating the Wiki](#updating-the-wiki)
  * [Getting Started](#getting-started)
    * [Enabling Debug Mode](#enabling-debug-mode)
    * [Google .NET SDK Documentation](#google-net-sdk-documentation)
      * [.NET/API Documentation Links](#netapi-documentation-links)
  * [Keeping in Touch](#keeping-in-touch)

<!-- /TOC -->

Thank you for your interest in helping PSGSuite grow! Below you'll find some guidelines around developing additional features and squashing bugs, including some how-to's to get started quick, general style guidelines, etc.

[![Waffle.io - Columns and their card count](https://badge.waffle.io/scrthq/PSGSuite.svg?columns=all)](https://waffle.io/scrthq/PSGSuite)

## Git and Pull requests

* Contributions are submitted, reviewed, and accepted using Github pull requests. [Read this article](https://help.github.com/articles/using-pull-requests) for some details. We use the _Fork and Pull_ model, as described there. More info can be found here: [Forking Projects](https://guides.github.com/activities/forking/)
* Please make sure to leave the `Allow edits from maintainers` box checked when submitting PR's so that any edits can be made by maintainers of the repo directly to the source branch and into the same PR. More info can be found here: [Allowing changes to a pull request branch created from a fork](https://help.github.com/articles/allowing-changes-to-a-pull-request-branch-created-from-a-fork/#enabling-repository-maintainer-permissions-on-existing-pull-requests)

## Overview

### Step by Step (High-Level)

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

To enable debug mode and export the `New-GoogleService` function with the module, you can run the `Debub Mode.ps1` script in the root of the repo or the following lines of code from the root of the repo in PowerShell:

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
    * **See the [Documentation Links](#netapi-documentation-links) section below for some handy links**
2. Open the **Guides** tab
3. Click the **.NET** section under the `Quickstarts` header in the side menu
4. Scroll to the bottom of the page and click the link for the **.NET reference documentation** under the **Further reading** header. For the Admin Directory API, it's: [Directory API .NET reference documentation](https://developers.google.com/resources/api-libraries/documentation/admin/directory_v1/csharp/latest/)
5. Click the **Classes** dropdown on the top-left of the page, then click **Class List**
6. Find the resource class you are looking for. Resource classes all end in `Resource`, i.e. `UsersResource` or `OrgunitResource`.
7. Find the request method specific to your function. Request methods all end in `Request`, i.e. `ListRequest` or `InsertRequest`.

#### .NET/API Documentation Links

Here are some links to the most commonly used SDK's and API's in PSGSuite:

* **Admin SDK: Directory API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/admin/directory_v1/csharp/latest/index.html)
    * [API Documentation](https://developers.google.com/admin-sdk/directory/v1/reference/)
* **Apps Activity API - Updating to Drive Activity API v2 (new name) - Sunset scheduled December 2019**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/appsactivity/v1/csharp/latest/)
    * [API Documentation](https://developers.google.com/drive/activity/v1/reference/)
* **Contacts API - To be replaced soon with People API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/contacts/v1/csharp/latest/)
    * [API Documentation](https://developers.google.com/contacts/v3/reference)
* **Drive Activity API v2**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/driveactivity/v2/csharp/latest/)
    * [API Documentation](https://developers.google.com/drive/activity/v2/reference/rest/)
* **Enterprise License Manager API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/licensing/v1/csharp/latest/)
    * [API Documentation](https://developers.google.com/admin-sdk/licensing/v1/reference/)
* **Gmail API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/gmail/v1/csharp/latest/)
    * [API Documentation](https://developers.google.com/gmail/api/v1/reference/)
* **Google Calendar API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/calendar/v3/csharp/latest/)
    * [API Documentation](https://developers.google.com/calendar/v3/reference/)
* **Google Classroom API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/classroom/v1/csharp/latest/)
    * [API Documentation](https://developers.google.com/classroom/reference/rest/)
* **Google Docs API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/docs/v1/csharp/latest/)
    * [API Documentation](https://developers.google.com/docs/api/reference/rest/)
* **Google Drive API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/drive/v3/csharp/latest/)
    * [API Documentation](https://developers.google.com/drive/api/v3/reference/)
* **Google Sheets API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/sheets/v4/csharp/latest/)
    * [API Documentation](https://developers.google.com/sheets/api/reference/rest/)
* **Google Slides API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/slides/v1/csharp/latest/)
    * [API Documentation](https://developers.google.com/slides/reference/rest/)
* **Groups Settings API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/groupssettings/v1/csharp/latest/)
    * [API Documentation](https://developers.google.com/admin-sdk/groups-settings/v1/reference/groups)
* **Hangouts Chat API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/chat/v1/csharp/latest/)
    * [API Documentation](https://developers.google.com/hangouts/chat/reference/)
* **People API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/people/v1/csharp/latest/)
    * [API Documentation](https://developers.google.com/people/api/rest/)
* **Tasks API**
    * [.NET SDK Documentation](https://developers.google.com/resources/api-libraries/documentation/tasks/v1/csharp/latest/)
    * [API Documentation](https://developers.google.com/tasks/v1/reference/)


## Keeping in Touch

For any questions, comments or concerns outside of opening an issue, please reach out:
* on the SCRT HQ Slack: `scrthq.slack.com`. [Click here](https://scrthq-slack-invite.herokuapp.com/) to get an invite!
* on the SCRT HQ Discord: [Click here](https://discord.gg/G66zVG7) to get an invite!
* `@scrthq` on the [PowerShell Slack](http://slack.poshcode.org/) if you're on there as well!
* [`@scrthq`](https://twitter.com/scrthq) on Twitter

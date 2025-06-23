# Contributing to PSGSuite

Thank you for your interest in helping PSGSuite grow! Below you'll find some guidelines around developing additional features and squashing bugs, including some how-to's to get started quick, general style guidelines, etc.

<!-- no toc -->
- [Git and Pull requests](#git-and-pull-requests)
- [Overview](#overview)
    - [Code Guidelines](#code-guidelines)
    - [Documentation Guidelines](#documentation-guidelines)
        - [Requirements](#requirements)
        - [Setting up MkDocs Locally](#setting-up-mkdocs-locally)
- [Getting Started](#getting-started)
    - [Enabling Debug Mode](#enabling-debug-mode)
    - [Google .NET SDK Documentation](#google-net-sdk-documentation)
- [Keeping in Touch](#keeping-in-touch)

## Git and Pull requests

- Contributions are submitted, reviewed, and accepted through **GitHub Pull Requests**:
    - Learn more about it [here](https://help.github.com/articles/using-pull-requests).
- We follow the **Fork and Pull*- model.
    - Learn more about it [here](https://guides.github.com/activities/forking/).
- When submitting a pull request, ensure the `Allow edits from maintainers` option is checked. This allows maintainers to make necessary edits directly to your branch and include them in the same pull request.
    - Learn more about it [here](https://help.github.com/articles/allowing-changes-to-a-pull-request-branch-created-from-a-fork/#enabling-repository-maintainer-permissions-on-existing-pull-requests).

## Overview

Here's the overall flow of making contributions:

1. Fork the repo
2. Make your edits / additions on your fork
3. Push your changes back to your fork on GitHub
4. Submit a pull request
5. Pull request is reviewed. Any necessary edits / suggestions will be made
6. Once changes are approved, the pull request is merged into the origin's main branch and deployed to the PowerShell Gallery once CI tests pass

### Code Guidelines

Please follow these guidelines for any content being added:

- **ALL functions must...**
    - Work in the supported PowerShell versions by this module
    - Work in any OS;
        - Any code that includes paths must build the path using OS-agnostic methods, i.e. by using `Resolve-Path`, `Join-Path` and `Split-Path`
        - Paths also need to use correct casing, as some OS's are case-sensitive in terms of paths
- **Public functions must...**
    - Include comment-based help (this is used to drive the Wiki updates on deployment)
    - Include Write-Verbose calls to describe what the function is doing (CI tests will fail the build if any don't)
    - Be placed in the correct APU/use-case folder in the Public sub-directory of the module path (if it's a new API/use-case, create the new folder as well)
    - Use `SupportsShouldProcess` if...
        - The function's verb is `Remove` or `Set`.
        - It can be included on `Update` functions as well, if felt that the actions executed by the function should be guarded
        - `Get` functions should **never** need `SupportsShouldProcess`
- **Every Pull Request must...**
    > [!NOTE]
    > These can be added in during the pull request review process, but are nice to have if possible

    - Have the module version bumped appropriately in the manifest (Major for any large updates, Minor for any new functionality, Patch for any hotfixes)
    - Have an entry in the Changelog describing what was added, updated and/or fixed with this version number
        > [!NOTE]
        > Please follow the same format already present
    - Have an entry in the readme's `Most recent changes` section describing what was added, updated and/or fixed with this version number
        > [!NOTE]
        > Please follow the same format already present
        >
        >This can be copied over from the Changelog entry

### Documentation Guidelines

The PSGSuite documentation site is built using MkDocs. Follow these steps to spin up MkDocs locally, make changes, and preview your updates before submitting them.

#### Requirements

- Python (version 3.7 or higher):
    - Download and install Python from [python.org](https://python.org).
    - Ensure `pip` (Python's package manager) is installed and available in your `PATH`.
- MkDocs and Dependencies:
    - Install MkDocs and its dependencies using the provided `requirements.txt` file.

#### Setting up MkDocs Locally

- Fork the PSGSuite repository
- Clone your forked repository to your local machine

```plaintext
git clone https://github.com/<your-username>/PSGSuite.git
```

- Navigate to the cloned repository directory

```plaintext
cd //path/to/PSGSuite
```

1. Install dependencies

```plaintext
pip install -r requirements.txt
```

1. Start the MkDocs development server and navigate to `http://127.0.0.1:8000` in your web browser

```plaintext
mkdocs serve
```

1. Make your edits and submit a pull request

> [!NOTE]
>
> The `Function Help` content is automatically updated during the deployment builds. Any new or updated comment-based help will be transformed to Markdown using `platyPS` and pushed when deployment conditions are met.
Install MkDocs and its dependencies using the provided requirements.txt file.

## Getting Started

### Enabling Debug Mode

A debug build of the module can be built by providing the `-DebugBuild` switch to `build.ps1`.

Debug builds contain the following changes:

- All source code is dot sourced within the compiled module instead of being copied directly into the `psgsuite.psm1` file.
- All module functions and variables are exported to the PowerShell session.

### Google .NET SDK Documentation

PSGSuite uses Google's .NET SDK's for 99% of its functions. The easiest way to pull up the documentation for the function you are writing is by visiting Google's API .NET [GitHub repository](https://github.com/googleapis/google-api-dotnet-client). Scroll down to [`API-specific Libraries`](https://github.com/googleapis/google-api-dotnet-client?tab=readme-ov-file#api-specific-libraries) for more .NET SDK Documentation and API documentation.

## Keeping in Touch

For any questions, comments or concerns outside of opening an issue, please reach out:

- On the SCRT HQ Slack: `scrthq.slack.com`. [Click here](https://scrthq-slack-invite.herokuapp.com/) to get an invite!
- On the SCRT HQ Discord: [Click here](https://discord.gg/G66zVG7) to get an invite!
- `@scrthq` on the [PowerShell Slack](http://slack.poshcode.org/) if you're on there as well!
- [`@scrthq`](https://twitter.com/scrthq) on Twitter

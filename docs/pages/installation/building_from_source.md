# Building From Source

???+ danger
    This is intended for developers, contributors and bleeding edge fans.

???+ warning
    You **must** have the module 'Configuration' installed as a prerequisite. Installing the module from the repo source or the release page does not automatically install dependencies.

1. Clone the repo locally:

```{linenums="1"}
git clone https://github.com/scrthq/PSGSuite.git
```

1. Navigate to the cloned repo:

```{linenums="1"}
cd \\path\to\PSGSuite
```

1. To build the module locally to test changes run `build.ps1` at the root of the repo:

```powershell {linenums="1"}
.\build.ps1
```

1. To run the Pester tests locally to test changes run `build.ps1` with the `-Task` parameter set to `Test` at the root of the repo:

```powershell {linenums="1"}
.\build.ps1 -Task Test
```

1. Import the compiled module in a new session - from the root of the repo run the following:

```powershell {linenums="1"}
Import-Module .\BuildOutput\PSGSuite -Force
```

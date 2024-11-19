# PSGSuite

## IMPORTANT - PSGSUITE 3.0.0+ REQUIRES POWERSHELL 6.0+

This is a breaking change introduced with PSGSuite 3.0.0. Please see the
[CHANGELOG](./CHANGELOG.md) for more information.

---

<div align="center">
  <!-- Discord -->
  <a href="https://discord.gg/G66zVG7">
    <img src="https://img.shields.io/discord/235574673155293194.svg?style=flat&label=Discord&logo=discord&color=purple"
      alt="Discord - Chat" title="Discord - Chat" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- Slack -->
  <a href="https://scrthq-slack-invite.herokuapp.com/">
    <img src="https://img.shields.io/badge/chat-on%20slack-orange.svg?style=flat&logo=slack"
      alt="Slack - Chat" title="Slack - Chat" />
  </a>
  <br />
  <br />
  <!-- PS Gallery -->
  <a href="https://www.PowerShellGallery.com/packages/PSGSuite">
    <img src="https://img.shields.io/powershellgallery/dt/PSGSuite.svg?style=flat&logo=powershell&color=blue"
      alt="PowerShell Gallery" title="PowerShell Gallery" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- GitHub Releases -->
  <a href="https://github.com/scrthq/PSGSuite/releases/latest">
    <img src="https://img.shields.io/github/downloads/scrthq/PSGSuite/total.svg?logo=github&color=blue"
      alt="GitHub Releases" title="GitHub Releases" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <!-- GitHub Releases -->
  <a href="https://github.com/scrthq/PSGSuite/releases/latest">
    <img src="https://img.shields.io/github/release/scrthq/PSGSuite.svg?label=version&logo=github"
      alt="GitHub Releases" title="GitHub Releases" />
  </a>
</div>
<br />

***

## Documentation

Check out [PSGSuite.io](https://psgsuite.io/) for PSGSuite documentation, including [initial setup](https://psgsuite.io/Initial%20Setup/) help as well as function help!

## Contributing

Interested in helping out with PSGSuite development? Please check out our [Contribution Guidelines](https://github.com/scrthq/PSGSuite/blob/main/CONTRIBUTING.md)!

Building the module locally to test changes is as easy as running the `build.ps1` file in the root of the repo. This will compile the module with your changes and import the newly compiled module at the end by default.

Want to run the Pester tests locally? Pass `Test` as the value to the `Task` script parameter like so:

```powershell
.\build.ps1 -Task Test
```

## Code of Conduct

Please adhere to our [Code of Conduct](https://github.com/scrthq/PSGSuite/blob/main/CODE_OF_CONDUCT.md) when interacting with this repo.

## License

[Apache 2.0](https://tldrlegal.com/license/apache-license-2.0-(apache-2.0))

## Changelog

[Full CHANGELOG here](https://github.com/scrthq/PSGSuite/blob/main/CHANGELOG.md)

***

### 3.0.0 - 2024-11-20

#### Breaking Changes

- Increased minimum PowerShell version to 7.4
    - Necessary due to deprecation of support for .NET Framework 4.5 within the `Google.Apis.*` .NET assemblies used throughout PSGSuite
    - Aligns minimum version of PowerShell with the current LTS release of PowerShell

#### Other Changes

- Restored release capabilities within the backing repository after adding additional owner ([@jgeron-suhsd](https://github.com/jgeron-suhsd))
- Migrates the CI/CD pipeline from Azure Pipelines to GitHub Actions.
    - We are currently adding additional maintainers to the project to restore overall project health and return to a regular release cadence, ultimately working through the backlog of issues, fixes and enhancements.

# PSGSuite

<div align="center">
<!--
  <img src="https://github.com/scrthq/PSGSuite/raw/main/bin/img/psgsuite2.0.0.png" alt="PSGSuite 2.0.0 released!" />
  <br />
  <br />
-->
  <!-- Azure Pipelines -->
  <a href="https://dev.azure.com/scrthq/SCRT%20HQ/_build/latest?definitionId=2">
    <img src="https://dev.azure.com/scrthq/SCRT%20HQ/_apis/build/status/PSGSuite-CI"
      alt="Azure Pipelines" title="Azure Pipelines" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;

  <!-- Discord -->
  <a href="https://discord.gg/G66zVG7">
    <img src="https://img.shields.io/discord/235574673155293194.svg?style=flat&label=Discord&logo=discord&color=purple"
      alt="Discord - Chat" title="Discord - Chat" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;

  <!-- Slack -->
  <a href="https://scrthq-slack-invite.herokuapp.com/">
    <img src="https://img.shields.io/badge/chat-on%20slack-orange.svg?style=flat&logo=slack"
      alt="Slack - Chat" title="Slack - Chat" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;

  <!-- Gitter -->
  <a href="https://gitter.im/PSGSuite/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge">
    <img src="https://img.shields.io/gitter/room/scrthq/PSGSuite.svg?logo=gitter&style=flat&color=red"
      alt="Gitter - Chat" title="Gitter - Chat" />
  </a>
  <br />
  <br />

  <!-- Codacy -->
  <a href="https://www.codacy.com/app/scrthq/PSGSuite?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=scrthq/PSGSuite&amp;utm_campaign=Badge_Grade">
    <img src="https://api.codacy.com/project/badge/Grade/0d5203a1cf1945fe94c46b779eecb7f0"
      alt="Codacy" title="Codacy" />
  </a>&nbsp;&nbsp;&nbsp;&nbsp;

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

* [Getting started](https://psgsuite.io/docs\pages\getting_started\getting_started.md)
* [Examples](https://psgsuite.io/docs/pages/examples)
* [Function Help](https://psgsuite.io/pages/function_help)

## Contributing

Interested in helping out with PSGSuite development? Please check out our [Contribution Guidelines](https://github.com/scrthq/PSGSuite/blob/main/CONTRIBUTING.md).

### Building PSGSuite Locally

To build the module locally to test changes run `build.ps1` at the root of the repo.

```powershell {linenums="1"}
.\build.ps1
```

This will compile the module with your changes and import the newly compiled module at the end by default.

#### Pester Tests

To run the Pester tests locally pass `Test` as the value to the `Task` script parameter like so:

```powershell {linenums="1"}
.\build.ps1 -Task Test
```

## Code of Conduct

Please adhere to our [Code of Conduct](https://github.com/scrthq/PSGSuite/blob/main/CODE_OF_CONDUCT.md) when interacting with this repo.

## License

[Apache 2.0](https://tldrlegal.com/license/apache-license-2.0-(apache-2.0))

## Changelog

[Full CHANGELOG here](https://github.com/scrthq/PSGSuite/blob/main/CHANGELOG.md)

***

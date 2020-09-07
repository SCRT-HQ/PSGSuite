function Get-PSGSuiteConfig {
    <#
    .SYNOPSIS
    Loads the specified PSGSuite config

    .DESCRIPTION
    Loads the specified PSGSuite config

    .PARAMETER ConfigName
    The config name to load

    .PARAMETER Path
    The path of the config to load if non-default.

    This can be used to load either a legacy XML config from an older version of PSGSuite or a specific .PSD1 config created with version 2.0.0 or greater

    .PARAMETER Scope
    The config scope to load

    .PARAMETER PassThru
    If specified, returns the config after loading it

    .PARAMETER NoImport
    If $true, just returns the specified config but does not impart it in the current session.

    .EXAMPLE
    Get-PSGSuiteConfig personalDomain -PassThru

    This will load the config named "personalDomain" and return it as a PSObject.
    #>
    [cmdletbinding(DefaultParameterSetName = "ConfigurationModule")]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ParameterSetName = "ConfigurationModule")]
        [String]
        $ConfigName,
        [Parameter(Mandatory = $false,ParameterSetName = "Path")]
        [ValidateScript( {Test-Path $_})]
        [String]
        $Path,
        [Parameter(Mandatory = $false,Position = 1)]
        [ValidateSet("User", "Machine", "Enterprise", $null)]
        [string]
        $Scope = $Script:ConfigScope,
        [Parameter(Mandatory = $false)]
        [Switch]
        $PassThru,
        [Parameter(Mandatory = $false)]
        [Switch]
        $NoImport
    )
    Process {
        $script:ConfigScope = $Scope
        switch ($PSCmdlet.ParameterSetName) {
            ConfigurationModule {
                $fullConf = Import-SpecificConfiguration -CompanyName 'SCRT HQ' -Name 'PSGSuite' -Scope $Script:ConfigScope
                if (!$ConfigName) {
                    $choice = $fullConf["DefaultConfig"]
                    Write-Verbose "Importing default config: $choice"
                }
                else {
                    $choice = $ConfigName
                    Write-Verbose "Importing config: $choice"
                }
                $encConf = [PSCustomObject]($fullConf[$choice])
            }
            Path {
                $encConf = switch ((Get-Item -Path $Path).Extension) {
                    '.xml' {
                        Import-Clixml -Path $Path
                        $choice = "LegacyXML"
                    }
                    '.psd1' {
                        Import-SpecificConfiguration -Path $Path
                        $choice = "CustomConfigurationFile"
                    }
                }
            }
        }
        $decryptParams = @{
            ConfigName = $choice
        }
        if ($Path) {
            $decryptParams['ConfigPath'] = $Path
        }
        $decryptedConfig = $encConf | Get-GSDecryptedConfig @decryptParams
        Write-Verbose "Retrieved configuration '$choice'"
        if (!$NoImport) {
            $script:PSGSuite = $decryptedConfig
        }
        if ($PassThru) {
            $decryptedConfig
        }
    }
}

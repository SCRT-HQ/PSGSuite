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
    Begin {
        function Decrypt {
            param($String)
            if ($String -is [System.Security.SecureString]) {
                [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
                    [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(
                        $String))
            }
            elseif ($String -is [ScriptBlock]) {
                $String.InvokeReturnAsIs()
            }
            else {
                $String
            }
        }
        $outputProps = @(
            @{l = 'ConfigName';e = {$choice}},
            @{l = 'P12KeyPath';e = {Decrypt $_.P12KeyPath}},
            'P12Key',
            @{l = 'P12KeyPassword';e = {Decrypt $_.P12KeyPassword}},
            @{l = 'P12KeyObject';e = {Decrypt $_.P12KeyObject}},
            @{l = 'ClientSecretsPath';e = {Decrypt $_.ClientSecretsPath}},
            @{l = 'ClientSecrets';e = {Decrypt $_.ClientSecrets}},
            @{l = 'AppEmail';e = {
                if ($_.AppEmail) {
                    Decrypt $_.ServiceAccountClientID
                }
                elseif ($_.ClientSecrets) {
                    (Decrypt $_.ClientSecrets | ConvertFrom-Json).client_email
                }
            }},
            @{l = 'AdminEmail';e = {Decrypt $_.AdminEmail}},
            @{l = 'CustomerID';e = {Decrypt $_.CustomerID}},
            @{l = 'Domain';e = {Decrypt $_.Domain}},
            @{l = 'Preference';e = {Decrypt $_.Preference}},
            @{l = 'ServiceAccountClientID';e = {
                if ($_.ServiceAccountClientID) {
                    Decrypt $_.ServiceAccountClientID
                }
                elseif ($_.ClientSecrets) {
                    (Decrypt $_.ClientSecrets | ConvertFrom-Json).client_id
                }
            }},
            @{l = 'Chat';e = {
                $dict = @{
                    Webhooks = @{}
                    Spaces = @{}
                }
                foreach ($key in $_.Chat.Webhooks.Keys) {
                    $dict['Webhooks'][$key] = (Decrypt $_.Chat.Webhooks[$key])
                }
                foreach ($key in $_.Chat.Spaces.Keys) {
                    $dict['Spaces'][$key] = (Decrypt $_.Chat.Spaces[$key])
                }
                $dict
            }},
            @{l = 'ConfigPath';e = {
                if ($_.ConfigPath) {
                    $_.ConfigPath
                }
                elseif ($Path) {
                    (Resolve-Path $Path).Path
                }
                else {
                    $null
                }
            }}
        )
    }
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
        $decryptedConfig = $encConf | Select-Object -Property $outputProps
        Write-Verbose "Retrieved configuration '$choice'"
        if (!$NoImport) {
            $script:PSGSuite = $decryptedConfig
        }
        if ($PassThru) {
            $decryptedConfig
        }
    }
}

function Get-PSGSuiteConfig {
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
        $PassThru
    )
    function Decrypt {
        param($String)
        if ($String -is [System.Security.SecureString]) {
            [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(
                    $string))
        }
        elseif ($String -is [System.String]) {
            $String
        }
    }
    $script:ConfigScope = $Scope
    switch ($PSCmdlet.ParameterSetName) {
        ConfigurationModule {
            $fullConf = Import-SpecificConfiguration -CompanyName 'SCRT HQ' -Name 'PSGSuite2' -Scope $Script:ConfigScope
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
    $script:PSGSuite = $encConf |
        Select-Object -Property @{l = 'ConfigName';e = {$choice}},
                                @{l = 'P12KeyPath';e = {Decrypt $_.P12KeyPath}},
                                @{l = 'ClientSecretsPath';e = {Decrypt $_.ClientSecretsPath}},
                                @{l = 'AppEmail';e = {Decrypt $_.AppEmail}},
                                @{l = 'AdminEmail';e = {Decrypt $_.AdminEmail}},
                                @{l = 'CustomerID';e = {Decrypt $_.CustomerID}},
                                @{l = 'Domain';e = {Decrypt $_.Domain}},
                                @{l = 'Preference';e = {Decrypt $_.Preference}},
                                @{l = 'ServiceAccountClientID';e = {Decrypt $_.ServiceAccountClientID}},
                                @{l = 'ConfigPath';e = {if ($_.ConfigPath) {
                                            $_.ConfigPath
                                        }
                                        elseif ($Path) {
                                            "$(Resolve-Path $Path)"
                                        }
                                        else {
                                            $null
                                        }
                                    }
                                }
    Write-Verbose "Imported configuration '$choice'"
    if ($PassThru) {
        $script:PSGSuite
    }
}
function Switch-PSGSuiteConfig {
    [CmdletBinding(DefaultParameterSetName = "ConfigName")]
    [Alias("Switch-PSGSuiteDomain")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ParameterSetName = "ConfigName")]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigName,
        [parameter(Mandatory = $true,Position = 0,ParameterSetName = "Domain")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Domain,
        [parameter(Mandatory = $false)]
        [switch]
        $SetToDefault
    )
    if ($script:PSGSuite.Domain -eq $Domain) {
        Write-Warning "Current config is already set to domain '$Domain'. If you would like to import a different config for the same domain, please use the -ConfigName parameter instead"
    }
    elseif ($script:PSGSuite.ConfigName -eq $ConfigName) {
        Write-Warning "Current config is already set to '$ConfigName' --- no action taken"
    }
    else {
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
        $fullConf = Import-SpecificConfiguration -CompanyName 'SCRT HQ' -Name 'PSGSuite2' -Scope $Script:ConfigScope -Verbose:$false
        $defaultConfigName = $fullConf['DefaultConfig']
        $choice = switch ($PSCmdlet.ParameterSetName) {
            Domain {
                Write-Verbose "Switching active domain to '$Domain'"
                $fullConf.Keys | Where-Object {(Decrypt $fullConf[$_]['Domain']) -eq $Domain}
            }
            ConfigName {
                Write-Verbose "Switching active config to '$ConfigName'"
                $fullConf.Keys | Where-Object {$_ -eq $ConfigName}
            }
        }
        if ($choice) {
            $script:PSGSuite = [PSCustomObject]($fullConf[$choice]) |
                Select-Object -Property @{l = 'ConfigName';e = {$choice}},
                                        @{l = 'P12KeyPath';e = {Decrypt $_.P12KeyPath}},
                                        @{l = 'ClientSecretsPath';e = {Decrypt $_.ClientSecretsPath}},
                                        @{l = 'ClientSecrets';e = {Decrypt $_.ClientSecrets}},
                                        @{l = 'AppEmail';e = {Decrypt $_.AppEmail}},
                                        @{l = 'AdminEmail';e = {Decrypt $_.AdminEmail}},
                                        @{l = 'CustomerID';e = {Decrypt $_.CustomerID}},
                                        @{l = 'Domain';e = {Decrypt $_.Domain}},
                                        @{l = 'Preference';e = {Decrypt $_.Preference}},
                                        @{l = 'ServiceAccountClientID';e = {Decrypt $_.ServiceAccountClientID}},
                                        ConfigPath
            if ($SetToDefault) {
                if ($defaultConfigName -ne $choice) {
                    Write-Verbose "Setting config name '$choice' for domain '$($script:PSGSuite.Domain)' as default"
                    Set-PSGSuiteConfig -ConfigName $choice -SetAsDefaultConfig -Verbose:$false
                    $env:PSGSuiteDefaultDomain = $script:PSGSuite.Domain
                    [Environment]::SetEnvironmentVariable("PSGSuiteDefaultDomain", $script:PSGSuite.Domain, "User")
                }
                else {
                    Write-Warning "Config name '$choice' for domain '$($script:PSGSuite.Domain)' is already set to default --- no action taken"
                }
            }
        }
        else {
            switch ($PSCmdlet.ParameterSetName) {
                Domain {
                    Write-Warning "No config found for domain '$Domain'! Retaining existing config for domain '$($script:PSGSuite.Domain)'"
                }
                ConfigName {
                    Write-Warning "No config named '$ConfigName' found! Retaining existing config '$($script:PSGSuite.ConfigName)'"
                }
            }
        }
    }
}
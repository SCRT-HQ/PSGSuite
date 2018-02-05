function Switch-PSGSuiteConfig {
    <#
    .SYNOPSIS
    Switches the active config
    
    .DESCRIPTION
    Switches the active config
    
    .PARAMETER ConfigName
    The friendly name of the config you would like to set as active for the session
    
    .PARAMETER Domain
    The domain name for the config you would like to set as active for the session
    
    .PARAMETER SetToDefault
    If passed, also sets the specified config as the default so it's loaded on the next module import
    
    .EXAMPLE
    Switch-PSGSuiteConfig newCustomer

    Switches the config to the "newCustomer" config
    #>
    [CmdletBinding(DefaultParameterSetName = "ConfigName")]
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
        Write-Verbose "Current config is already set to domain '$Domain' --- retaining current config. If you would like to import a different config for the same domain, please use the -ConfigName parameter instead"
        if ($SetToDefault) {
            Write-Verbose "Setting config name '$($script:PSGSuite.ConfigName)' for domain '$($script:PSGSuite.Domain)' as default"
            Set-PSGSuiteConfig -ConfigName $($script:PSGSuite.ConfigName) -SetAsDefaultConfig -Verbose:$false
        }
    }
    elseif ($script:PSGSuite.ConfigName -eq $ConfigName) {
        Write-Verbose "Current config is already set to '$ConfigName' --- retaining current config"
        if ($SetToDefault) {
            Write-Verbose "Setting config name '$($script:PSGSuite.ConfigName)' for domain '$($script:PSGSuite.Domain)' as default"
            Set-PSGSuiteConfig -ConfigName $($script:PSGSuite.ConfigName) -SetAsDefaultConfig -Verbose:$false
        }
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
        $fullConf = Import-SpecificConfiguration -CompanyName 'SCRT HQ' -Name 'PSGSuite' -Scope $Script:ConfigScope -Verbose:$false
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
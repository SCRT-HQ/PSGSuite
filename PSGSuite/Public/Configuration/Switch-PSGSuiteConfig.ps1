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
    [CmdletBinding(DefaultParameterSetName = "ConfigName",PositionalBinding = $false)]
    Param (
        [parameter(Mandatory = $true,ParameterSetName = "Domain")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Domain,
        [parameter(Mandatory = $false)]
        [switch]
        $SetToDefault
    )
    DynamicParam {
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attribute.Position = 0
        $attribute.Mandatory = $true
        $attribute.ParameterSetName = "ConfigName"
        $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attribute)
        $names = Get-PSGSuiteConfigNames -Verbose:$false
        $attributeCollection.Add((New-Object  System.Management.Automation.ValidateSetAttribute($names)))
        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter('ConfigName', [String], $attributeCollection)
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $paramDictionary.Add('ConfigName', $parameter)
        return $paramDictionary
    }
    Process {
        $ConfigName = $PSBoundParameters['ConfigName']
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
                    Select-Object -Property @{l = 'ConfigName';e = { $choice }},
                    @{l = 'P12KeyPath'; e = { Invoke-GSDecrypt $_.P12KeyPath } },
                    'P12Key',
                    @{l = 'P12KeyPassword'; e = { Invoke-GSDecrypt $_.P12KeyPassword } },
                    @{l = 'P12KeyObject'; e = { Invoke-GSDecrypt $_.P12KeyObject } },
                    @{l = 'ClientSecretsPath'; e = { Invoke-GSDecrypt $_.ClientSecretsPath } },
                    @{l = 'ClientSecrets'; e = { Invoke-GSDecrypt $_.ClientSecrets } },
                    @{l = 'AppEmail'; e = {
                            if ($_.AppEmail) {
                                Invoke-GSDecrypt $_.AppEmail
                            }
                            elseif ($_.ClientSecrets) {
                                (Invoke-GSDecrypt $_.ClientSecrets | ConvertFrom-Json).client_email
                            }
                        }
                    },
                    @{l = 'AdminEmail'; e = { Invoke-GSDecrypt $_.AdminEmail } },
                    @{l = 'CustomerID'; e = { Invoke-GSDecrypt $_.CustomerID } },
                    @{l = 'Domain'; e = { Invoke-GSDecrypt $_.Domain } },
                    @{l = 'Preference'; e = { Invoke-GSDecrypt $_.Preference } },
                    @{l = 'ServiceAccountClientID'; e = {
                            if ($_.ServiceAccountClientID) {
                                Invoke-GSDecrypt $_.ServiceAccountClientID
                            }
                            elseif ($_.ClientSecrets) {
                                (Invoke-GSDecrypt $_.ClientSecrets | ConvertFrom-Json).client_id
                            }
                        }
                    },
                    @{l = 'Chat'; e = {
                            $dict = @{
                                Webhooks = @{ }
                                Spaces   = @{ }
                            }
                            foreach ($key in $_.Chat.Webhooks.Keys) {
                                $dict['Webhooks'][$key] = (Invoke-GSDecrypt $_.Chat.Webhooks[$key])
                            }
                            foreach ($key in $_.Chat.Spaces.Keys) {
                                $dict['Spaces'][$key] = (Invoke-GSDecrypt $_.Chat.Spaces[$key])
                            }
                            $dict
                        }
                    },
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
}

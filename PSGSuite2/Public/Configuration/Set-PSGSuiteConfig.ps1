function Set-PSGSuiteConfig {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [ValidateScript( {
                if ($_ -eq "DefaultConfig") {
                    throw "You must specify a ConfigName other than 'DefaultConfig'. That is a reserved value."
                }
                elseif ($_ -notmatch '^[a-zA-Z]+[a-zA-Z0-9]*$') {
                    throw "You must specify a ConfigName that starts with a letter and does not contain any spaces, otherwise the Configuration will break"
                }
                else {
                    $true
                }
            })]
        [string]
        $ConfigName = $Script:ConfigName,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $P12KeyPath,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $ClientSecretsPath,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $AppEmail,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $AdminEmail,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $CustomerID,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $Domain,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [ValidateSet("CustomerID","Domain")]
        [string]
        $Preference,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [string]
        $ServiceAccountClientID,
        [parameter(Mandatory = $false)]
        [ValidateSet("User", "Machine", "Enterprise", $null)]
        [string]
        $Scope = $script:ConfigScope,
        [parameter(Mandatory = $false)]
        [switch]
        $SetAsDefaultConfig,
        [parameter(Mandatory = $false)]
        [switch]
        $NoImport
    )
    Begin {
        Function Encrypt {
            param($string)
            if ($string -is [System.Security.SecureString]) {
                $string
            }
            elseif ($string -is [System.String] -and $String -notlike '') {
                ConvertTo-SecureString -String $string -AsPlainText -Force
            }
        }
        $script:ConfigScope = $Scope
        $params = @{}
        if ($PSBoundParameters.Keys -contains "Verbose") {
            $params["Verbose"] = $PSBoundParameters["Verbose"]
        }
        $configHash = Import-SpecificConfiguration -CompanyName 'SCRT HQ' -Name 'PSGSuite2' @params
        if (!$ConfigName) {
            $ConfigName = if ($configHash["DefaultConfig"]){
                $configHash["DefaultConfig"]
            }
            else {
                "default"
                $configHash["DefaultConfig"] = "default"
            }
        }
        $configParams = @('P12KeyPath','ClientSecretsPath','AppEmail','AdminEmail','CustomerID','Domain','Preference','ServiceAccountClientID')
        if ($SetAsDefaultConfig -or !$configHash["DefaultConfig"]) {
            $configHash["DefaultConfig"] = $ConfigName
        }
        if (!$configHash[$ConfigName]) {
            $configHash.Add($ConfigName,(@{}))
        }
        foreach ($key in ($PSBoundParameters.Keys | Where-Object {$configParams -contains $_})) {
            $configHash["$ConfigName"][$key] = (Encrypt $PSBoundParameters[$key])
        }
        $configHash["$ConfigName"]['ConfigPath'] = (Join-Path $(Get-Module PSGSuite2 | Get-StoragePath -Scope $Script:ConfigScope) "Configuration.psd1")
    }
    Process {
        $configHash | Export-Configuration -CompanyName 'SCRT HQ' -Name 'PSGSuite2' -Scope $script:ConfigScope
    }
    End {
        if (!$NoImport) {
            Get-PSGSuiteConfig -ConfigName $ConfigName -Verbose:$false
        }
    }
}
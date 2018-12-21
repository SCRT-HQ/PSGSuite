function Set-PSGSuiteConfig {
    <#
    .SYNOPSIS
    Creates or updates a config

    .DESCRIPTION
    Creates or updates a config

    .PARAMETER ConfigName
    The friendly name for the config you are creating or updating

    .PARAMETER P12KeyPath
    The path to the P12 Key file downloaded from the Google Developer's Console. If both P12KeyPath and ClientSecretsPath are specified, P12KeyPath takes precedence

    .PARAMETER ClientSecretsPath
    The path to the Client Secrets JSON file downloaded from the Google Developer's Console. Using the ClientSecrets JSON will prompt the user to complete OAuth2 authentication in their browser on the first run and store the retrieved Refresh and Access tokens in the user's home directory. If P12KeyPath is also specified, ClientSecretsPath will be ignored.

    .PARAMETER ClientSecrets
    The string contents of the Client Secrets JSON file downloaded from the Google Developer's Console. Using the ClientSecrets JSON will prompt the user to complete OAuth2 authentication in their browser on the first run and store the retrieved Refresh and Access tokens in the user's home directory. If P12KeyPath is also specified, ClientSecrets will be ignored.

    .PARAMETER AppEmail
    The application email from the Google Developer's Console. This typically looks like the following:

    myProjectName@myProject.iam.gserviceaccount.com

    .PARAMETER AdminEmail
    The email of the Google Admin running the functions. This will typically be your email.

    .PARAMETER CustomerID
    The Customer ID for your customer. If unknown, you can retrieve it by running Get-GSUser after creating a base config with at least either the P12KeyPath or ClientSecretsPath, the AppEmail and the AdminEmail.

    .PARAMETER Domain
    The domain that you primarily manage for this CustomerID

    .PARAMETER Preference
    Some functions allow you to specify whether you are running in the context of the customer or a specific domain in the customer's realm. This allows you to set your preference.

    Available values are:
    * CustomerID
    * Domain

    .PARAMETER ServiceAccountClientID
    The Service Account's Client ID from the Google Developer's Console. This is optional and is only used as a reference for yourself to prevent needing to check the Developer's Console for the ID when verifying API Client Access.

    .PARAMETER Webhook
    Web

    .PARAMETER Scope
    The scope at which you would like to set this config.

    Available values are:
    * Machine (this would create the config in a location accessible by all users on the machine)
    * Enterprise (this would create the config in the Roaming AppData folder for the user or it's *nix equivalent)
    * User (this would create the config in the Local AppData folder for the user or it's *nix equivalent)

    .PARAMETER SetAsDefaultConfig
    If passed, sets the ConfigName as the default config to load on module import

    .PARAMETER NoImport
    The default behavior when using Set-PSGSuiteConfig is that the new/updated config is imported as active. If -NoImport is passed, this saves the config but retains the previously loaded config as active.

    .EXAMPLE
    Set-PSGSuiteConfig -ConfigName "personal" -P12KeyPath C:\Keys\PersonalKey.p12 -AppEmail "myProjectName@myProject.iam.gserviceaccount.com" -AdminEmail "admin@domain.com" -CustomerID "C83030001" -Domain "domain.com" -Preference CustomerID -ServiceAccountClientID 1175798883298324983498 -SetAsDefaultConfig

    This builds a config names "personal" and sets it as the default config
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
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
        $ClientSecrets,
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
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Hashtable[]]
        $Webhook,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Hashtable[]]
        $Space,
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
    }
    Process {
        $script:ConfigScope = $Scope
        $params = @{}
        if ($PSBoundParameters.Keys -contains "Verbose") {
            $params["Verbose"] = $PSBoundParameters["Verbose"]
        }
        $configHash = Import-SpecificConfiguration -CompanyName 'SCRT HQ' -Name 'PSGSuite' @params
        if (!$ConfigName) {
            $ConfigName = if ($configHash["DefaultConfig"]){
                $configHash["DefaultConfig"]
            }
            else {
                "default"
                $configHash["DefaultConfig"] = "default"
            }
        }
        Write-Verbose "Setting config name '$ConfigName'"
        $configParams = @('P12KeyPath','ClientSecretsPath','ClientSecrets','AppEmail','AdminEmail','CustomerID','Domain','Preference','ServiceAccountClientID','Webhook','Space')
        if ($SetAsDefaultConfig -or !$configHash["DefaultConfig"]) {
            $configHash["DefaultConfig"] = $ConfigName
        }
        if (!$configHash[$ConfigName]) {
            $configHash.Add($ConfigName,(@{}))
        }
        foreach ($key in ($PSBoundParameters.Keys | Where-Object {$configParams -contains $_})) {
            switch ($key) {
                ClientSecretsPath {
                    $configHash["$ConfigName"][$key] = (Encrypt $PSBoundParameters[$key])
                    $configHash["$ConfigName"]['ClientSecrets'] = (Encrypt $(Get-Content $PSBoundParameters[$key] -Raw))
                }
                Webhook {
                    if ($configHash["$ConfigName"].Keys -notcontains 'Chat') {
                        $configHash["$ConfigName"]['Chat'] = @{
                            Webhooks = @{}
                            Spaces = @{}
                        }
                    }
                    foreach ($cWebhook in $PSBoundParameters[$key]) {
                        foreach ($cWebhookKey in $cWebhook.Keys) {
                            $configHash["$ConfigName"]['Chat']['Webhooks'][$cWebhookKey] = (Encrypt $cWebhook[$cWebhookKey])
                        }
                    }
                }
                Space {
                    if ($configHash["$ConfigName"].Keys -notcontains 'Chat') {
                        $configHash["$ConfigName"]['Chat'] = @{
                            Webhooks = @{}
                            Spaces = @{}
                        }
                    }
                    $configHash["$ConfigName"]['Chat']['Spaces'] = @{}
                    foreach ($cWebhook in $PSBoundParameters[$key]) {
                        foreach ($cWebhookKey in $cWebhook.Keys) {
                            $configHash["$ConfigName"]['Chat']['Spaces'][$cWebhookKey] = (Encrypt $cWebhook[$cWebhookKey])
                        }
                    }
                }
                default {
                    $configHash["$ConfigName"][$key] = (Encrypt $PSBoundParameters[$key])
                }
            }
        }
        $configHash["$ConfigName"]['ConfigPath'] = (Join-Path $(Get-Module PSGSuite | Get-StoragePath -Scope $Script:ConfigScope) "Configuration.psd1")
        $configHash | Export-Configuration -CompanyName 'SCRT HQ' -Name 'PSGSuite' -Scope $script:ConfigScope
    }
    End {
        if (!$NoImport) {
            Get-PSGSuiteConfig -ConfigName $ConfigName -Verbose:$false
        }
    }
}

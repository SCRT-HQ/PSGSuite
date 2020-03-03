function Get-GSDecryptedConfig {
    [CmdletBinding()]
    Param(
        [parameter(Position = 0,ValueFromPipeline,Mandatory)]
        [object]
        $Config,
        [parameter(Position = 1,Mandatory)]
        [string]
        $ConfigName,
        [parameter(Position = 2)]
        [string]
        $ConfigPath
    )
    Process {
        $Config | Select-Object -Property `
            @{l = 'ConfigName';e = { $ConfigName }},
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
            @{l = 'ConfigPath'; e = {
                if ($ConfigPath) {(Resolve-Path $ConfigPath).Path} elseif ($_.ConfigPath) {$_.ConfigPath} else {$null}
            }}
    }
}
function Invoke-GSDecrypt {
    param($String)
    if ($String -is [System.Security.SecureString]) {
        [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR(
            [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(
                $String
            )
        )
    }
    elseif ($String -is [ScriptBlock]) {
        $String.InvokeReturnAsIs()
    }
    else {
        $String
    }
}

Function Invoke-GSEncrypt {
    param($string)
    if ($string -is [System.String] -and -not [String]::IsNullOrEmpty($String)) {
        ConvertTo-SecureString -String $string -AsPlainText -Force
    }
    else {
        $string
    }
}

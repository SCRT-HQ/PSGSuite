function New-GoogleService {
    <#
    .SYNOPSIS
    Creates a new Google Service object that handles authentication for the scopes specified

    .DESCRIPTION
    Creates a new Google Service object that handles authentication for the scopes specified

    .PARAMETER Scope
    The scope or scopes to build the service with, e.g. https://www.googleapis.com/auth/admin.reports.audit.readonly

    .PARAMETER ServiceType
    The type of service to create, e.g. Google.Apis.Admin.Reports.reports_v1.ReportsService

    .PARAMETER User
    The user to request the service for during the authentication process

    .EXAMPLE
    $serviceParams = @{
        Scope       = 'https://www.googleapis.com/auth/admin.reports.audit.readonly'
        ServiceType = 'Google.Apis.Admin.Reports.reports_v1.ReportsService'
    }
    $service = New-GoogleService @serviceParams

    .LINK
    https://psgsuite.io/Function%20Help/Authentication/New-GoogleService/
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Scope,
        [Parameter(Mandatory = $true,Position = 1)]
        [String]
        $ServiceType,
        [Parameter(Mandatory = $false,Position = 2)]
        [Alias('AdminEmail')]
        [String]
        $User = $script:PSGSuite.AdminEmail
    )
    Begin {
        if (-not $script:_PSGSuiteSessions) {
            $script:_PSGSuiteSessions = @{}
        }
        $sessionKey = @($User,$ServiceType,$(($Scope | Sort-Object) -join ";")) -join ";"
    }
    Process {
        if ($script:_PSGSuiteSessions.ContainsKey($sessionKey)) {
            if (-not $script:_PSGSuiteSessions[$sessionKey].Acknowledged) {
                Write-Verbose "Using matching cached service for user '$User'"
                $script:_PSGSuiteSessions[$sessionKey].Acknowledged = $true
            }
            $script:_PSGSuiteSessions[$sessionKey].LastUsed = Get-Date
            $script:_PSGSuiteSessions[$sessionKey] | Select-Object -ExpandProperty Service
        }
        else {
            if ($script:PSGSuite.JSONServiceAccountKey -or $script:PSGSuite.JSONServiceAccountKeyPath) {
                Write-Verbose "Building ServiceAccountCredential from JSONServiceAccountKey as user '$User'"
                try {
                    if (-not $script:PSGSuite.JSONServiceAccountKey) {
                        $script:PSGSuite.JSONServiceAccountKey = ([System.IO.File]::ReadAllBytes($script:PSGSuite.JSONServiceAccountKeyPath))
                        Set-PSGSuiteConfig -ConfigName $script:PSGSuite.ConfigName -JSONServiceAccountKey $script:PSGSuite.JSONServiceAccountKey -Verbose:$false
                    }
                    $stream = New-Object System.IO.MemoryStream $([System.Text.Encoding]::ASCII.GetBytes($script:PSGSuite.JSONServiceAccountKey)), $null
                    $credential = ([Google.Apis.Auth.OAuth2.GoogleCredential]::FromStream($stream)).CreateWithUser($User).CreateScoped($Scope).UnderlyingCredential
                }
                catch {
                    $PSCmdlet.ThrowTerminatingError($_)
                }
                finally {
                    if ($stream) {
                        $stream.Close()
                    }
                }
            }
            elseif ($script:PSGSuite.P12KeyPath -or $script:PSGSuite.P12Key -or $script:PSGSuite.P12KeyObject) {
                try {
                    Write-Verbose "Building ServiceAccountCredential from P12Key as user '$User'"
                    if ($script:PSGSuite.P12KeyPath -or $script:PSGSuite.P12Key) {
                        if (-not $script:PSGSuite.P12Key) {
                            $script:PSGSuite.P12Key = ([System.IO.File]::ReadAllBytes($script:PSGSuite.P12KeyPath))
                            Set-PSGSuiteConfig -ConfigName $script:PSGSuite.ConfigName -P12Key $script:PSGSuite.P12Key -Verbose:$false
                        }
                        if ($script:PSGSuite.P12KeyPassword) {
                            $P12KeyPassword = $script:PSGSuite.P12KeyPassword
                        }
                        else {
                            $P12KeyPassword = "notasecret"
                        }
                        $certificate = New-Object 'System.Security.Cryptography.X509Certificates.X509Certificate2' -ArgumentList ([System.Byte[]]$script:PSGSuite.P12Key),$P12KeyPassword,([System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
                    }
                    else {
                        $certificate = $script:PSGSuite.P12KeyObject
                    }
                    $credential = New-Object 'Google.Apis.Auth.OAuth2.ServiceAccountCredential' (New-Object 'Google.Apis.Auth.OAuth2.ServiceAccountCredential+Initializer' $script:PSGSuite.AppEmail -Property @{
                            User   = $User
                            Scopes = [string[]]$Scope
                        }
                    ).FromCertificate($certificate)

                }
                catch {
                    $PSCmdlet.ThrowTerminatingError($_)
                }
            }
            elseif ($script:PSGSuite.ClientSecretsPath -or $script:PSGSuite.ClientSecrets) {
                try {
                    $ClientSecretsScopes = @(
                        'https://www.google.com/m8/feeds'
                        'https://mail.google.com'
                        'https://www.googleapis.com/auth/gmail.settings.basic'
                        'https://www.googleapis.com/auth/gmail.settings.sharing'
                        'https://www.googleapis.com/auth/calendar'
                        'https://www.googleapis.com/auth/drive'
                        'https://www.googleapis.com/auth/tasks'
                        'https://www.googleapis.com/auth/tasks.readonly'
                    )
                    if (-not $script:PSGSuite.ClientSecrets) {
                        $script:PSGSuite.ClientSecrets = ([System.IO.File]::ReadAllText($script:PSGSuite.ClientSecretsPath))
                        Set-PSGSuiteConfig -ConfigName $script:PSGSuite.ConfigName -ClientSecrets $script:PSGSuite.ClientSecrets -Verbose:$false
                    }
                    $credPath = Join-Path (Resolve-Path (Join-Path "~" ".scrthq")) "PSGSuite"
                    Write-Verbose "Building UserCredentials from ClientSecrets as user '$User' and prompting for authorization if necessary."
                    $stream = New-Object System.IO.MemoryStream $([System.Text.Encoding]::ASCII.GetBytes(($script:PSGSuite.ClientSecrets))),$null
                    $credential = [Google.Apis.Auth.OAuth2.GoogleWebAuthorizationBroker]::AuthorizeAsync(
                        [Google.Apis.Auth.OAuth2.GoogleClientSecrets]::Load($stream).Secrets,
                        [string[]]$ClientSecretsScopes,
                        $User,
                        [System.Threading.CancellationToken]::None,
                        $(New-Object 'Google.Apis.Util.Store.FileDataStore' -ArgumentList $credPath,$true),
                        $(if ($PSVersionTable.PSVersion.Major -gt 5) {
                                New-Object 'Google.Apis.Auth.OAuth2.PromptCodeReceiver'
                            }
                            else {
                                New-Object 'Google.Apis.Auth.OAuth2.LocalServerCodeReceiver'
                            })
                    ).Result
                }
                catch {
                    $PSCmdlet.ThrowTerminatingError($_)
                }
                finally {
                    if ($stream) {
                        $stream.Close()
                    }
                }
            }
            else {
                $PSCmdlet.ThrowTerminatingError((ThrowTerm "The current config '$($script:PSGSuite.ConfigName)' does not contain a JSONServiceAccountKeyPath, P12KeyPath, or ClientSecretsPath! PSGSuite is unable to build a credential object for the service without a path to a credential file! Please update the configuration to include a path at least one of the three credential types."))
            }
            $svc = New-Object "$ServiceType" (New-Object 'Google.Apis.Services.BaseClientService+Initializer' -Property @{
                    HttpClientInitializer = $credential
                    ApplicationName       = "PSGSuite"
                }
            )
            $script:_PSGSuiteSessions[$sessionKey] = ([PSCustomObject]@{
                User         = $User
                Scope        = $Scope
                Service      = $svc
                Issued       = Get-Date
                LastUsed     = Get-Date
                Acknowledged = $false
            })
            return $svc
        }
    }
}

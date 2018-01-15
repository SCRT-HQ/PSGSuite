function New-GoogleService {
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
        [String]
        $User = $script:PSGSuite.AdminEmail
    )
    Process {
        try {
            if ($script:PSGSuite.P12KeyPath) {
                Write-Verbose "Building ServiceAccountCredential from P12Key as user '$User'"
                $certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new((Resolve-Path $script:PSGSuite.P12KeyPath).Path,"notasecret",[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
                $credential = New-Object 'Google.Apis.Auth.OAuth2.ServiceAccountCredential' (New-Object 'Google.Apis.Auth.OAuth2.ServiceAccountCredential+Initializer' $script:PSGSuite.AppEmail -Property @{
                        User   = $User
                        Scopes = [string[]]$Scope
                    }
                ).FromCertificate($certificate)
            }
            elseif ($script:PSGSuite.ClientSecretsPath) {
                Write-Verbose "Building UserCredentials from ClientSecrets as user '$User'"
                $stream = New-Object System.IO.FileStream $script:PSGSuite.ClientSecretsPath,'Open','Read'
                $credPath = Join-Path (Resolve-Path (Join-Path "~" ".scrthq")) "PSGSuite"
                $credential = [Google.Apis.Auth.OAuth2.GoogleWebAuthorizationBroker]::AuthorizeAsync(
                    [Google.Apis.Auth.OAuth2.GoogleClientSecrets]::Load($stream).Secrets,
                    [string[]]$Scope,
                    $User,
                    [System.Threading.CancellationToken]::None,
                    [Google.Apis.Util.Store.FileDataStore]::new($credPath,$true)
                ).Result
            }
            else {
                $PSCmdlet.ThrowTerminatingError((ThrowTerm "The current config '$($script:PSGSuite.ConfigName)' does not contain a P12KeyPath or a ClientSecretsPath! PSGSuite is unable to build a credential object for the service without a path to a credential file! Please update the configuration to include a path at least one of the two credential types."))
            }
            New-Object "$ServiceType" (New-Object 'Google.Apis.Services.BaseClientService+Initializer' -Property @{
                    HttpClientInitializer = $credential
                    ApplicationName       = "PSGSuite - $env:USERNAME"
                }
            )
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}
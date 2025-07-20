function New-GoogleServiceAccountCredential {
    <#
    .SYNOPSIS
    Creates a new Google ServiceAccountCredential object for use with the Service-Account-JSON-Key and Service-Account-P12-Key authentication methods. The credential object is used to authenticate PSGSuite to Google.

    .DESCRIPTION
    Creates a new Google ServiceAccountCredential object for use with the Service-Account-JSON-Key and Service-Account-P12-Key authentication methods. The credential object is used to authenticate PSGSuite to Google.

    .PARAMETER Scope
    The scope or scopes that will be accessed with the ServiceAccountCredential, e.g. https://www.googleapis.com/auth/admin.reports.audit.readonly

    .PARAMETER User
    The user that is being impersonated by the service account.

    .EXAMPLE
    $CredentialParams = @{
        Scope   = 'https://www.googleapis.com/auth/admin.reports.audit.readonly'
        User    = 'user@email.com'
    }
    $Credential = New-GoogleServiceAccountCredential @CredentialParams

    #>
    [OutputType('Google.Apis.Auth.OAuth2.ServiceAccountCredential')]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Scope,
        [Parameter(Mandatory = $true,Position = 1)]
        [String]
        $User
    )


    $AuthMethod = Get-PSGSuiteAuthenticationMethod
    Switch ($AuthMethod){

        'Service-Account-JSON-Key' {
            Write-Verbose "Building ServiceAccountCredential from JSONServiceAccountKey as user '$User'"
            try {
                if (-not $script:PSGSuite.JSONServiceAccountKey) {
                    $script:PSGSuite.JSONServiceAccountKey = ([System.IO.File]::ReadAllBytes($script:PSGSuite.JSONServiceAccountKeyPath))
                    Set-PSGSuiteConfig -ConfigName $script:PSGSuite.ConfigName -JSONServiceAccountKey $script:PSGSuite.JSONServiceAccountKey -Verbose:$false
                }
                $stream = New-Object System.IO.MemoryStream $([System.Text.Encoding]::ASCII.GetBytes($script:PSGSuite.JSONServiceAccountKey)), $null
                ([Google.Apis.Auth.OAuth2.GoogleCredential]::FromStream($stream)).CreateWithUser($User).CreateScoped($Scope).UnderlyingCredential
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

        'Service-Account-P12-Key' {
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
                New-Object 'Google.Apis.Auth.OAuth2.ServiceAccountCredential' (New-Object 'Google.Apis.Auth.OAuth2.ServiceAccountCredential+Initializer' $script:PSGSuite.AppEmail -Property @{
                        User   = $User
                        Scopes = [string[]]$Scope
                    }
                ).FromCertificate($certificate)

            }
            catch {
                $PSCmdlet.ThrowTerminatingError($_)
            }
        }

        Default {
            $PSCmdlet.ThrowTerminatingError((ThrowTerm "Unable to create ServiceAccountCredential. PSGSuite is not currently configured for Service-Account-JSON-Key or Service-Account-P12-Key authentication."))
        }
    }

}
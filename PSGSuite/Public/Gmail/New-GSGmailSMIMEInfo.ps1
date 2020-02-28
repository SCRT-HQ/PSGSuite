function New-GSGmailSMIMEInfo {
    <#
    .SYNOPSIS
    Adds Gmail S/MIME info

    .DESCRIPTION
    Adds Gmail S/MIME info

    .PARAMETER SendAsEmail
    The email address that appears in the "From:" header for mail sent using this alias.

    .PARAMETER Pkcs12
    PKCS#12 format containing a single private/public key pair and certificate chain. This format is only accepted from client for creating a new SmimeInfo and is never returned, because the private key is not intended to be exported. PKCS#12 may be encrypted, in which case encryptedKeyPassword should be set appropriately.

    .PARAMETER EncryptedKeyPassword
    Encrypted key password, when key is encrypted.

    .PARAMETER IsDefault
    Whether this SmimeInfo is the default one for this user's send-as address.

    .PARAMETER User
    The user's email address

    .EXAMPLE
    New-GSGmailSMIMEInfo -SendAsEmail 'joe@otherdomain.com' -Pkcs12 .\MyCert.pfx -User joe@domain.com

    Creates a specified S/MIME for Joe's SendAsEmail 'joe@otherdomain.com' using the provided PKCS12 certificate
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.SmimeInfo')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $SendAsEmail,
        [parameter(Mandatory = $true)]
        [ValidateScript( {
                if (!(Test-Path $_)) {
                    throw "Please enter a valid file path."
                }
                elseif ($_ -notlike "*.pfx" -and $_ -notlike "*.p12") {
                    throw "Pkcs12 must be a .pfx or .p12 file"
                }
                else {
                    $true
                }
            })]
        [string]
        $Pkcs12,
        [parameter(Mandatory = $false)]
        [SecureString]
        $EncryptedKeyPassword,
        [parameter(Mandatory = $false)]
        [Switch]
        $IsDefault,
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User
    )
    Process {
        Resolve-Email ([Ref]$User)
        $serviceParams = @{
            Scope       = @(
                'https://www.googleapis.com/auth/gmail.settings.basic'
                'https://www.googleapis.com/auth/gmail.settings.sharing'
            )
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        try {
            $body = New-Object 'Google.Apis.Gmail.v1.Data.SmimeInfo'
            foreach ($key in $PSBoundParameters.Keys | Where-Object { $body.PSObject.Properties.Name -contains $_ }) {
                switch ($key) {
                    EncryptedKeyPassword {
                        $pw = (New-Object PSCredential "user", $PSBoundParameters[$key]).GetNetworkCredential().Password
                        $body.EncryptedKeyPassword = $pw
                    }
                    Pkcs12 {
                        $pkcs12Content = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($Pkcs12))
                        $urlSafePkcs12Content = $pkcs12Content.Replace('+', '-').Replace('/', '_')
                        $body.Pkcs12 = $urlSafePkcs12Content
                    }
                    Default {
                        $body.$key = $PSBoundParameters[$key]
                    }
                }
            }
            Write-Verbose "Adding new S/MIME of SendAsEmail '$SendAsEmail' for user '$User' using Certificate '$Pkcs12'"
            $request = $service.Users.Settings.SendAs.SmimeInfo.Insert($body, $User, $SendAsEmail)
            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
        }
        catch {
            if ($ErrorActionPreference -eq 'Stop') {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            else {
                Write-Error $_
            }
        }
    }
}

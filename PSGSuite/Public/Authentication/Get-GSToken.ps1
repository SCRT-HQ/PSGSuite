function Get-GSToken {
    <#
    .Synopsis
    Requests an Access Token for REST API authentication. Defaults to 3600 seconds token expiration time.

    .DESCRIPTION
    Requests an Access Token for REST API authentication. Defaults to 3600 seconds token expiration time.

    .EXAMPLE
    $Token = Get-GSToken -Scopes 'https://www.google.com/m8/feeds' -AdminEmail $User
    $headers = @{
        Authorization = "Bearer $($Token)"
        'GData-Version' = '3.0'
    }
    #>
    Param
    (
        [parameter(Mandatory = $true)]
        [Alias('Scope')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Scopes,
        [parameter(Mandatory = $false)]
        [Alias('User')]
        [ValidateNotNullOrEmpty()]
        [String]
        $AdminEmail = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [Switch]
        $UseRest
    )
    if ($UseRest) {
        function Invoke-URLEncode ($Object) {
            ([String]([System.Convert]::ToBase64String($Object))).TrimEnd('=').Replace('+','-').Replace('/','_')
        }
        $googleCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2("$($Script:PSGSuite.P12KeyPath)", "notasecret",[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable )
        $rsaPrivate = $googleCert.PrivateKey
        $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
        $rsa.ImportParameters($rsaPrivate.ExportParameters($true))
        $rawheader = [Ordered]@{
            alg = "RS256"
            typ = "JWT"
        } | ConvertTo-Json -Compress
        $header = Invoke-URLEncode ([System.Text.Encoding]::UTF8.GetBytes($rawheader))
        [string]$now = Get-Date (Get-Date).ToUniversalTime() -UFormat "%s"
        [int]$createDate = $now -replace "(\..*|\,.*)"
        [int]$expiryDate = $createDate + 3600
        $rawclaims = [Ordered]@{
            iss   = "$($Script:PSGSuite.AppEmail)"
            sub   = "$($Script:PSGSuite.AdminEmail)"
            scope = "$($Scopes -join " ")"
            aud   = "https://www.googleapis.com/oauth2/v4/token"
            exp   = "$expiryDate"
            iat   = "$createDate"
        } | ConvertTo-Json
        $claims = Invoke-URLEncode ([System.Text.Encoding]::UTF8.GetBytes($rawclaims))
        $toSign = [System.Text.Encoding]::UTF8.GetBytes($header + "." + $claims)
        $sig = Invoke-URLEncode ($rsa.SignData($toSign,"SHA256"))
        $jwt = $header + "." + $claims + "." + $sig
        $fields = [Ordered]@{
            grant_type = 'urn:ietf:params:oauth:grant-type:jwt-bearer'
            assertion  = $jwt
        }
        try {
            Write-Verbose "Acquiring access token via REST API..."
            $response = Invoke-RestMethod -Uri "https://www.googleapis.com/oauth2/v4/token" -Method Post -Body $fields -ContentType "application/x-www-form-urlencoded" -ErrorAction Stop -Verbose:$false
            Write-Verbose "Access token acquired!"
            return $response
        }
        catch {
            Write-Verbose "Failed to acquire access token!"
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
    else {
        try {
            Write-Verbose "Acquiring access token via .NET SDK..."
            $serviceParams = @{
                Scope       = $Scopes
                ServiceType = 'Google.Apis.Gmail.v1.GmailService'
                User        = $AdminEmail
            }
            $service = New-GoogleService @serviceParams
            ($service.HttpClientInitializer.GetAccessTokenForRequestAsync()).Result
        }
        catch {
            Write-Verbose "Failed to acquire access token!"
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}

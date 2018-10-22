function Get-GSToken {
    <#
    .Synopsis
    Gets a Service Account Access Token from Google Apps
    .DESCRIPTION
    Requests Access Token using Service Account and P12 key file, returns the token directly. Defaults to 3600 seconds token expiration time.
    .EXAMPLE
    $token = Get-GSToken -P12KeyPath "C:\PSGoogle.p12" -Scopes "https://www.googleapis.com/auth/admin.directory.user" -AppEmail "psg@nf.iam.gserviceaccount.com" -AdminEmail "google.admin.account@domain.com"
    .EXAMPLE
    $token = Get-GSToken
    #>
    Param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Scopes,
        [parameter(Mandatory = $false)]
        [Alias('User')]
        [ValidateNotNullOrEmpty()]
        [String]
        $AdminEmail = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AppEmail = $Script:PSGSuite.AppEmail,
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $P12KeyPath = $Script:PSGSuite.P12KeyPath
    )
    function Invoke-URLEncode ($Object) {
        ([String]([System.Convert]::ToBase64String($Object))).TrimEnd('=').Replace('+','-').Replace('/','_')
    }
    $googleCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2("$P12KeyPath", "notasecret",[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable )
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
        iss   = "$AppEmail"
        sub   = "$AdminEmail"
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
        Write-Verbose "Acquiring access token..."
        $response = Invoke-RestMethod -Uri "https://www.googleapis.com/oauth2/v4/token" -Method Post -Body $fields -ContentType "application/x-www-form-urlencoded" -ErrorAction Stop -Verbose:$false | Select-Object -ExpandProperty access_token
        Write-Verbose "Access token acquired!"
        return $response
    }
    catch {
        Write-Verbose "Failed to acquire access token!"
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

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
      [parameter(Mandatory=$false,HelpMessage="What is the full path to your Google Service Account's P12 key file?")]
      [ValidateNotNullOrEmpty()]
      [String]
      $P12KeyPath = $Script:PSGSuite.P12KeyPath,
      [parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string[]]
      $Scopes,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AppEmail = $Script:PSGSuite.AppEmail,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AdminEmail = $Script:PSGSuite.AdminEmail
    )
$NugetDir="$ModuleRoot\nuget"
Add-Type -Path "$NugetDir\owin.1.0.0\lib\net40\Owin.dll"
Add-Type -Path "$NugetDir\microsoft.owin.3.0.1\lib\net45\Microsoft.Owin.dll"
Add-Type -Path "$NugetDir\microsoft.owin.security.3.0.1\lib\net45\Microsoft.Owin.Security.dll"
$encoder = New-Object Microsoft.Owin.Security.DataHandler.Encoder.Base64UrlTextEncoder
$googleCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2("$P12KeyPath", "notasecret",[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable )
$rsaPrivate = $googleCert.PrivateKey
$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
$rsa.ImportParameters($rsaPrivate.ExportParameters($true))
$rawheader = [Ordered]@{
    alg = "RS256"
    typ = "JWT"
} | ConvertTo-Json -Compress
$header = $encoder.Encode([System.Text.Encoding]::UTF8.GetBytes($rawheader))
$now = (Get-Date).ToUniversalTime()
$createDate = [Math]::Floor([decimal](Get-Date($now) -UFormat "%s"))
$expiryDate = [Math]::Floor([decimal](Get-Date($now.AddMinutes(59)) -UFormat "%s"))
$rawclaims = [Ordered]@{
    iss = "$AppEmail"
    sub = "$AdminEmail"
    scope = "$($Scopes -join " ")"
    aud = "https://www.googleapis.com/oauth2/v4/token"
    exp = "$expiryDate"
    iat = "$createDate"
} | ConvertTo-Json
$claims = $encoder.Encode([System.Text.Encoding]::UTF8.GetBytes($rawclaims))
$toSign = [System.Text.Encoding]::UTF8.GetBytes($header + "." + $claims)
$sig = $encoder.Encode($rsa.SignData($toSign,"SHA256"))
$jwt = $header + "." + $claims + "." + $sig
$fields = [Ordered]@{grant_type='urn:ietf:params:oauth:grant-type:jwt-bearer';assertion=$jwt}
try
    {
    Write-Verbose "Acquiring access token..."
    $response = Invoke-RestMethod -Uri "https://www.googleapis.com/oauth2/v4/token" -Method Post -Body $fields -ContentType "application/x-www-form-urlencoded" -ErrorAction Stop -Verbose:$false | Select-Object -ExpandProperty access_token
    Write-Verbose "Access token acquired!"
    return $response
    }
catch
    {
    Write-Verbose "Failed to acquire access token!"
    $result = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($result)
    $reader.BaseStream.Position = 0
    $reader.DiscardBufferedData()
    $response = $reader.ReadToEnd() | 
        ConvertFrom-Json | 
        Select-Object @{N="WebError";E={$Error[0]}},@{N="Code";E={"401"}},@{N="Error";E={$_.error}},@{N="Description";E={$_.error_description}}
    Write-Error "$($MyInvocation.MyCommand) : $(Get-HTTPStatus -Code $response.Code): $($response.Error) / $($response.Description)"
    return
    }
}
function Get-GoogToken {
<#
.Synopsis
   Gets a Service Account Access Token from Google Apps
.DESCRIPTION
   Requests Access Token using Service Account and P12 key file, returns the token directly. Defaults to 3600 seconds token expiration time.
.EXAMPLE
   $token = Get-GoogToken -P12KeyPath "C:\PSGoogle.p12" -Scopes "https://www.googleapis.com/auth/admin.directory.user" -AppEmail "psg@nf.iam.gserviceaccount.com" -AdminEmail "google.admin.account@domain.com"
.EXAMPLE
   $token = Get-GoogToken
#>

    Param
    (
      [parameter(Mandatory=$false,HelpMessage="What is the full path to your Google Service Account's P12 key file?")]
      [ValidateNotNullOrEmpty()]
      [String]
      $P12KeyPath = $Script:PSGoogle.P12KeyPath,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string[]]
      $Scopes = $($Script:PSGoogle.Scopes -split ","),
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AppEmail = $Script:PSGoogle.AppEmail,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AdminEmail = $Script:PSGoogle.AdminEmail
    )
#MS Owin for base64url encoding
$NugetDir="$(Get-Module PSGoogle | Select-Object -ExpandProperty ModuleBase)\nuget"
Add-Type -Path "$NugetDir\owin.1.0.0\lib\net40\Owin.dll"
Add-Type -Path "$NugetDir\microsoft.owin.3.0.1\lib\net45\Microsoft.Owin.dll"
Add-Type -Path "$NugetDir\microsoft.owin.security.3.0.1\lib\net45\Microsoft.Owin.Security.dll"
     
# get a base64url encoder object
$encoder = New-Object Microsoft.Owin.Security.DataHandler.Encoder.Base64UrlTextEncoder

# get our certificate we'll use to sign the jwt
# http://stackoverflow.com/questions/23501320/signing-data-with-google-service-account-private-key-fails
 
$googleCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2("$P12KeyPath", "notasecret",[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable )
    
 
# get just the private key
$rsaPrivate = $googleCert.PrivateKey
 
# get a new RSA provider
$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
 
# copy the parameters from the private key into our new rsa provider
$rsa.ImportParameters($rsaPrivate.ExportParameters($true))

## header
 
# jwtheaders are the same for every request
# {"alg":"RS256","typ":"JWT"}
 
$rawheader = [Ordered]@{
    alg = "RS256"
    typ = "JWT"
} | ConvertTo-Json -Compress
 
# we then serialize to UTF-8 bytes, then base64url encode the header
$header = $encoder.Encode([System.Text.Encoding]::UTF8.GetBytes($rawheader))

## claims
# iss The email address of the service account.
# scope A SPACE-delimited list of the permissions that the application requests.
# aud A descriptor of the intended target of the assertion. When making an access token request this value is always https://accounts.google.com/o/oauth2/token.
# sub The email address of the user for which the application is requesting delegated access
# exp The expiration time of the assertion, specified as seconds since 00:00:00 UTC, January 1, 1970. This value has a maximum of 1 hour after the issued time.
# iat The time the assertion was issued, specified as seconds since 00:00:00 UTC, January 1, 1970.
 
# dates are all in UTC
# expiration is one hour from creation, unix epoch,
 
$now = (Get-Date).ToUniversalTime()
$createDate = [Math]::Floor([decimal](Get-Date($now) -UFormat "%s"))
$expiryDate = [Math]::Floor([decimal](Get-Date($now.AddMinutes(59)) -UFormat "%s"))
 
# claims set.
# Google's documentation isn't clear on the sub field. It reads as if you'll only need it if you're acting on behalf of a user.
# In reality, the admin sdk apis all need to impersonate a real admin.
 
$rawclaims = [Ordered]@{
    iss = "$AppEmail"
    sub = "$AdminEmail"
    scope = "$($Scopes -join " ")"
    aud = "https://www.googleapis.com/oauth2/v4/token"
    exp = "$expiryDate"
    iat = "$createDate"
} | ConvertTo-Json
 
# we then serialize to UTF-8 bytes, then base64url encode the claims
$claims = $encoder.Encode([System.Text.Encoding]::UTF8.GetBytes($rawclaims))

# signature is our base64urlencoded header and claims, seperated by a .
# we then serialize that to utf8
 
$toSign = [System.Text.Encoding]::UTF8.GetBytes($header + "." + $claims)
 
# sign the sig, we then serialize to UTF-8 bytes, then base64url encode the signature
 
$sig = $encoder.Encode($rsa.SignData($toSign,"SHA256"))

## jwt
 
# jwt is the header, claims and signature, separated by a period
 
$jwt = $header + "." + $claims + "." + $sig
  
## request
 
$fields = [Ordered]@{grant_type='urn:ietf:params:oauth:grant-type:jwt-bearer';assertion=$jwt}

#$fields = "grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=$jwt"
 
try
    {
    Write-Verbose "Acquiring token..."
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
    throw "$($MyInvocation.MyCommand) : $(Get-HTTPStatus -Code $response.Code): $($response.Error) / $($response.Description)"
    }
}
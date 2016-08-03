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
  [parameter(Mandatory=$true,HelpMessage="What is the full path to your Google Service Account's P12 key file?")]
  [String]
  $P12KeyPath,

  [parameter(Mandatory=$true)]
  [String[]]
  $Scopes,

  [parameter(Mandatory=$true)]
  [String]
  $AppEmail,

  [parameter(Mandatory=$true)]
  [String]
  $AdminEmail
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

Write-Verbose "rsaPrivate: $rsaPrivate
"
 
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

Write-Verbose "header: $header
"

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

Write-Verbose "createDate: $createDate
expiryDate: $expiryDate
"
 
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

Write-Verbose "jwt: $jwt
"
 
 
## request
 
$fields = [Ordered]@{grant_type='urn:ietf:params:oauth:grant-type:jwt-bearer';assertion=$jwt}

#$fields = "grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=$jwt"
 
try
    {
    $response = Invoke-RestMethod -Uri "https://www.googleapis.com/oauth2/v4/token" -Method Post -Body $fields -ContentType "application/x-www-form-urlencoded" -ErrorAction Stop
    return $response | Select-Object -ExpandProperty access_token
    }
catch
    {
    throw $Error[0]
    }
}

function Get-GoogUserList {
<#
.Synopsis
   Gets the user list for a given account in Google Apps
.DESCRIPTION
   Retrieves the full user list for the entire account. Accepts standard Google queries as a string or array of strings.
.EXAMPLE
   Get-GoogUserList -AccessToken $(Get-GoogToken @TokenParams) -MaxResults 300 -Query "orgUnitPath=/Users","email=domain.user2@domain.com"
.EXAMPLE
   Get-GoogUserList -AccessToken $(Get-GoogToken @TokenParams)
#>
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$false)]
      [String]
      $CustomerID="my_customer",
      [parameter(Mandatory=$false)]
      [String]
      $Domain,
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 500})]
      [Int]
      $MaxResults="500",
      [parameter(Mandatory=$false)]
      [ValidateSet("Email","GivenName","FamilyName")]
      [String]
      $OrderBy,
      [parameter(Mandatory=$false)]
      [ValidateSet("Ascending","Descending")]
      [String]
      $SortOrder,
      [parameter(Mandatory=$false)]
      [String[]]
      $Query
    )

$header = @{Authorization="Bearer $AccessToken"}

if ($Domain)
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/users?domain=$Domain"
    }
else
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/users?customer=$CustomerID"
    }

if ($MaxResults){$URI = "$URI&maxResults=$MaxResults"}
if ($OrderBy){$URI = "$URI&orderBy=$OrderBy"}
if ($SortOrder){$URI = "$URI&sortOrder=$SortOrder"}
if ($Query)
    {
    $Query = $($Query -join " ")
    $URI = "$URI&query=$Query"
    }

Write-Verbose "Constructed URI: $URI"

$results = @()
[int]$i=1
do
    {
    if ($i -eq 1)
        {
        $users = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
        }
    else
        {
        $users = Invoke-RestMethod -Method Get -Uri "$URI&pageToken=$pageToken" -Headers $header -Verbose:$false
        }
    $results += $users.users
    $pageToken="$($users.nextPageToken)"
    [int]$retrieved = ($i + $users.users.Count) - 1
    Write-Verbose "Retrieved users $i - $retrieved..."
    [int]$i = $i + $users.users.Count
    }
until 
    ($users.users.Count -lt $MaxResults)

return $results
}

function Get-GoogGroupList {
<#
.Synopsis
   Gets the group list for a given account in Google Apps
.DESCRIPTION
   Retrieves the full group list for the entire account
.EXAMPLE
   Get-GoogGroupList -AccessToken $(Get-GoogToken @TokenParams) -MaxResults 5 -Where_IsAMember "random-user@domain.com"
.EXAMPLE
   Get-GoogGroupList -AccessToken $(Get-GoogToken @TokenParams)
#>
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$false)]
      [String]
      $CustomerID="my_customer",
      [parameter(Mandatory=$false)]
      [String]
      $Domain,
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 200})]
      [Int]
      $MaxResults="200",
      [parameter(Mandatory=$false)]
      [String]
      $Where_IsAMember
    )

$header = @{Authorization="Bearer $AccessToken"}

if ($Where_IsAMember)
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/groups?userKey=$($Where_IsAMember)"
    }
else
    {
    if ($Domain)
        {
        $URI = "https://www.googleapis.com/admin/directory/v1/groups?domain=$Domain"
        }
    else
        {
        $URI = "https://www.googleapis.com/admin/directory/v1/groups?customer=$CustomerID"
        }
    }


if ($MaxResults){$URI = "$URI&maxResults=$MaxResults"}

Write-Verbose "Constructed URI: $URI"

$results = @()
[int]$i=1
do
    {
    if ($i -eq 1)
        {
        $result = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
        }
    else
        {
        $result = Invoke-RestMethod -Method Get -Uri "$URI&pageToken=$pageToken" -Headers $header -Verbose:$false
        }
    $results += $result.groups
    $pageToken="$($result.nextPageToken)"
    [int]$retrieved = ($i + $result.groups.Count) - 1
    Write-Verbose "Retrieved groups $i - $retrieved..."
    [int]$i = $i + $result.groups.Count
    }
until 
    ($result.groups.Count -lt $MaxResults)

return $results
}

function Get-GoogOrgUnitList {
<#
.Synopsis
   Gets the OrgUnit list for a given account in Google Apps
.DESCRIPTION
   Retrieves the full OrgUnit list for the entire account. Allows filtering by BaseOrgUnitPath (SearchBase) and Type (SearchScope)
.EXAMPLE
   Get-GoogOrgUnitList -AccessToken $(Get-GoogToken @TokenParams) -CustomerID C22jaaesx -BaseOrgUnitPath "/Users" -Type Children
.EXAMPLE
   Get-GoogOrgUnitList -AccessToken $(Get-GoogToken @TokenParams) -CustomerID c22jaaesx
#>
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$true)]
      [String]
      $CustomerID,
      [parameter(Mandatory=$false)]
      [Alias("SearchBase")]
      [String]
      $BaseOrgUnitPath,
      [parameter(Mandatory=$false)]
      [Alias("SearchScope")]
      [ValidateSet("All","Children")]
      [String]
      $Type="All"
    )

$header = @{Authorization="Bearer $AccessToken"}

$URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/orgunits"



if ($BaseOrgUnitPath -and $Type){$URI = "$URI`?&orgUnitPath=$BaseOrgUnitPath&type=$Type"}
elseif ($BaseOrgUnitPath -and !$Type){$URI = "$URI`?&orgUnitPath=$BaseOrgUnitPath"}
elseif (!$BaseOrgUnitPath -and $Type){$URI = "$URI`?type=$Type"}

Write-Verbose "Constructed URI: $URI"

$results = @()
$result = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
$results += $result.organizationUnits
Write-Verbose "Retrieved organizationUnits $i - $($result.organizationUnits.Count)..."

return $results
}

function Get-GoogResourceCalList {
<#
.Synopsis
   Gets the resource calendar list for a given account in Google Apps
.DESCRIPTION
   Retrieves the full resource calendar list for the entire account. 
.EXAMPLE
   Get-GoogResourceCalList -AccessToken $(Get-GoogToken @TokenParams) -CustomerID C22jaaesx -BaseOrgUnitPath "/Users" -Type Children
.EXAMPLE
   Get-GoogResourceCalList -AccessToken $(Get-GoogToken @TokenParams) -CustomerID c22jaaesx
#>
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$true)]
      [String]
      $CustomerID,
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 500})]
      [Int]
      $MaxResults="500"
    )

$header = @{Authorization="Bearer $AccessToken"}

$URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/resources/calendars"

if ($MaxResults){$URI = "$URI`?&MaxResults=$MaxResults"}

Write-Verbose "Constructed URI: $URI"

$results = @()
[int]$i=1
do
    {
    if ($i -eq 1)
        {
        $result = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
        }
    else
        {
        $result = Invoke-RestMethod -Method Get -Uri "$URI&pageToken=$pageToken" -Headers $header -Verbose:$false
        }
    $results += $result.items
    $pageToken="$($result.nextPageToken)"
    [int]$retrieved = ($i + $result.items.Count) - 1
    Write-Verbose "Retrieved resources $i - $retrieved..."
    [int]$i = $i + $result.items.Count
    }
until 
    ($result.items.Count -lt $MaxResults)

return $results
}

function Get-GoogGroupMembers {
<#
.Synopsis
   Gets the group member list for a given group in Google Apps
.DESCRIPTION
   Retrieves the full group list for the entire account
.EXAMPLE
   Get-GoogGroupMembers -AccessToken $(Get-GoogToken @TokenParams) -GroupEmail "my.group@domain.com" -MaxResults 10
.EXAMPLE
   Get-GoogGroupMembers -AccessToken $(Get-GoogToken @TokenParams)
#>
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$true)]
      [String]
      $GroupEmail,
      [parameter(Mandatory=$false)]
      [ValidateSet("Owner","Manager","Member")]
      [String[]]
      $Roles,
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 200})]
      [Int]
      $MaxResults="200"
    )

$header = @{Authorization="Bearer $AccessToken"}

$URI = "https://www.googleapis.com/admin/directory/v1/groups/$($GroupEmail)/members"

if ($Roles){$URI = "$URI`?roles=$($Roles -join ",")"}
if ($Roles -and $MaxResults){$URI = "$URI&maxResults=$MaxResults"}
elseif ($MaxResults){$URI = "$URI`?&maxResults=$MaxResults"}

Write-Verbose "Constructed URI: $URI"

$results = @()
[int]$i=1
do
    {
    if ($i -eq 1)
        {
        $result = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
        }
    else
        {
        $result = Invoke-RestMethod -Method Get -Uri "$URI&pageToken=$pageToken" -Headers $header -Verbose:$false
        }
    $results += $result.members
    $pageToken="$($result.nextPageToken)"
    [int]$retrieved = ($i + $result.members.Count) - 1
    Write-Verbose "Retrieved groups $i - $retrieved..."
    [int]$i = $i + $result.members.Count
    }
until 
    ($result.members.Count -lt $MaxResults)

return $results
}




<### still working on these ones, do not reveal please

function Update-GoogUser {
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$true)]
      [String]
      $UserKey,
      [parameter(Mandatory=$false)]
      [String]
      $Domain,
      [parameter(Mandatory=$false)]
      [String]
      $MaxResults="500",
      [parameter(Mandatory=$false)]
      [ValidateSet("Email","GivenName","FamilyName")]
      [String]
      $OrderBy,
      [parameter(Mandatory=$false)]
      [ValidateSet("Ascending","Descending")]
      [String]
      $SortOrder,
      [parameter(Mandatory=$false)]
      [String[]]
      $Query
    )

$header = @{Authorization="Bearer $AccessToken"}

if ($Domain)
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/users?domain=$Domain"
    }
else
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/users?customer=$CustomerID"
    }

if ($MaxResults){$URI = "$URI&maxResults=$MaxResults"}
if ($OrderBy){$URI = "$URI&orderBy=$OrderBy"}
if ($SortOrder){$URI = "$URI&sortOrder=$SortOrder"}
if ($Query)
    {
    $Query = $($Query -join " ")
    $URI = "$URI&query=$Query"
    }

Write-Verbose "Constructed URI: $URI"

$results = @()
[int]$i=1
do
    {
    if ($i -eq 1)
        {
        $users = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
        }
    else
        {
        $users = Invoke-RestMethod -Method Get -Uri "$URI&pageToken=$pageToken" -Headers $header -Verbose:$false
        }
    $results += $users.users
    $pageToken="$($users.nextPageToken)"
    [int]$retrieved = ($i + $users.users.Count) - 1
    Write-Verbose "Retrieved users $i - $retrieved..."
    [int]$i = $i + $users.users.Count
    }
until 
    ($users.users.Count -lt $MaxResults)

return $results
}

#>
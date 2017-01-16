function Update-GSUser {
<#
.Synopsis
   Updates an existing Google user
.DESCRIPTION
   Updates an existing Google user
.EXAMPLE
   Update-GSUser -User john.smith@domain.com -PrimaryEmail johnathan.smith@domain.com -GivenName Johnathan -Suspended False
#>
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true,Position=0)]
      [String]
      $User,
      [parameter(Mandatory=$false)]
      [String]
      $PrimaryEmail,
      [parameter(Mandatory=$false)]
      [String]
      $GivenName,
      [parameter(Mandatory=$false)]
      [String]
      $FamilyName,
      [parameter(Mandatory=$false)]
      [String]
      $Password,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [string]
      $ChangePasswordAtNextLogin,
      [parameter(Mandatory=$false)]
      [String]
      $OrgUnitPath,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $Suspended,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $IncludeInGlobalAddressList,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $IPWhitelisted,
      [parameter(Mandatory=$false)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $P12KeyPath = $Script:PSGSuite.P12KeyPath,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AppEmail = $Script:PSGSuite.AppEmail,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AdminEmail = $Script:PSGSuite.AdminEmail
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.user" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$body = @{}
if($PrimaryEmail){$body.Add("primaryEmail",$PrimaryEmail)}
if($Password){$body.Add("password",$Password)}
if ($GivenName -or $FamilyName)
    {
    $name = @{}
    if ($GivenName){$name.Add("givenName",$GivenName)}
    if ($FamilyName){$name.Add("familyName",$FamilyName)}
    $body.Add("name",$name)
    }

if($OrgUnitPath){$body.Add("orgUnitPath",$OrgUnitPath)}
if($ChangePasswordAtNextLogin -eq $true -or $ChangePasswordAtNextLogin -eq $false){$body.Add("changePasswordAtNextLogin",$ChangePasswordAtNextLogin)}
if($Suspended -eq $true -or $Suspended -eq $false){$body.Add("suspended",$Suspended)}
if($IncludeInGlobalAddressList -eq $true -or $IncludeInGlobalAddressList -eq $false){$body.Add("includeInGlobalAddressList",$IncludeInGlobalAddressList)}
if($IPWhitelisted -eq $true -or $IPWhitelisted -eq $false){$body.Add("ipWhitelisted",$IPWhitelisted)}

$body = $body | ConvertTo-Json
$URI = "https://www.googleapis.com/admin/directory/v1/users/$User"
try
    {
    $response = Invoke-RestMethod -Method Patch -Uri $URI -Headers $header -Body $body -ContentType "application/json"
    }
catch
    {
    try
        {
        $result = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $resp = $reader.ReadToEnd()
        $response = $resp | ConvertFrom-Json | 
            Select-Object @{N="Error";E={$Error[0]}},@{N="Code";E={$_.error.Code}},@{N="Message";E={$_.error.Message}},@{N="Domain";E={$_.error.errors.domain}},@{N="Reason";E={$_.error.errors.reason}}
        Write-Error "$(Get-HTTPStatus -Code $response.Code): $($response.Domain) / $($response.Message) / $($response.Reason)"
        return
        }
    catch
        {
        Write-Error $resp
        return
        }
    }
return $response
}
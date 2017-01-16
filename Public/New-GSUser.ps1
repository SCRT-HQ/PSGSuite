function New-GSUser {
<#
.Synopsis
   Create a new Google user
.DESCRIPTION
   Create a new Google user, allowing for full property setting on creation
.EXAMPLE
   New-GSUser -PrimaryEmail john.smith@domain.com -GivenName John -FamilyName Smith -Password Password123 -ChangePasswordAtNextLogin True -OrgUnitPath "/Users/New Hires" -IncludeInGlobalAddressList True
#>
    
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $PrimaryEmail,
      [parameter(Mandatory=$true)]
      [String]
      $GivenName,
      [parameter(Mandatory=$true)]
      [String]
      $FamilyName,
      [parameter(Mandatory=$true)]
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
$body = @{
    primaryEmail = $PrimaryEmail
    password = $Password
    name = @{
        familyName = $FamilyName
        givenName = $GivenName
        }
    }

if($OrgUnitPath){$body.Add("orgUnitPath",$OrgUnitPath)}
if($ChangePasswordAtNextLogin -eq $true){$body.Add("changePasswordAtNextLogin",$true)}
elseif($ChangePasswordAtNextLogin -eq $false){$body.Add("changePasswordAtNextLogin",$false)}
if($Suspended -eq $true){$body.Add("suspended",$true)}
elseif($Suspended -eq $false){$body.Add("suspended",$false)}
if($IncludeInGlobalAddressList -eq $true){$body.Add("includeInGlobalAddressList",$true)}
elseif($IncludeInGlobalAddressList -eq $false){$body.Add("includeInGlobalAddressList",$false)}
if($IPWhitelisted -eq $true){$body.Add("ipWhitelisted",$true)}
elseif($IPWhitelisted -eq $false){$body.Add("ipWhitelisted",$false)}


$body = $body | ConvertTo-Json
$URI = "https://www.googleapis.com/admin/directory/v1/users"
try
    {
    $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $body -ContentType "application/json"
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
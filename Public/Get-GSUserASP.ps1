function Get-GSUserASP {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false,Position=0,ValueFromPipelineByPropertyName=$true)]
      [Alias("primaryEmail")]
      [ValidateNotNullOrEmpty()]
      [String]
      $User=$Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$false,Position=1,ValueFromPipelineByPropertyName=$true)]
      [ValidateNotNullOrEmpty()]
      [int]
      $CodeID,
      [parameter(Mandatory=$false)]
      [switch]
      $Raw,
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
      [string]
      $AdminEmail=$Script:PSGSuite.AdminEmail
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.user.security" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://www.googleapis.com/admin/directory/v1/users/$User/asps/$CodeID"
try
    {
    $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -ContentType "application/json" | Select-Object @{N="user";E={$User}},*
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
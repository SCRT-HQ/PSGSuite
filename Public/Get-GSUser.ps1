function Get-GSUser {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false,Position=0)]
      [ValidateNotNullOrEmpty()]
      [String]
      $User = $Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$false)]
      [ValidateSet("Basic","Custom","Full")]
      [string]
      $Projection="Full",
      [parameter(Mandatory=$false)]
      [String]
      $CustomFieldMask,
      [parameter(Mandatory=$false)]
      [ValidateSet("Admin_View","Domain_Public")]
      [String]
      $ViewType="Admin_View",
      [parameter(Mandatory=$false)]
      [String[]]
      $Fields,
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
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.user.readonly" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://www.googleapis.com/admin/directory/v1/users/$($User)?projection=$($Projection.ToLower())"
if ($CustomFieldMask){$URI = "$URI&customFieldMask=$CustomFieldMask"}
if ($ViewType){$URI = "$URI&viewType=$ViewType"}
if ($Fields)
    {
    $URI = "$URI&fields="
    $Fields | % {$URI = "$URI$_,"}
    }
try
    {
    $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $header | ForEach-Object {if($_.kind -like "*#*"){$_.PSObject.TypeNames.Insert(0,$(Convert-KindToType -Kind $_.kind));$_}else{$_}}
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
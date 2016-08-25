function Update-GoogUser {
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$true)]
      [String]
      $User,
      [parameter(Mandatory=$false)]
      [String]
      $OrgUnitPath
    )
$header = @{
    Authorization="Bearer $AccessToken"
    }
$body = @{
    orgUnitPath="$OrgUnitPath"
    }
#if($ParentID){$body.Add("parents",@($ParentID))}
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
        }
    catch
        {
        $response = $resp
        }
    }
return $response
}
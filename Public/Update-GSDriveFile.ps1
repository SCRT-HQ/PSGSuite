function Update-GSDriveFile {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $FileId,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $Owner = $Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$false)]
      [String]
      $Name,
      [parameter(Mandatory=$false)]
      [String]
      $Description,
      [parameter(Mandatory=$false)]
      [String[]]
      $AddParents,
      [parameter(Mandatory=$false)]
      [String[]]
      $RemoveParents,
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
      $AppEmail = $Script:PSGSuite.AppEmail
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/drive" -AppEmail $AppEmail -AdminEmail $Owner
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }

$body = @{}
if($Name){$body.Add("name",$Name)}
if($Description){$body.Add("description",$Description)}
$body = $body | ConvertTo-Json
$URI = "https://www.googleapis.com/drive/v3/files/$FileId"
if ($AddParents)
    {
    $URI = "$URI`?addParents=$($AddParents -join ",")"
    if ($RemoveParents)
        {
        $URI = "$URI&removeParents=$($RemoveParents -join ",")"
        }
    }
elseif ($RemoveParents)
    {
    $URI = "$URI`?removeParents=$($RemoveParents -join ",")"
    }

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
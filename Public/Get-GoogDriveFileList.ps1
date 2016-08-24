function Get-GoogDriveFileList {
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $AccessToken
    )
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://www.googleapis.com/drive/v3/files"
try
    {
    $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -ContentType "application/json" | select -ExpandProperty files
    }
catch
    {
    $result = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($result)
    $reader.BaseStream.Position = 0
    $reader.DiscardBufferedData()
    $response = $reader.ReadToEnd() | ConvertFrom-Json | 
        Select-Object @{N="Error";E={$Error[0]}},@{N="Code";E={$_.error.Code}},@{N="Message";E={$_.error.Message}},@{N="Domain";E={$_.error.errors.domain}},@{N="Reason";E={$_.error.errors.reason}}
    }
return $response
}
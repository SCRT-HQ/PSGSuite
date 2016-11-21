function Copy-ArrayToGoogSheet {
    [cmdletbinding()]
    Param
    (      
      [parameter(Mandatory=$true,Position=0)]
      [String]
      $SpreadsheetId,
      [parameter(Mandatory=$true,Position=1)]
      [object[]]
      $ArrayToCopy,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $Owner = $Script:PSGoogle.AdminEmail,
      [parameter(Mandatory=$false)]
      [String]
      $SheetName,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]
      $SpecifyRange="A1:Z1000",
      [parameter(Mandatory=$false)]
      [ValidateSet("INPUT_VALUE_OPTION_UNSPECIFIED","RAW","USER_ENTERED")]
      [string]
      $ValueInputOption="RAW",
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [string]
      $IncludeValuesInResponse=$true,
      [parameter(Mandatory=$false)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $P12KeyPath = $Script:PSGoogle.P12KeyPath,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AppEmail = $Script:PSGoogle.AppEmail,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AdminEmail = $Script:PSGoogle.AdminEmail
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/drive" -AppEmail $AppEmail -AdminEmail $Owner
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
if ($SheetName)
    {
    if ($SpecifyRange -like "'*'!*")
        {
        Write-Error "SpecifyRange formatting error! When using the SheetName parameter, please exclude the SheetName when formatting the SpecifyRange value (i.e. 'A1:Z1000')"
        return
        }
    else
        {
        $SpecifyRange = "'$($SheetName)'!$SpecifyRange"
        }
    }
$values = @()
$propArray = ($ArrayToCopy | Select -First 1).PSObject.Properties.Name
$values+=,$propArray
foreach ($object in $ArrayToCopy)
    {
    $valueArray = @($object.PSobject.Properties.Value)
    $values+=,$valueArray
    }
$body = @{
    valueInputOption=$ValueInputOption
    includeValuesInResponse=$IncludeValuesInResponse
    data=@(
        @{
            majorDimension="ROWS"
            range=$SpecifyRange
            values=$values
            }
        )
    } | ConvertTo-Json -Depth 6


$URI = "https://sheets.googleapis.com/v4/spreadsheets/$SpreadsheetId/values:batchUpdate"
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
        }
    catch
        {
        $response = $resp
        }
    }
return $response
}
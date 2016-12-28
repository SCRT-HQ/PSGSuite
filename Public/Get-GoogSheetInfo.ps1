function Get-GoogSheetInfo {
    [cmdletbinding()]
    Param
    (      
      [parameter(Mandatory=$true)]
      [String]
      $SpreadsheetId,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $Owner = $Script:PSGoogle.AdminEmail,
      [parameter(Mandatory=$false)]
      [string]
      $SpecifyRange,
      [parameter(Mandatory=$false)]
      [String]
      $SheetName,
      [parameter(Mandatory=$false)]
      [ValidateSet($false,$true)]
      [string]
      $IncludeGridData=$false,
      [parameter(Mandatory=$false)]
      [ValidateSet("namedRanges","properties","sheets","spreadsheetId")]
      [string[]]
      $Fields,
      [parameter(Mandatory=$false)]
      [switch]
      $Raw,
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
    elseif ($SpecifyRange)
        {
        $SpecifyRange = "'$($SheetName)'!$SpecifyRange"
        }
    else
        {
        $SpecifyRange = "$SheetName"
        }
    }
$URI = "https://sheets.googleapis.com/v4/spreadsheets/$SpreadsheetId`?includeGridData=$($IncludeGridData.ToLower())"
if ($Range){$URI = "$URI&ranges=$Range"}
if ($Fields){$URI = "$URI&fields=$($Fields -join '%2C')"}
try
    {
    $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -ContentType "application/json"
    if (!$Raw)
        {
        $response = $response | 
            Select-Object @{N="spreadsheetId";E={$_.spreadsheetId}},
                          @{N="title";E={$_.properties.title}},
                          @{N="maxRows";E={[int]($_.sheets.properties.gridProperties.rowCount | Sort-Object | Select-Object -Last 1)}},
                          @{N="maxColumns";E={[int]($_.sheets.properties.gridProperties.columnCount | Sort-Object | Select-Object -Last 1)}},
                          @{N="RAWDATA";E={$_}}
        }
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
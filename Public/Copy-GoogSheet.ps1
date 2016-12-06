function Copy-GoogSheet {
    [cmdletbinding(DefaultParameterSetName="UseExisting")]
    Param
    (      
      [parameter(Mandatory=$true,Position=0)]
      [String]
      $SourceSpreadsheetId,
      [parameter(Mandatory=$true,Position=1)]
      [String]
      $SourceSheetId,
      [parameter(Mandatory=$true,Position=2,ParameterSetName="UseExisting")]
      [String]
      $DestinationSpreadsheetId,
      [parameter(Mandatory=$true,Position=2,ParameterSetName="CreateNewSheet")]
      [switch]
      $CreateNewSheet,
      [parameter(Mandatory=$false,ParameterSetName="CreateNewSheet")]
      [String]
      $SheetTitle,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $Owner = $Script:PSGoogle.AdminEmail,
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
if ($PSCmdlet.ParameterSetName -eq "CreateNewSheet")
    {
    if (!$CreateNewSheet)
        {
        Write-Warning "-CreateNewSheet parameter auto-sets to $True when the CreateNewSheet parameter set is used. A new sheet will be created due to this."
        }
    $NewSheetParams = @{
        Owner=$Owner
        AccessToken=$AccessToken
        }
    if ($SheetTitle)
        {
        Write-Verbose "Creating new spreadsheet titled: $SheetTitle"
        $NewSheetParams.Add("SheetTitle",$SheetTitle)
        }
    else
        {
        Write-Verbose "Creating new untitled spreadsheet"
        }
    $DestinationSpreadsheetId = New-GoogSheet @NewSheetParams -Verbose:$false | Select-Object -ExpandProperty spreadsheetId
    Write-Verbose "New spreadsheet ID: $DestinationSpreadsheetId"
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$body = @{
    destinationSpreadsheetId=$DestinationSpreadsheetId
    } | ConvertTo-Json

$URI = "https://sheets.googleapis.com/v4/spreadsheets/$SourceSpreadsheetId/sheets/$SourceSheetId`:copyTo"
try
    {
    $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $body -ContentType "application/json"
    if (!$Raw)
        {

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
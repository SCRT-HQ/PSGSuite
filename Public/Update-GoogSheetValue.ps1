function Update-GoogSheetValue {
    [cmdletbinding(DefaultParameterSetName="CreateNewSheet")]
    Param
    (      
      [parameter(Mandatory=$true,Position=0,ParameterSetName="UseExisting")]
      [String]
      $SpreadsheetId,
      [parameter(Mandatory=$true,Position=0,ParameterSetName="CreateNewSheet")]
      [switch]
      $CreateNewSheet,
      [parameter(Mandatory=$false,Position=1)]
      [object[]]
      $Array,
      [parameter(Mandatory=$false,Position=2)]
      [string]
      $Value,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $Owner = $Script:PSGoogle.AdminEmail,
      [parameter(Mandatory=$false)]
      [switch]
      $Append,
      [parameter(Mandatory=$false,ParameterSetName="UseExisting")]
      [String]
      $SheetName,
      [parameter(Mandatory=$false,ParameterSetName="CreateNewSheet")]
      [String]
      $SheetTitle,
      [parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $SpecifyRange,
      [parameter(Mandatory=$false)]
      [ValidateSet("INPUT_VALUE_OPTION_UNSPECIFIED","RAW","USER_ENTERED")]
      [string]
      $ValueInputOption="RAW",
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [string]
      $IncludeValuesInResponse=$true,
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
if (!$Array -and !$Value)
    {
    Write-Error "This function requires either providing an Array to update multiple cells OR a Value if only updating one cell. Neither Parameter is currently in use."
    return
    }
if ($Array -and $Value)
    {
    Write-Error "This function requires either providing an Array to update multiple cells OR a Value if only updating one cell. Both Parameters are currently in use."
    return
    }
if (!$AccessToken)
    {
    Write-Verbose "Acquiring token"
    $AccessToken = Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/drive" -AppEmail $AppEmail -AdminEmail $Owner -Verbose:$false
    if ($AccessToken)
        {
        Write-Verbose "Token acquired!"
        }
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
    $SpreadsheetId = New-GoogSheet @NewSheetParams -Verbose:$false | Select-Object -ExpandProperty spreadsheetId
    Write-Verbose "New spreadsheet ID: $SpreadsheetId"
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
if ($Value)
    {
    $Array = $([pscustomobject]@{Value="$Value"})
    $Append = $true
    }
$values = @()
if (!$Append)
    {
    $propArray = ($Array | Select -First 1).PSObject.Properties.Name
    $values+=,$propArray
    }
foreach ($object in $Array)
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
    } | ConvertTo-Json -Depth 4


$URI = "https://sheets.googleapis.com/v4/spreadsheets/$SpreadsheetId/values:batchUpdate"
try
    {
    $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $body -ContentType "application/json"
    if (!$Raw)
        {
        $full = @()
        $response.responses.updatedData.values | 
            % {
                $full += $($_ -replace "`t","  ") -join "`t"
                }
        $response | Add-Member -MemberType NoteProperty -Name "updatedData" -Value $($full | ConvertFrom-Csv -Delimiter "`t")
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
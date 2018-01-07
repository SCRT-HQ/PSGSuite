function Get-GSCalendarEventList {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false)]
      [String]
      $CalendarID="primary",
      [parameter(Mandatory=$false)]
      [ValidateSet("StartTime","Updated")]
      [String]
      $OrderBy,
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 2500})]
      [Int]
      $PageSize="2500",
      [parameter(Mandatory=$false)]
      [switch]
      $SingleEvents,
      [parameter(Mandatory=$false)]
      [string]
      $TimeMin,
      [parameter(Mandatory=$false)]
      [string]
      $TimeMax,
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
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/calendar" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://www.googleapis.com/calendar/v3/calendars/$CalendarID/events"

if ($SingleEvents){$URI = "$URI`?singleEvents=$true"}
else{$URI = "$URI`?singleEvents=$false"}
if ($OrderBy){$URI = "$URI&orderBy=$OrderBy"}
if ($TimeMin)
    {
    $timeMinConverted = Get-Date $((Get-Date $TimeMin).ToUniversalTime()) -Format "yyyy-MM-ddTHH:mm:ssZ"
    $URI = "$URI&timeMin=$timeMinConverted"
    }
if ($TimeMax)
    {
    $timeMaxConverted = Get-Date $((Get-Date $TimeMax).ToUniversalTime()) -Format "yyyy-MM-ddTHH:mm:ssZ"
    $URI = "$URI&timeMax=$timeMaxConverted"
    }
if ($PageSize){$URI = "$URI&maxResults=$PageSize"}
try
    {
    Write-Verbose "Constructed URI: $URI"
    $response = @()
    [int]$i=1
    do
        {
        if ($i -eq 1)
            {
            $result = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
            }
        else
            {
            $result = Invoke-RestMethod -Method Get -Uri "$URI&pageToken=$pageToken" -Headers $header -Verbose:$false
            }
        $response += $result.items | ForEach-Object {if($_.kind -like "*#*"){$_.PSObject.TypeNames.Insert(0,$(Convert-KindToType -Kind $_.kind));$_}else{$_}}
        $returnSize = $result.items.Count
        $pageToken="$($result.nextPageToken)"
        [int]$retrieved = ($i + $result.items.Count) - 1
        Write-Verbose "Retrieved $retrieved events..."
        [int]$i = $i + $result.items.Count
        }
    until 
        ([string]::IsNullOrWhiteSpace($pageToken))
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
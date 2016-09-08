function New-GoogCalendarEvent {
    [cmdletbinding(DefaultParameterSetName='InternalToken')]
    Param
    (
      [parameter(Mandatory=$false)]
      [String]
      $CalendarID="primary",
      [parameter(Mandatory=$false)]
      [String]
      $Summary,
      [parameter(Mandatory=$false)]
      [String]
      $Description,
      [parameter(Mandatory=$false)]
      [String]
      $Location,
      [parameter(Mandatory=$false)]
      [ValidateSet("Periwinkle","Seafoam","Lavender","Coral","Goldenrod","Beige","Cyan","Grey","Blue","Green","Red")]
      [String]
      $EventColor,
      [parameter(Mandatory=$false)]
      [String]
      $LocalStartDateTime = $((Get-Date).ToString()),
      [parameter(Mandatory=$false)]
      [String]
      $LocalEndDateTime = $((Get-Date).AddMinutes(30)),
      [parameter(Mandatory=$false)]
      [String]
      $StartDate,
      [parameter(Mandatory=$false)]
      [String]
      $EndDate,
      [parameter(Mandatory=$false)]
      [String]
      $UTCStartDateTime,
      [parameter(Mandatory=$false)]
      [String]
      $UTCEndDateTime,
      [parameter(ParameterSetName='ExternalToken',Mandatory=$false)]
      [String]
      $AccessToken,
      [parameter(ParameterSetName='InternalToken',Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $P12KeyPath = $Script:PSGoogle.P12KeyPath,
      [parameter(ParameterSetName='InternalToken',Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AppEmail = $Script:PSGoogle.AppEmail,
      [parameter(ParameterSetName='InternalToken',Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AdminEmail = $Script:PSGoogle.AdminEmail
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/calendar" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$body = @{}
if ($UTCStartDateTime)
    {
    $StartTimeConverted = Get-Date $(Get-Date $UTCStartDateTime) -Format "yyyy-MM-ddTHH:mm:ssZ"
    $body.Add("start",@{dateTime=$StartTimeConverted})
    }
elseif ($StartDate)
    {
    $StartDateConverted = Get-Date $(Get-Date $StartDate) -Format "yyyy-MM-dd"
    $body.Add("start",@{date=$StartDateConverted})
    }
else
    {
    $StartTimeConverted = Get-Date $((Get-Date $LocalStartDateTime).ToUniversalTime()) -Format "yyyy-MM-ddTHH:mm:ssZ"
    $body.Add("start",@{dateTime=$StartTimeConverted})
    }
if ($UTCStartDateTime)
    {
    $EndTimeConverted = Get-Date $(Get-Date $UTCEndDateTime) -Format "yyyy-MM-ddTHH:mm:ssZ"
    $body.Add("end",@{dateTime=$EndTimeConverted})
    }
elseif ($EndDate)
    {
    $EndDateConverted = Get-Date $(Get-Date $EndDate) -Format "yyyy-MM-dd"
    $body.Add("start",@{date=$EndDateConverted})
    }
else
    {
    $EndTimeConverted = Get-Date $((Get-Date $LocalEndDateTime).ToUniversalTime()) -Format "yyyy-MM-ddTHH:mm:ssZ"
    $body.Add("end",@{dateTime=$EndTimeConverted})
    }
if($Summary){$body.Add("summary",$Summary)}
if($Description){$body.Add("description",$Description)}
if($Location){$body.Add("location",$Location)}
if($EventColor)
    {
    $colorHash = @{
        Periwinkle = 1
        Seafoam = 2
        Lavender = 3
        Coral = 4
        Goldenrod = 5
        Beige = 6
        Cyan = 7
        Grey = 8
        Blue = 9
        Green = 10
        Red = 11
        }
    $ColorID = $colorHash.Item($EventColor)
    $body.Add("colorID",$ColorID)
    }
$body = $body | ConvertTo-Json
$URI = "https://www.googleapis.com/calendar/v3/calendars/$CalendarID/events"
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
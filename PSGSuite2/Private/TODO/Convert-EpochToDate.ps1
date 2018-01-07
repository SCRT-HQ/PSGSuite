function Convert-EpochToDate {
    Param
    (
      [parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
      [string]
      $EpochString
    )
$UnixEpoch = [timezone]::CurrentTimeZone.ToLocalTime([datetime]'1/1/1970')
try
    {
    $result = $UnixEpoch.AddSeconds($EpochString)
    }
catch
    {
    try
        {
        $result = $UnixEpoch.AddMilliseconds($EpochString)
        }
    catch
        {
        $result = $UnixEpoch.AddTicks($EpochString)
        }
    }
return $result
}
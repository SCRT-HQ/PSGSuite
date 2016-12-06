function Convert-EpochToDate {
    Param
    (
      [parameter(Mandatory=$true)]
      [string[]]
      $EpochString,
      [parameter(Mandatory=$false)]
      [ValidateSet("Seconds","Milliseconds")]
      [string]
      $UnitOfTime="Seconds"
    )
$result = @()
$Method = "Add$UnitOfTime"
$UnixEpoch = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970'))
foreach ($Epoch in $EpochString)
    {
    $result += [pscustomobject]@{
        Converted=$UnixEpoch.$Method($Epoch)
        Original=$Epoch
        }
    }
return $result
}
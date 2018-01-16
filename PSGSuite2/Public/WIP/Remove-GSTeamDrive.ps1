function Remove-GSTeamDrive {
    [cmdletbinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
    Param
    (      
      [parameter(Mandatory=$true,Position=0)]
      [String]
      $TeamDriveID,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $Owner = $Script:PSGSuite.AdminEmail,
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
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/drive" -AppEmail $AppEmail -AdminEmail $Owner
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://www.googleapis.com/drive/v3/teamdrives/$TeamDriveID"
if ($PSCmdlet.ShouldProcess($User))
    {
    try
        {
        $response = Invoke-RestMethod -Method Delete -Uri $URI -Headers $header -ContentType "application/json"
        if (!$response){Write-Host "Team Drive $TeamDriveID successfully removed from owner $Owner"}
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
    }
return $response
}
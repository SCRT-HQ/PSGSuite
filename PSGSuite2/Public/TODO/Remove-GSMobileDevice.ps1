function Remove-GSMobileDevice {
    [cmdletbinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
    Param
    (
      [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
      [ValidateNotNullOrEmpty()]
      [String]
      $ResourceID,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $CustomerID=$Script:PSGSuite.CustomerID,
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
      [string]
      $AdminEmail=$Script:PSGSuite.AdminEmail
    )
Begin 
    {
    if (!$AccessToken)
        {
        $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.device.mobile" -AppEmail $AppEmail -AdminEmail $AdminEmail
        }
    $header = @{
        Authorization="Bearer $AccessToken"
        }
    $user = $user
    }
Process
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/devices/mobile/$ResourceID"
    if ($PSCmdlet.ShouldProcess("Removing mobile device for Resource ID '$ResourceID' from customer '$CustomerID'"))
        {
        try
            {
            $response = Invoke-RestMethod -Method Delete -Uri $URI -Headers $header -ContentType "application/json"
            if (!$response)
                {
                Write-Host "Mobile device for Resource ID '$ResourceID' successfully removed from customer '$CustomerID'"
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
                Write-Error "$(Get-HTTPStatus -Code $response.Code): $($response.Domain) / $($response.Message) / $($response.Reason)"
                break
                }
            catch
                {
                Write-Error $resp
                break
                }
            }
        }
    }
End
    {
    return $response
    }
}
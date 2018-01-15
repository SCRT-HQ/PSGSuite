function Remove-GSGmailFilter {
    [cmdletbinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
    Param
    (
      [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
      [ValidateNotNullOrEmpty()]
      [String]
      $User=$Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
      [Alias("ID")]
      [String]
      $FilterID,
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
      $AppEmail = $Script:PSGSuite.AppEmail
    )
Begin 
    {
    if (!$AccessToken)
        {
        $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/gmail.settings.basic" -AppEmail $AppEmail -AdminEmail $User
        }
    $header = @{
        Authorization="Bearer $AccessToken"
        }
    }
Process
    {
    $URI = "https://www.googleapis.com/gmail/v1/users/$User/settings/filters/$FilterID"
    if ($PSCmdlet.ShouldProcess("Removing Filter ID $FilterID from $User's Gmail settings"))
        {
        try
            {
            $response = Invoke-RestMethod -Method Delete -Uri $URI -Headers $header -ContentType "application/json"
            if (!$response){Write-Host "Filter ID '$FilterID' successfully removed from $User's Gmail settings"}
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
function Remove-GSGroupMember {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true)]
      [String[]]
      $GroupEmail,
      [parameter(Mandatory=$true)]
      [Alias()]
      [String[]]
      $UserEmail,
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
Begin
    {
    if (!$AccessToken)
        {
        $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.group" -AppEmail $AppEmail -AdminEmail $AdminEmail -Verbose:$false
        }
    $header = @{
        Authorization="Bearer $AccessToken"
        }
    }
Process
    {
    foreach ($Group in $GroupEmail)
        {
        foreach ($User in $UserEmail)
            {
            Write-Verbose "Removing $User from $Group"
            $URI = "https://www.googleapis.com/admin/directory/v1/groups/$($Group)/members/$($User)"
            try
                {
                $response = Invoke-RestMethod -Method Delete -Uri $URI -Headers $header
                if (!$response){Write-Verbose "$User successfully removed from $Group"}
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
    }
End
    {
    return $response
    }
}
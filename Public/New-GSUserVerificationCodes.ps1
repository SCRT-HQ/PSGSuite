function New-GSUserVerificationCodes {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true,Position=0,ValueFromPipelineByPropertyName=$true)]
      [Alias("primaryEmail")]
      [ValidateNotNullOrEmpty()]
      [String]
      $User,
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
        $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.user.security" -AppEmail $AppEmail -AdminEmail $AdminEmail
        }
    $header = @{
        Authorization="Bearer $AccessToken"
        }
    $URI = "https://www.googleapis.com/admin/directory/v1/users/$User/verificationCodes/generate"
    $User = $User
    }
Process
    {
    try
        {
        $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -ContentType "application/json"
        if (!$response){Write-Host "New verification codes successfully generated for $User"}
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
    }
End
    {
    return $response
    }
}
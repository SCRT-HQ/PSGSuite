function Remove-GoogUserSchema {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true)]
      [String[]]
      $Schema,
      [parameter(Mandatory=$false)]
      [String]
      $CustomerID=$Script:PSGoogle.CustomerID,
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
if (!$AccessToken)
    {
    $AccessToken = Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.userschema" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
foreach ($Sch in $Schema)
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/schemas/$Sch"
    try
        {
        $response = Invoke-RestMethod -Method Delete -Uri $URI -Headers $header -ContentType "application/json"
        if (!$response){Write-Verbose "Schema '$Sch' successfully removed"}
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
return $response
}
function Get-GSUserSchemaInfo {
    [cmdletbinding()]
    Param
    (
      [parameter(ParameterSetName='CheckSpecific',Mandatory=$true)]
      [String[]]
      $Schema,
      [parameter(ParameterSetName='CheckAll',Mandatory=$true)]
      [switch]
      $CheckAllSchemas,
      [parameter(Mandatory=$false)]
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
      [String]
      $AdminEmail = $Script:PSGSuite.AdminEmail
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.userschema" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$response = @()
if ($CheckAllSchemas){$Schema = Get-GSUserSchemaList -Verbose:$false | Select-Object -ExpandProperty schemaName}
foreach ($Sch in $Schema)
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/schemas/$Sch"
    try
        {
        $result = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose | Select-Object -ExpandProperty fields
        $result | Add-Member -MemberType NoteProperty -Name schemaName -Value $Sch
        $response += $result
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
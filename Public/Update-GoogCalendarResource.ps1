function Update-GoogCalendarResource {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
      [Alias("ID")]
      [String]
      $ResourceID,
      [parameter(Mandatory=$false)]
      [String]
      $Name,
      [parameter(Mandatory=$false)]
      [String]
      $Description,
      [parameter(Mandatory=$false)]
      [String]
      $Type,
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
      $AdminEmail = $Script:PSGoogle.AdminEmail,
      [parameter(Mandatory=$false)]
      [String]
      $CustomerID=$(if($Script:PSGoogle.CustomerID){$Script:PSGoogle.CustomerID}else{"my_customer"})
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.resource.calendar" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$body = @{}
if($Name){$body.Add("resourceName",$Name)}
if($Description){$body.Add("resourceDescription",$Description)}
if($Type){$body.Add("resourceType",$Type)}

$body = $body | ConvertTo-Json
$URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/resources/calendars/$ResourceID"
try
    {
    $response = Invoke-RestMethod -Method Patch -Uri $URI -Headers $header -Body $body -ContentType "application/json"
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
function Update-GSUserSchema {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $Schema,
      [parameter(Mandatory=$false)]
      [switch]
      $KeepExistingFields,
      [parameter(Mandatory=$true)]
      [string[]]
      $FieldName,
      [parameter(Mandatory=$true)]
      [ValidateSet("BOOL","DATE","DOUBLE","EMAIL","INT64","PHONE","STRING")]
      [string]
      $FieldType,
      [parameter(Mandatory=$false)]
      [ValidateSet("ADMINS_AND_SELF","ALL_DOMAIN_USERS")]
      [string]
      $FieldReadAccessType="ADMINS_AND_SELF",
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
$fields = @()
if ($KeepExistingFields)
    {
    $fields += Get-GSUserSchemaInfo -Schema $Schema -Verbose:$false | Select-Object -ExcludeProperty kind,fieldId,etag,schemaName
    }
foreach ($FName in $FieldName)
    {
    $fields += [pscustomobject]@{
        fieldName = $FName
        fieldType = $FieldType
        readAccessType = $FieldReadAccessType
        }
    }
$body = @{
    fields=$fields
    } | ConvertTo-Json
$URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/schemas/$Schema"
try
    {
    $response = Invoke-RestMethod -Method Patch -Uri $URI -Headers $header -Body $body -ContentType "application/json" | Select-Object -ExpandProperty fields
    $response | Add-Member -MemberType NoteProperty -Name schemaName -Value $Schema
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
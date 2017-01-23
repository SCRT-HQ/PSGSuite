function Update-GSOrganizationalUnit {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true,Position=0,ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
      [ValidateNotNullOrEmpty()]
      [String]
      $OrgUnitID,
      [parameter(Mandatory=$false)]
      [String]
      $Name,
      [parameter(Mandatory=$false)]
      [string]
      $ParentOrgUnitPath,
      [parameter(Mandatory=$false)]
      [string]
      $ParentOrgUnitID,
      [parameter(Mandatory=$false)]
      [String]
      $Description,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [string]
      $BlockInheritance,
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
      $AdminEmail = $Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$false)]
      [String]
      $CustomerID=$Script:PSGSuite.CustomerID
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.orgunit" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
if(!$CustomerID){$CustomerID = "my_customer"}
$URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/orgunits/$OrgUnitID"
$Body = @{}
if($Name){$Body.name = $Name}
if($ParentOrgUnitPath){$Body.parentOrgUnitPath = $ParentOrgUnitPath}
if($ParentOrgUnitID){$Body.parentOrgUnitID = $ParentOrgUnitID}
if($BlockInheritance -eq $true -or $BlockInheritance -eq $false){$Body.blockInheritance = $BlockInheritance}
if($Description){$Body.description = $Description}
$Body = $Body | ConvertTo-Json
Write-Verbose "Constructed URI: $URI"
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
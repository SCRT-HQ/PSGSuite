function New-GoogOrganizationalUnit {
<#
.Synopsis
   Creates a new Organizational Unit in Google Apps
.DESCRIPTION
   Creates a new Organizational Unit in Google Apps.
.EXAMPLE
   New-GoogOrganizationalUnit -AccessToken $(Get-GoogToken @TokenParams) -CustomerID $Customer -Name "Test Org" -ParentOrgUnitPath "/Testing" -Description "This is a test OrgUnit"
#>
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $Name,
      [parameter(Mandatory=$false)]
      [string]
      $ParentOrgUnitPath,
      [parameter(Mandatory=$false)]
      [String]
      $Description,
      [parameter(Mandatory=$false)]
      [switch]
      $BlockInheritance,
      [parameter(ParameterSetName='ExternalToken',Mandatory=$false)]
      [String]
      $AccessToken,
      [parameter(ParameterSetName='InternalToken',Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $P12KeyPath = $Script:PSGoogle.P12KeyPath,
      [parameter(ParameterSetName='InternalToken',Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AppEmail = $Script:PSGoogle.AppEmail,
      [parameter(ParameterSetName='InternalToken',Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $AdminEmail = $Script:PSGoogle.AdminEmail,
      [parameter(Mandatory=$false)]
      [String]
      $CustomerID=$Script:PSGoogle.CustomerID
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.orgunit" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
if(!$CustomerID){$CustomerID = "my_customer"}
$URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/orgunits"
if (!$ParentOrgUnitPath){$ParentOrgUnitPath = "/"}
$Body = @{
    name = $Name
    BlockInheritance = $BlockInheritance
    parentOrgUnitPath = $ParentOrgUnitPath
    }
if($Description){$Body.description = $Description}
$Body = $Body | ConvertTo-Json
Write-Verbose "Constructed URI: $URI"
try
    {
    $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $body -ContentType "application/json"
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
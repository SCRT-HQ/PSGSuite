function Get-GSOrgUnitList {
<#
.Synopsis
   Gets the OrgUnit list for a given account in Google Apps
.DESCRIPTION
   Retrieves the full OrgUnit list for the entire account. Allows filtering by BaseOrgUnitPath (SearchBase) and Type (SearchScope)
.EXAMPLE
   Get-GSOrgUnitList -AccessToken $(Get-GSToken @TokenParams) -CustomerID C22jaaesx -BaseOrgUnitPath "/Users" -Type Children
.EXAMPLE
   Get-GSOrgUnitList -AccessToken $(Get-GSToken @TokenParams) -CustomerID c22jaaesx
#>
    [cmdletbinding()]
    Param
    (
      
      [parameter(Mandatory=$false)]
      [Alias("SearchBase")]
      [String]
      $BaseOrgUnitPath,
      [parameter(Mandatory=$false)]
      [Alias("SearchScope")]
      [ValidateSet("All","Children")]
      [String]
      $Type="All",
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
$URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/orgunits"
if ($BaseOrgUnitPath -and $Type){$URI = "$URI`?&orgUnitPath=$BaseOrgUnitPath&type=$Type"}
elseif ($BaseOrgUnitPath -and !$Type){$URI = "$URI`?&orgUnitPath=$BaseOrgUnitPath"}
elseif (!$BaseOrgUnitPath -and $Type){$URI = "$URI`?type=$Type"}
try
    {
    Write-Verbose "Constructed URI: $URI"
    $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false | Select-Object -ExpandProperty organizationUnits | ForEach-Object {if($_.kind -like "*#*"){$_.PSObject.TypeNames.Insert(0,$(Convert-KindToType -Kind $_.kind));$_}else{$_}}
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
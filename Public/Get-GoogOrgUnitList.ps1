function Get-GoogOrgUnitList {
<#
.Synopsis
   Gets the OrgUnit list for a given account in Google Apps
.DESCRIPTION
   Retrieves the full OrgUnit list for the entire account. Allows filtering by BaseOrgUnitPath (SearchBase) and Type (SearchScope)
.EXAMPLE
   Get-GoogOrgUnitList -AccessToken $(Get-GoogToken @TokenParams) -CustomerID C22jaaesx -BaseOrgUnitPath "/Users" -Type Children
.EXAMPLE
   Get-GoogOrgUnitList -AccessToken $(Get-GoogToken @TokenParams) -CustomerID c22jaaesx
#>
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$true)]
      [String]
      $CustomerID,
      [parameter(Mandatory=$false)]
      [Alias("SearchBase")]
      [String]
      $BaseOrgUnitPath,
      [parameter(Mandatory=$false)]
      [Alias("SearchScope")]
      [ValidateSet("All","Children")]
      [String]
      $Type="All"
    )

$header = @{Authorization="Bearer $AccessToken"}

$URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/orgunits"



if ($BaseOrgUnitPath -and $Type){$URI = "$URI`?&orgUnitPath=$BaseOrgUnitPath&type=$Type"}
elseif ($BaseOrgUnitPath -and !$Type){$URI = "$URI`?&orgUnitPath=$BaseOrgUnitPath"}
elseif (!$BaseOrgUnitPath -and $Type){$URI = "$URI`?type=$Type"}

Write-Verbose "Constructed URI: $URI"

$results = @()
$result = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
$results += $result.organizationUnits
Write-Verbose "Retrieved organizationUnits $i - $($result.organizationUnits.Count)..."

return $results
}
function Get-GoogResourceCalList {
<#
.Synopsis
   Gets the resource calendar list for a given account in Google Apps
.DESCRIPTION
   Retrieves the full resource calendar list for the entire account. 
.EXAMPLE
   Get-GoogResourceCalList -AccessToken $(Get-GoogToken @TokenParams) -CustomerID C22jaaesx -BaseOrgUnitPath "/Users" -Type Children
.EXAMPLE
   Get-GoogResourceCalList -AccessToken $(Get-GoogToken @TokenParams) -CustomerID c22jaaesx
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
      [ValidateScript({[int]$_ -le 500})]
      [Int]
      $MaxResults="500"
    )

$header = @{Authorization="Bearer $AccessToken"}

$URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/resources/calendars"

if ($MaxResults){$URI = "$URI`?&MaxResults=$MaxResults"}

Write-Verbose "Constructed URI: $URI"

$results = @()
[int]$i=1
do
    {
    if ($i -eq 1)
        {
        $result = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
        }
    else
        {
        $result = Invoke-RestMethod -Method Get -Uri "$URI&pageToken=$pageToken" -Headers $header -Verbose:$false
        }
    $results += $result.items
    $pageToken="$($result.nextPageToken)"
    [int]$retrieved = ($i + $result.items.Count) - 1
    Write-Verbose "Retrieved resources $i - $retrieved..."
    [int]$i = $i + $result.items.Count
    }
until 
    ($result.items.Count -lt $MaxResults)

return $results
}
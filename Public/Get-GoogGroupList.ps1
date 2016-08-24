function Get-GoogGroupList {
<#
.Synopsis
   Gets the group list for a given account in Google Apps
.DESCRIPTION
   Retrieves the full group list for the entire account
.EXAMPLE
   Get-GoogGroupList -AccessToken $(Get-GoogToken @TokenParams) -MaxResults 5 -Where_IsAMember "random-user@domain.com"
.EXAMPLE
   Get-GoogGroupList -AccessToken $(Get-GoogToken @TokenParams)
#>
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$false)]
      [String]
      $CustomerID="my_customer",
      [parameter(Mandatory=$false)]
      [String]
      $Domain,
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 200})]
      [Int]
      $MaxResults="200",
      [parameter(Mandatory=$false)]
      [String]
      $Where_IsAMember
    )

$header = @{Authorization="Bearer $AccessToken"}

if ($Where_IsAMember)
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/groups?userKey=$($Where_IsAMember)"
    }
else
    {
    if ($Domain)
        {
        $URI = "https://www.googleapis.com/admin/directory/v1/groups?domain=$Domain"
        }
    else
        {
        $URI = "https://www.googleapis.com/admin/directory/v1/groups?customer=$CustomerID"
        }
    }


if ($MaxResults){$URI = "$URI&maxResults=$MaxResults"}

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
    $results += $result.groups
    $pageToken="$($result.nextPageToken)"
    [int]$retrieved = ($i + $result.groups.Count) - 1
    Write-Verbose "Retrieved groups $i - $retrieved..."
    [int]$i = $i + $result.groups.Count
    }
until 
    ($result.groups.Count -lt $MaxResults)

return $results
}
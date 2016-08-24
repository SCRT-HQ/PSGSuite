function Get-GoogUserList {
<#
.Synopsis
   Gets the user list for a given account in Google Apps
.DESCRIPTION
   Retrieves the full user list for the entire account. Accepts standard Google queries as a string or array of strings.
.EXAMPLE
   Get-GoogUserList -AccessToken $(Get-GoogToken @TokenParams) -MaxResults 300 -Query "orgUnitPath=/Users","email=domain.user2@domain.com"
.EXAMPLE
   Get-GoogUserList -AccessToken $(Get-GoogToken @TokenParams)
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
      [ValidateScript({[int]$_ -le 500})]
      [Int]
      $MaxResults="500",
      [parameter(Mandatory=$false)]
      [ValidateSet("Email","GivenName","FamilyName")]
      [String]
      $OrderBy,
      [parameter(Mandatory=$false)]
      [ValidateSet("Ascending","Descending")]
      [String]
      $SortOrder,
      [parameter(Mandatory=$false)]
      [String[]]
      $Query
    )

$header = @{Authorization="Bearer $AccessToken"}

if ($Domain)
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/users?domain=$Domain"
    }
else
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/users?customer=$CustomerID"
    }

if ($MaxResults){$URI = "$URI&maxResults=$MaxResults"}
if ($OrderBy){$URI = "$URI&orderBy=$OrderBy"}
if ($SortOrder){$URI = "$URI&sortOrder=$SortOrder"}
if ($Query)
    {
    $Query = $($Query -join " ")
    $URI = "$URI&query=$Query"
    }

Write-Verbose "Constructed URI: $URI"

$results = @()
[int]$i=1
do
    {
    if ($i -eq 1)
        {
        $users = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
        }
    else
        {
        $users = Invoke-RestMethod -Method Get -Uri "$URI&pageToken=$pageToken" -Headers $header -Verbose:$false
        }
    $results += $users.users
    $pageToken="$($users.nextPageToken)"
    [int]$retrieved = ($i + $users.users.Count) - 1
    Write-Verbose "Retrieved users $i - $retrieved..."
    [int]$i = $i + $users.users.Count
    }
until 
    ($users.users.Count -lt $MaxResults)

return $results
}
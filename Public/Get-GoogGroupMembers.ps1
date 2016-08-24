function Get-GoogGroupMembers {
<#
.Synopsis
   Gets the group member list for a given group in Google Apps
.DESCRIPTION
   Retrieves the full group list for the entire account
.EXAMPLE
   Get-GoogGroupMembers -AccessToken $(Get-GoogToken @TokenParams) -GroupEmail "my.group@domain.com" -MaxResults 10
.EXAMPLE
   Get-GoogGroupMembers -AccessToken $(Get-GoogToken @TokenParams)
#>
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $AccessToken,
      [parameter(Mandatory=$true)]
      [String]
      $GroupEmail,
      [parameter(Mandatory=$false)]
      [ValidateSet("Owner","Manager","Member")]
      [String[]]
      $Roles,
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 200})]
      [Int]
      $MaxResults="200"
    )

$header = @{Authorization="Bearer $AccessToken"}

$URI = "https://www.googleapis.com/admin/directory/v1/groups/$($GroupEmail)/members"

if ($Roles){$URI = "$URI`?roles=$($Roles -join ",")"}
if ($Roles -and $MaxResults){$URI = "$URI&maxResults=$MaxResults"}
elseif ($MaxResults){$URI = "$URI`?&maxResults=$MaxResults"}

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
    $results += $result.members
    $pageToken="$($result.nextPageToken)"
    [int]$retrieved = ($i + $result.members.Count) - 1
    Write-Verbose "Retrieved groups $i - $retrieved..."
    [int]$i = $i + $result.members.Count
    }
until 
    ($result.members.Count -lt $MaxResults)

return $results
}
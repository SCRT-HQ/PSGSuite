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
      [parameter(Mandatory=$false,HelpMessage="What is the full path to your Google Service Account's P12 key file?")]
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
      $AccessToken,
      [parameter(Mandatory=$false)]
      [String]
      $CustomerID=$Script:PSGoogle.CustomerID,
      [parameter(Mandatory=$false)]
      [String]
      $Domain=$Script:PSGoogle.Domain,
      [parameter(Mandatory=$false)]
      [ValidateSet("Domain","CustomerID")]
      [String]
      $Preference=$Script:PSGoogle.Preference,
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 500})]
      [Int]
      $PageSize="500",
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
if ($AccessToken)
    {
    $header = @{
        Authorization="Bearer $AccessToken"
        }
    }
else
    {
    $header = @{
        Authorization="Bearer $(Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.user.readonly" -AppEmail $AppEmail -AdminEmail $AdminEmail)"
        }
    }
if ($Preference -eq "Domain")
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/users?domain=$Domain"
    }
elseif($Preference -eq "CustomerID")
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/users?customer=$CustomerID"
    }
else
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/users?customer=my_customer"
    }

if ($PageSize){$URI = "$URI&maxResults=$PageSize"}
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
    $returnSize = $users.users.Count
    $pageToken="$($users.nextPageToken)"
    [int]$retrieved = ($i + $users.users.Count) - 1
    Write-Verbose "Retrieved users $i - $retrieved..."
    [int]$i = $i + $users.users.Count
    }
until 
    ($returnSize -lt $PageSize)

return $results
}
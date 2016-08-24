function Get-GoogUser {
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
      [parameter(Mandatory=$true)]
      [String]
      $User,
      [parameter(Mandatory=$false)]
      [ValidateSet("Basic","Custom","Full")]
      [string]
      $Projection="Full",
      [parameter(Mandatory=$false)]
      [String]
      $CustomFieldMask,
      [parameter(Mandatory=$false)]
      [ValidateSet("Admin_View","Domain_Public")]
      [String]
      $ViewType="Admin_View",
      [parameter(Mandatory=$false)]
      [String[]]
      $Fields
    )

$header = @{Authorization="Bearer $AccessToken"}

$URI = "https://www.googleapis.com/admin/directory/v1/users/$User`?projection=$Projection"

if ($CustomFieldMask){$URI = "$URI&customFieldMask=$CustomFieldMask"}
if ($ViewType){$URI = "$URI&viewType=$ViewType"}
if ($Fields)
    {
    $URI = "$URI&fields="
    $Fields | % {$URI = "$URI$_,"}
    }

Write-Verbose "Constructed URI: $URI"

return Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
}
function Get-GSGroupList {
<#
.Synopsis
   Gets the group list for a given account in Google Apps
.DESCRIPTION
   Retrieves the full group list for the entire account
.EXAMPLE
   Get-GSGroupList -AccessToken $(Get-GSToken @TokenParams) -MaxResults 5 -Where_IsAMember "random-user@domain.com"
.EXAMPLE
   Get-GSGroupList -AccessToken $(Get-GSToken @TokenParams)
#>
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false)]
      [String]
      $Where_IsAMember,
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 200})]
      [Int]
      $PageSize="200",
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
      $CustomerID=$Script:PSGSuite.CustomerID,
      [parameter(Mandatory=$false)]
      [String]
      $Domain=$Script:PSGSuite.Domain,
      [parameter(Mandatory=$false)]
      [ValidateSet("Domain","CustomerID")]
      [String]
      $Preference=$Script:PSGSuite.Preference
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.group" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
if ($Where_IsAMember)
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/groups?userKey=$($Where_IsAMember)"
    }
else
    {
    if ($Preference -eq "Domain")
        {
        $URI = "https://www.googleapis.com/admin/directory/v1/groups?domain=$Domain"
        }
    elseif($Preference -eq "CustomerID")
        {
        $URI = "https://www.googleapis.com/admin/directory/v1/groups?customer=$CustomerID"
        }
    else
        {
        $URI = "https://www.googleapis.com/admin/directory/v1/groups?customer=my_customer"
        }
    }
if ($PageSize){$URI = "$URI&maxResults=$PageSize"}
try
    {
    Write-Verbose "Constructed URI: $URI"
    $response = @()
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
        $response += $result.groups
        $returnSize = $result.groups.Count
        $pageToken="$($result.nextPageToken)"
        [int]$retrieved = ($i + $result.groups.Count) - 1
        Write-Verbose "Retrieved groups $i - $retrieved..."
        [int]$i = $i + $result.groups.Count
        }
    until 
        ($returnSize -lt $PageSize)
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
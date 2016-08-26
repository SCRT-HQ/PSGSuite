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
    [cmdletbinding(DefaultParameterSetName='InternalToken')]
    Param
    (
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
      $Query,
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
      $CustomerID=$Script:PSGoogle.CustomerID,
      [parameter(Mandatory=$false)]
      [String]
      $Domain=$Script:PSGoogle.Domain,
      [parameter(Mandatory=$false)]
      [ValidateSet("Domain","CustomerID")]
      [String]
      $Preference=$Script:PSGoogle.Preference
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.user.readonly" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
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
        $response += $result.users
        $returnSize = $result.users.Count
        $pageToken="$($result.nextPageToken)"
        [int]$retrieved = ($i + $result.users.Count) - 1
        Write-Verbose "Retrieved users $i - $retrieved..."
        [int]$i = $i + $result.users.Count
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
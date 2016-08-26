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
    [cmdletbinding(DefaultParameterSetName='InternalToken')]
    Param
    (
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
      $PageSize="200",
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
      $AdminEmail = $Script:PSGoogle.AdminEmail
    )

if (!$AccessToken)
    {
    $AccessToken = Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.group" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }

$URI = "https://www.googleapis.com/admin/directory/v1/groups/$($GroupEmail)/members"

if ($Roles){$URI = "$URI`?roles=$($Roles -join ",")"}
if ($Roles -and $PageSize){$URI = "$URI&maxResults=$PageSize"}
elseif ($PageSize){$URI = "$URI`?&maxResults=$PageSize"}
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
        $response += $result.members
        $pageToken="$($result.nextPageToken)"
        $returnSize = $result.members.Count
        [int]$retrieved = ($i + $result.members.Count) - 1
        Write-Verbose "Retrieved groups $i - $retrieved..."
        [int]$i = $i + $result.members.Count
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
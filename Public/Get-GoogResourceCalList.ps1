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
    [cmdletbinding(DefaultParameterSetName='InternalToken')]
    Param
    (
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 500})]
      [Int]
      $PageSize="500",
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
      $CustomerID=$Script:PSGoogle.CustomerID
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.resource.calendar" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/resources/calendars"
if ($PageSize){$URI = "$URI`?&MaxResults=$PageSize"}
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
        $response += $result.items
        $returnSize = $result.items.Count
        $pageToken="$($result.nextPageToken)"
        [int]$retrieved = ($i + $result.items.Count) - 1
        Write-Verbose "Retrieved resources $i - $retrieved..."
        [int]$i = $i + $result.items.Count
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
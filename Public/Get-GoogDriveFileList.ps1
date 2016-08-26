function Get-GoogDriveFileList {
    [cmdletbinding(DefaultParameterSetName='InternalToken')]
    Param
    (
      [parameter(Mandatory=$true)]
      [string]
      $Owner,
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 1000})]
      [Int]
      $PageSize="1000",
      [parameter(Mandatory=$false)]
      [ValidateSet('createdTime','folder','modifiedByMeTime','modifiedTime','name','quotaBytesUsed','recency','sharedWithMeTime','starred','viewedByMeTime')]
      [String[]]
      $OrderBy,
      [parameter(Mandatory=$false)]
      [String]
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
      $AdminEmail = $Script:PSGoogle.AdminEmail
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/drive" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://www.googleapis.com/drive/v3/files?pageSize=$PageSize&q='$($Owner)'+in+owners"
if ($Query)
    {
    $Query = $($Query -join "AND")
    $URI = "$URI`AND$Query"
    }
if ($OrderBy)
    {
    $OrderByJoined = $OrderBy -join ','
    $URI = "$URI&orderBy=$OrderByJoined"
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
        $response += $result.files
        $returnSize = $result.files.Count
        $pageToken="$($result.nextPageToken)"
        [int]$retrieved = ($i + $result.files.Count) - 1
        Write-Verbose "Retrieved files $i - $retrieved..."
        [int]$i = $i + $result.files.Count
        }
    until 
        ($returnSize -lt $PageSize)
    return $response    
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
function Get-GoogDriveFileList {
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
        Authorization="Bearer $(Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/drive" -AppEmail $AppEmail -AdminEmail $AdminEmail)"
        }
    }
$URI = "https://www.googleapis.com/drive/v3/files?pageSize=$PageSize&q='$($Owner)'+in+owners"
if ($OrderBy)
    {
    $OrderByJoined = $OrderBy -join ','
    $URI = "$URI&orderBy=$OrderByJoined"
    }
if ($Query)
    {
    $Query = $($Query -join " ")
    $URI = "$URI&query=$Query"
    }
try
    {
    Write-Verbose "Constructed URI: $URI"

    $results = @()
    [int]$i=1
    do
        {
        if ($i -eq 1)
            {
            $files = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
            }
        else
            {
            $files = Invoke-RestMethod -Method Get -Uri "$URI&pageToken=$pageToken" -Headers $header -Verbose:$false
            }
        $response += $files.files
        $returnSize = $files.files.Count
        $pageToken="$($files.nextPageToken)"
        [int]$retrieved = ($i + $files.files.Count) - 1
        Write-Verbose "Retrieved files $i - $retrieved..."
        [int]$i = $i + $files.files.Count
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
        }
    catch
        {
        $response = $resp
        }
    }
return $response
}
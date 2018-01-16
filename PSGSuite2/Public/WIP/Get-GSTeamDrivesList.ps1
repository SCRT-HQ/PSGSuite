function Get-GSTeamDrivesList {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false)]
      [string]
      $Owner = $Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 100})]
      [Int]
      $PageSize="100",
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
      $AppEmail = $Script:PSGSuite.AppEmail
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/drive" -AppEmail $AppEmail -AdminEmail $Owner
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://www.googleapis.com/drive/v3/teamdrives?pageSize=$PageSize&fields=kind%2CnextPageToken%2CteamDrives"
if ($Query)
    {
    $Query = $($Query -join " and ")
    $URI = "$URI&q=$Query"
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
        $response += $result.teamDrives | ForEach-Object {if($_.kind -like "*#*"){$_.PSObject.TypeNames.Insert(0,$(Convert-KindToType -Kind $_.kind));$_}else{$_}}
        $returnSize = $result.teamDrives.Count
        $pageToken="$($result.nextPageToken)"
        [int]$retrieved = ($i + $result.teamDrives.Count) - 1
        Write-Verbose "Retrieved $retrieved Team Drives..."
        [int]$i = $i + $result.teamDrives.Count
        }
    until 
        ([string]::IsNullOrWhiteSpace($pageToken))
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
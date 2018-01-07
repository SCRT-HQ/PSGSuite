function Get-GSDataTransferApplicationList {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $CustomerID = $Script:PSGSuite.CustomerID,
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 500 -and [int]$_ -ge 1})]
      [Int]
      $PageSize="500",
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
      [string]
      $AdminEmail=$Script:PSGSuite.AdminEmail
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.datatransfer" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://www.googleapis.com/admin/datatransfer/v1/applications"
if($CustomerID)
    {
    $URI = "$URI`?customer=$CustomerID&maxResults=$PageSize"
    }
else
    {
    $URI = "$URI`?customer=my_customer&maxResults=$PageSize"
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
        $response += $result.applications | ForEach-Object {if($_.kind -like "*#*"){$_.PSObject.TypeNames.Insert(0,$(Convert-KindToType -Kind $_.kind));$_}else{$_}}
        $returnSize = $result.applications.Count
        $pageToken="$($result.nextPageToken)"
        [int]$retrieved = ($i + $result.applications.Count) - 1
        Write-Verbose "Retrieved $retrieved applications..."
        [int]$i = $i + $result.applications.Count
        }
    until 
        ([string]::IsNullOrWhiteSpace($pageToken))
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
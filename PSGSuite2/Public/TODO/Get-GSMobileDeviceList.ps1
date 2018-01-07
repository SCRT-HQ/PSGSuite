function Get-GSMobileDeviceList {
    [cmdletbinding(DefaultParameterSetName="User")]
    Param
    (
      [parameter(Mandatory=$false,ParameterSetName="User",Position=0)]
      [String]
      $User,
      [parameter(Mandatory=$false,ParameterSetName="Query",Position=0)]
      [String]
      $Query,
      [parameter(Mandatory=$false)]
      [ValidateSet("BASIC","FULL")]
      [String]
      $Projection="FULL",
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 1000 -and [int]$_ -ge 1})]
      [Int]
      $PageSize="1000",
      [parameter(Mandatory=$false)]
      [ValidateSet("deviceId","email","lastSync","model","name","os","status","type")]
      [String]
      $OrderBy,
      [parameter(Mandatory=$false)]
      [ValidateSet("Ascending","Descending")]
      [String]
      $SortOrder,
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
      $CustomerID=$Script:PSGSuite.CustomerID
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.device.mobile" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
if($CustomerID)
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/customer/$CustomerID/devices/mobile?projection=$Projection"
    }
else
    {
    $URI = "https://www.googleapis.com/admin/directory/v1/customer/my_customer/devices/mobile?projection=$Projection"
    }

if ($PageSize){$URI = "$URI&maxResults=$PageSize"}
if ($OrderBy){$URI = "$URI&orderBy=$OrderBy"}
if ($SortOrder){$URI = "$URI&sortOrder=$SortOrder"}
if ($User)
    {
    $Query = "email:`"$User`""
    }
if ($Query)
    {
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
        $response += $result.mobiledevices | ForEach-Object {if($_.kind -like "*#*"){$_.PSObject.TypeNames.Insert(0,$(Convert-KindToType -Kind $_.kind));$_}else{$_}}
        $returnSize = $result.mobiledevices.Count
        $pageToken="$($result.nextPageToken)"
        [int]$retrieved = ($i + $result.mobiledevices.Count) - 1
        Write-Verbose "Retrieved $retrieved mobile devices..."
        [int]$i = $i + $result.mobiledevices.Count
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
if ($User)
    {
    return $response | Where-Object {$_.email -contains "$User"}
    }
else
    {
    return $response
    }
}
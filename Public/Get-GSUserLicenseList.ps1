function Get-GSUserLicenseList {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false)]
      [ValidateSet("Google-Apps","Google-Drive-storage","Google-Vault")]
      [string[]]
      $ProductID=@("Google-Apps","Google-Drive-storage","Google-Vault"),
      [parameter(Mandatory=$false)]
      [ValidateScript({[int]$_ -le 1000})]
      [Int]
      $PageSize="1000",
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
      $Domain=$Script:PSGSuite.Domain
    )
if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/apps.licensing" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$response = @()
foreach ($pId in $productId)
    {
    $URI = "https://www.googleapis.com/apps/licensing/v1/product/$pId/users/?customerId=$Domain&maxResults=$PageSize"
    try
        {
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
            $response += $result.items | ForEach-Object {if($_.kind -like "*#*"){$_.PSObject.TypeNames.Insert(0,$(Convert-KindToType -Kind $_.kind));$_}else{$_}}
            $returnSize = $result.items.Count
            $pageToken="$($result.nextPageToken)"
            [int]$retrieved = ($i + $result.items.Count) - 1
            Write-Verbose "Retrieved $retrieved licenses for $pId..."
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
    }
Write-Verbose "Retrieved $($response.Count) total licenses"
return $response
}
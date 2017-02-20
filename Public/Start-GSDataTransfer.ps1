function Start-GSDataTransfer {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true,Position=0)]
      [string]
      $OldOwnerUserId,
      [parameter(Mandatory=$true,Position=1)]
      [string]
      $NewOwnerUserId,
      [parameter(Mandatory=$true,Position=2,ValueFromPipelineByPropertyName=$true)]
      [alias("id")]
      [string]
      $ApplicationId,
      [parameter(Mandatory=$true)]
      [ValidateSet("SHARED","PRIVATE")]
      [string[]]
      $PrivacyLevel,
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
      [parameter(Mandatory=$false,Position=0)]
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
if ($OldOwnerUserId -like "*@*.*")
    {
    Write-Verbose "Fetching ID for user $OldOwnerUserId"
    $OldOwnerUserId = Get-GSUser -User $OldOwnerUserId -Projection Basic -P12KeyPath $P12KeyPath -AppEmail $AppEmail -AdminEmail $AdminEmail -Verbose:$false | Select-Object -ExpandProperty id
    }
if ($NewOwnerUserId -like "*@*.*")
    {
    Write-Verbose "Fetching ID for user $NewOwnerUserId"
    $NewOwnerUserId = Get-GSUser -User $NewOwnerUserId -Projection Basic -P12KeyPath $P12KeyPath -AppEmail $AppEmail -AdminEmail $AdminEmail -Verbose:$false | Select-Object -ExpandProperty id
    }
$URI = "https://www.googleapis.com/admin/datatransfer/v1/transfers"
$body = [ordered]@{
    newOwnerUserId = $NewOwnerUserId
    oldOwnerUserId = $OldOwnerUserId
    applicationDataTransfers = @(
        @{
            applicationId = $ApplicationId
            applicationTransferParams = @(
                @{
                    key = "PRIVACY_LEVEL"
                    value = @(
                        $PrivacyLevel
                        )
                    }
                )
            }
        )
    } | ConvertTo-Json -Depth 5
try
    {
    $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $body -ContentType "application/json" | ForEach-Object {if($_.kind -like "*#*"){$_.PSObject.TypeNames.Insert(0,$(Convert-KindToType -Kind $_.kind));$_}else{$_}}
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
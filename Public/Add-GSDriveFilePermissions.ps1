function Add-GSDriveFilePermissions {
    [cmdletbinding()]
    Param
    ( 
      [parameter(Mandatory=$false)]
      [string]
      $Owner = $Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$true)]
      [String]
      $FileID,
      [parameter(Mandatory=$false)]
      [String]
      $EmailAddress,
      [parameter(Mandatory=$true)]
      [ValidateSet("Owner","Writer","Commenter","Reader")]
      [String]
      $Role,
      [parameter(Mandatory=$true)]
      [ValidateSet("User","Group","Domain","Anyone")]
      [String]
      $Type,
      [parameter(Mandatory=$false)]
      [string]
      $EmailMessage,
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $SendNotificationEmail="$false",
      [parameter(Mandatory=$false)]
      [ValidateSet($true,$false)]
      [String]
      $AllowFileDiscovery,
      [parameter(Mandatory=$false)]
      [switch]
      $ConfirmTransferOfOwnership,
      [parameter(Mandatory=$false)]
      [ValidateSet("v2","v3")]
      [string]
      $APIVersion="v3",
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
if ($Role -eq "Owner" -and !$ConfirmTransferOfOwnership)
    {
    Write-Error "The ConfirmTransferOfOwnership parameter is required when setting the 'Owner' role."
    return
    }
if (($Type -eq "User" -or $Type -eq "Group") -and !$EmailAddress)
    {
    Write-Error "The EmailAddress parameter is required for types 'User' or 'Group'."
    return
    }
if (($Type -eq "User" -or $Type -eq "Group") -and ($AllowFileDiscovery -eq $true -or $AllowFileDiscovery -eq $false))
    {
    Write-Warning "The AllowFileDiscovery parameter is only applicable for types 'Domain' or 'Anyone' This parameter will be excluded from this request."
    Remove-Variable AllowFileDiscovery
    }

if (!$AccessToken)
    {
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/drive" -AppEmail $AppEmail -AdminEmail $Owner
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
if ($ConfirmTransferOfOwnership -and !$SendNotificationEmail)
    {
    $SendNotificationEmail = $true; Write-Warning "Setting SendNotificationEmail to 'True' to prevent errors -- Required for Ownership transfers"
    }
$URI = "https://www.googleapis.com/drive/$APIVersion/files/$FileID/permissions?sendNotificationEmail=$SendNotificationEmail"
if ($EmailMessage)
    {
    $URI = "$URI&emailMessage=$($EmailMessage -replace " ","+")"
    }
if ($ConfirmTransferOfOwnership)
    {
    $URI = "$URI&transferOwnership=$ConfirmTransferOfOwnership"
    }
$body = @{
    role = $Role.ToLower()
    type = $Type.ToLower()
    }
if($EmailAddress){$body.Add("emailAddress",$EmailAddress)}
if($AllowFileDiscovery -eq $true -or $AllowFileDiscovery -eq $false){$body.Add("allowFileDiscovery",$AllowFileDiscovery)}

$body = $body | ConvertTo-Json

try
    {
    $response = Invoke-RestMethod -Method POST -Uri $URI -Headers $header -ContentType "application/json" -Body $body
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
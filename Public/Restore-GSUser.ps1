function Restore-GSUser {
<#
.Synopsis
   Restores a deleted Google user
.DESCRIPTION
   Restores a deleted Google user
.EXAMPLE
   Restore-GSUser -User john.smith@domain.com -OrgUnitPath "/Users/Rehires" -WhatIf
.EXAMPLE
   Restore-GSUser -User john.smith@domain.com -OrgUnitPath "/Users/Rehires" -Confirm:$false
#>
    [cmdletbinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
    Param
    (
      [parameter(Mandatory=$true,Position=0)]
      [String]
      $User,
      [parameter(Mandatory=$true,Position=1)]
      [String]
      $OrgUnitPath,
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
      $AdminEmail = $Script:PSGSuite.AdminEmail
    )
if (!$AccessToken)
    {
    Write-Verbose "Acquiring token"
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.user" -AppEmail $AppEmail -AdminEmail $AdminEmail -Verbose:$false
    if ($AccessToken)
        {
        Write-Verbose "Token acquired!"
        }
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$body = @{
    orgUnitPath=$OrgUnitPath
    } | ConvertTo-Json
$URI = "https://www.googleapis.com/admin/directory/v1/users/$User/undelete"
if ($PSCmdlet.ShouldProcess($User))
    {
    try
        {
        $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $body -ContentType "application/json" | ForEach-Object {if($_.kind -like "*#*"){$_.PSObject.TypeNames.Insert(0,$(Convert-KindToType -Kind $_.kind));$_}else{$_}}
        if (!$response){Write-Host "User $User successfully restored to the domain"}
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
return $response
}
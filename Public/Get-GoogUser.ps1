function Get-GoogUser {
<#
.Synopsis
   Gets the user list for a given account in Google Apps
.DESCRIPTION
   Retrieves the full user list for the entire account. Accepts standard Google queries as a string or array of strings.
.EXAMPLE
   Get-GoogUserList -AccessToken $(Get-GoogToken @TokenParams) -MaxResults 300 -Query "orgUnitPath=/Users","email=domain.user2@domain.com"
.EXAMPLE
   Get-GoogUserList -AccessToken $(Get-GoogToken @TokenParams)
#>
    [cmdletbinding(DefaultParameterSetName='InternalToken')]
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $User,
      [parameter(Mandatory=$false)]
      [ValidateSet("Basic","Custom","Full")]
      [string]
      $Projection="Full",
      [parameter(Mandatory=$false)]
      [String]
      $CustomFieldMask,
      [parameter(Mandatory=$false)]
      [ValidateSet("Admin_View","Domain_Public")]
      [String]
      $ViewType="Admin_View",
      [parameter(Mandatory=$false)]
      [String[]]
      $Fields,
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
    $AccessToken = Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/admin.directory.user" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://www.googleapis.com/admin/directory/v1/users/$User`?projection=$Projection"
if ($CustomFieldMask){$URI = "$URI&customFieldMask=$CustomFieldMask"}
if ($ViewType){$URI = "$URI&viewType=$ViewType"}
if ($Fields)
    {
    $URI = "$URI&fields="
    $Fields | % {$URI = "$URI$_,"}
    }

Write-Verbose "Constructed URI: $URI"
try
    {
    $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -Verbose:$false
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
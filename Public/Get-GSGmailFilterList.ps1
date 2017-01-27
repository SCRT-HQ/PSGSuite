function Get-GSGmailFilterList {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false,Position=0)]
      [string]
      $User=$Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$false)]
      [switch]
      $Raw,
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
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/gmail.settings.basic" -AppEmail $AppEmail -AdminEmail $User
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://www.googleapis.com/gmail/v1/users/$user/settings/filters"
try
    {
    $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $header
    if (!$Raw -and $response.filter)
        {
        $response = $response | Select-Object -ExpandProperty filter | Select-Object @{N="user";E={$user}},id,@{N="from";E={$_.criteria.from}},@{N="to";E={$_.criteria.to}},@{N="subject";E={$_.criteria.subject}},@{N="query";E={$_.criteria.query}},@{N="negatedQuery";E={$_.criteria.negatedQuery}},@{N="hasAttachment";E={$_.criteria.hasAttachment}},@{N="excludeChats";E={$_.criteria.excludeChats}},@{N="size";E={$_.criteria.size}},@{N="sizeComparison";E={$_.criteria.sizeComparison}},@{N="addLabelIds";E={$_.action.addLabelIds}},@{N="removeLabelIds";E={$_.action.removeLabelIds}},@{N="forward";E={$_.action.forward}}
        }
    elseif (!$response.filter)
        {
        Write-Warning "No filters found for user '$user'"
        }
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
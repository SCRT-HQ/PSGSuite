function Send-GmailMessage {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String]
      $From=$Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$true)]
      [string]
      $Subject,
      [parameter(Mandatory=$true)]
      [string]
      $Body,
      [parameter(Mandatory=$true)]
      [string[]]
      $To,
      [parameter(Mandatory=$false)]
      [string[]]
      $CC,
      [parameter(Mandatory=$false)]
      [string[]]
      $BCC,
      [parameter(Mandatory=$false)]
      [ValidateScript({Test-Path $_})]
      [string[]]
      $Attachments,
      [parameter(Mandatory=$false)]
      [switch]
      $BodyAsHtml,
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
    $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://mail.google.com/" -AppEmail $AppEmail -AdminEmail $From
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$URI = "https://www.googleapis.com/gmail/v1/users/$From/messages/send"

$messageParams = @{
    From = $From
    To = @($To)
    Subject = $Subject
    Body = $Body
    ReturnConstructedMessage = $true
    }
if ($CC)
    {
    $messageParams.Add("CC",@($CC))
    }
if ($BCC)
    {
    $messageParams.Add("BCC",@($BCC))
    }
if ($Attachments)
    {
    $messageParams.Add("Attachment",@($Attachments))
    }
if ($BodyAsHtml)
    {
    $messageParams.Add("BodyAsHtml",$true)
    }
$raw = New-MimeMessage @messageParams | Convert-Base64 -From NormalString -To WebSafeBase64String
$reqBody = @{
    raw = $raw
    } | ConvertTo-Json
try
    {
    Write-Verbose "Constructed URI: $URI"
    $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $reqBody -ContentType "application/json" -Verbose:$false | ForEach-Object {$_.PSObject.TypeNames.Insert(0,"Google.Gmail.Message");$_}
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
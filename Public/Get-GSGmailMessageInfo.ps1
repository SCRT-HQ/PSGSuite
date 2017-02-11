function Get-GSGmailMessageInfo {
    [cmdletbinding(DefaultParameterSetName="Format")]
    Param
    (
      [parameter(Mandatory=$false)]
      [string]
      $User=$Script:PSGSuite.AdminEmail,
      [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$True)]
      [Alias('id')]
      [String[]]
      $MessageID,
      [parameter(Mandatory=$false,ParameterSetName="ParseMessage")]
      [switch]
      $ParseMessage,
      [parameter(Mandatory=$false,ParameterSetName="ParseMessage")]
      [ValidateScript({Test-Path $_})]
      [string]
      $AttachmentOutputPath,
      [parameter(Mandatory=$false,ParameterSetName="Format")]
      [ValidateSet("Full","Metadata","Minimal","Raw")]
      [string]
      $Format="Full",
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
Begin
    {
    if (!$AccessToken)
        {
        $AccessToken = Get-GSToken -P12KeyPath $P12KeyPath -Scopes "https://mail.google.com/" -AppEmail $AppEmail -AdminEmail $User
        }
    $header = @{
        Authorization="Bearer $AccessToken"
        }
    if ($ParseMessage)
        {
        $Format = "Raw"
        }
    if ($AttachmentOutputPath)
        {
        [System.Reflection.Assembly]::LoadWithPartialName('System.IO') | Out-Null
        }
    $response = @()
    }
Process
    {
    $URI = "https://www.googleapis.com/gmail/v1/users/$User/messages/$($MessageID)?format=$Format"
    try
        {
        $result = Invoke-RestMethod -Method Get -Uri $URI -Headers $header
        if ($ParseMessage)
            {
            $converted = Read-MimeMessage -String $(Convert-Base64 -From WebSafeBase64String -To NormalString -String $result.raw)
            $response += $converted
            if ($AttachmentOutputPath)
                {
                $attachments = $det.BodyParts | ? {![string]::IsNullOrEmpty($_.FileName)}
                foreach ($att in $attachments)
                    {
                    $fileName = "$AttachmentOutputPath\$($att.FileName)"
                    $stream = [IO.File]::Create($fileName)
                    $att.ContentObject.DecodeTo($stream)
                    }
                }
            }
        else
            {
            $response += $result
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
    }
End
    {
    return $response
    }
}
function New-MimeMessage {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string[]]
      $To,
      [parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [String]
      $From,
      [parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $Subject,
      [parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]
      $Body,
      [parameter(Mandatory=$false)]
      [string[]]
      $CC,
      [parameter(Mandatory=$false)]
      [string[]]
      $BCC,
      [parameter(Mandatory=$false)]
      [ValidateScript({Test-Path $_})]
      [string[]]
      $Attachment,
      [parameter(Mandatory=$false)]
      [switch]
      $BodyAsHtml
    )
[System.Reflection.Assembly]::LoadFrom("$ModuleRoot\nuget\MimeKit.1.10.1\lib\net451\MimeKit.dll") | Out-Null
$message = [MimeKit.MimeMessage]::new()
$message.From.Add($From)
$message.Subject = $Subject
foreach ($T in $To)
    {
    $message.To.Add($T)
    }
if ($CC)
    {
    foreach ($C in $CC)
        {
        $message.Cc.Add($C)
        }
    }
if ($BCC)
    {
    foreach ($B in $BCC)
        {
        $message.Bcc.Add($B)
        }
    }
if ($BodyAsHtml)
    {
    $TextPart = [MimeKit.TextPart]::new("html")
    }
else
    {
    $TextPart = [MimeKit.TextPart]::new("plain")
    }
$TextPart.Text = $Body
if ($Attachment)
    {
    [System.Reflection.Assembly]::LoadWithPartialName('System.IO') | Out-Null
    $Multipart = [MimeKit.Multipart]::new("mixed")
    $Multipart.Add($TextPart)
    foreach ($Attach in $Attachment)
        {
        $MimeType = (Get-MimeType -File $Attach) -split "/"
        $MimePart = [MimeKit.MimePart]::new($MimeType[0], $MimeType[1])
        $MimePart.ContentObject = [MimeKit.ContentObject]::new([IO.File]::OpenRead($Attach), [MimeKit.ContentEncoding]::Default)
        $MimePart.ContentDisposition = [MimeKit.ContentDisposition]::new([MimeKit.ContentDisposition]::Attachment)
        $MimePart.ContentTransferEncoding = [MimeKit.ContentEncoding]::Base64
        $MimePart.FileName = [IO.Path]::GetFileName($Attach)
        $Multipart.Add($MimePart)
        }
    $message.Body = $Multipart
    }
else
    {
    $message.Body = $TextPart
    }
return $message
}
function Get-GoogDriveFile {

    [cmdletbinding(DefaultParameterSetName='InternalToken')]
    Param
    (      
      [parameter(Mandatory=$true)]
      [String]
      $FileID,
      [parameter(Mandatory=$false)]
      [ValidateSet("CSV","HTML","JPEG","JSON","MSExcel","MSPowerPoint","MSWordDoc","OpenOfficeDoc","OpenOfficeSheet","PDF","PlainText","PNG","RichText","SVG")]
      [String]
      $Type,
      [parameter(Mandatory=$true)]
      [String]
      $OutFilePath,
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
    $AccessToken = Get-GoogToken -P12KeyPath $P12KeyPath -Scopes "https://www.googleapis.com/auth/drive" -AppEmail $AppEmail -AdminEmail $AdminEmail
    }
$header = @{
    Authorization="Bearer $AccessToken"
    }
$mimeHash=@{
    CSV="text/csv"
    HTML="text/html"
    JPEG="image/jpeg"
    JSON="application/vnd.google-apps.script+json"
    MSExcel="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    MSPowerPoint="application/vnd.openxmlformats-officedocument.presentationml.presentation"
    MSWordDoc="application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    OpenOfficeDoc="application/vnd.oasis.opendocument.text"
    OpenOfficeSheet="application/x-vnd.oasis.opendocument.spreadsheet"
    PDF="application/pdf"
    PlainText="text/plain"
    PNG="image/png"
    RichText="application/rtf"
    SVG="image/svg+xml"
    }
if($Type){$mimeType = $mimeHash.Item($Type)}
$URI = "https://www.googleapis.com/drive/v3/files/$FileID/export?mimeType=$mimeType"
try
    {
    $response = Invoke-RestMethod -Method Get -Uri $URI -Headers $header -ContentType "application/json" -OutFile $OutFilePath | Select *,@{N="Filepath";E={$OutFilePath}}
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
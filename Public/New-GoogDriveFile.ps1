function New-GoogDriveFile {
    Param
    (
      [parameter(Mandatory=$true)]
      [String]
      $Name,
      [parameter(Mandatory=$false)]
      [String[]]
      $ParentID,
      [parameter(Mandatory=$false)]
      [ValidateSet("Audio","Docs","Drawing","DriveFile","DriveFolder","Form","FusionTables","Map","Photo","Slides","AppsScript","Sites","Sheets","Unknown","Video")]
      [String]
      $Type,
      [parameter(Mandatory=$false)]
      [String]
      $CustomMimeType,
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
    Audio="application/vnd.google-apps.audio"
    Docs="application/vnd.google-apps.document"
    Drawing="application/vnd.google-apps.drawing"
    DriveFile="application/vnd.google-apps.file"
    DriveFolder="application/vnd.google-apps.folder"
    Form="application/vnd.google-apps.form"
    FusionTables="application/vnd.google-apps.fusiontable"
    Map="application/vnd.google-apps.map"
    Photo="application/vnd.google-apps.photo"
    Slides="application/vnd.google-apps.presentation"
    AppsScript="application/vnd.google-apps.script"
    Sites="application/vnd.google-apps.sites"
    Sheets="application/vnd.google-apps.spreadsheet"
    Unknown="application/vnd.google-apps.unknown"
    Video="application/vnd.google-apps.video"
    }
$body = @{
    name=$Name
}
if($Type){$body.Add("mimeType",$mimeHash.Item($Type))}
elseif($CustomMimeType){$body.Add("mimeType",$CustomMimeType)}
if($ParentID){$body.Add("parents",@($ParentID))}
$body = $body | ConvertTo-Json
$URI = "https://www.googleapis.com/drive/v3/files"
try
    {
    $response = Invoke-RestMethod -Method Post -Uri $URI -Headers $header -Body $body -ContentType "application/json"
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
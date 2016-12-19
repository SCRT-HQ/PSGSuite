function ConvertFrom-Base64String {
    Param
    (
      [parameter(Mandatory=$true,Position=0)]
      [String]
      $Base64String,
      [parameter(Mandatory=$false)]
      [switch]
      $FromWebSafeBase64,
      [parameter(Mandatory=$false)]
      [String]
      $OutFile
    )
if ($FromWebSafeBase64)
    {
    $Base64String = Convert-WebSafeBase64ToNormal -WebSafeBase64String $Base64String
    }
$bytes = [Convert]::FromBase64String($Base64String)
if ($OutFile)
    {
    $response = [IO.File]::WriteAllBytes($OutFile,$bytes)
    }
else
    {
    $response = [System.Text.Encoding]::UTF8.GetString($bytes)
    }
return $response
}
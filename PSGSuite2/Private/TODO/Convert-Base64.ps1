function Convert-Base64 {
    [cmdletbinding()]
    Param
    (
      [parameter(Mandatory=$true,Position=0)]
      [ValidateSet("NormalString","Base64String","WebSafeBase64String")]
      [ValidateScript({if($_ -eq $To){throw "The 'From' parameter must not be the same as the 'To' parameter"}else{$true}})]
      [String]
      $From,
      [parameter(Mandatory=$true,Position=1)]
      [ValidateSet("NormalString","Base64String","WebSafeBase64String")]
      [ValidateScript({if($_ -eq $From){throw "The 'To' parameter must not be the same as the 'From' parameter"}else{$true}})]
      [String]
      $To,
      [parameter(Mandatory=$true,Position=2,ValueFromPipeline=$true)]
      [String]
      $String,
      [parameter(Mandatory=$false)]
      [String]
      $OutFile
    )
if ($From -eq "NormalString")
    {
    $String = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($String))
    }
elseif ($From -eq "WebSafeBase64String")
    {
    $String = $String.Replace('_', '/').Replace('-', '+').Replace('|','=')
    switch ($String.Length % 4)
        {
        2 {$String += "=="}
        3 {$String += "="}
        }
    }
if ($To -eq "NormalString")
    {
    $String = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($String))
    }
elseif ($To -eq "WebSafeBase64String")
    {
    $String = $String.TrimEnd("=").Replace('+', '-').Replace('/', '_');
    }
if ($OutFile)
    {
    $String | Set-Content $OutFile -Force
    }
else
    {
    return $String
    }
}
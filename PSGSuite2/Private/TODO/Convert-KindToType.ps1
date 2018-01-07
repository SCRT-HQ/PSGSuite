function Convert-KindToType {
    Param
    (
      [parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
      [String]
      $Kind
    )
if ($Kind -like "*#*")
    {
    return "Google.$(($Kind -split "#" | ForEach-Object {$($_.substring(0,1).toupper()+$_.substring(1).tolower())}) -join ".")"
    }
else
    {
    return
    }
}

function Read-MimeMessage {
    [cmdletbinding(DefaultParameterSetName="String")]
    Param
    (
      [parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ParameterSetName="String")]
      [ValidateNotNullOrEmpty()]
      [string[]]
      $String,
      [parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ParameterSetName="EmlFile")]
      [ValidateScript({Test-Path $_})]
      [string[]]
      $EmlFile
    )
Begin
    {
    [System.Reflection.Assembly]::LoadFrom("$ModuleRoot\nuget\MimeKit.1.10.1\lib\net451\MimeKit.dll") | Out-Null
    $results = @()
    }
Process
    {
    if ($PSCmdlet.ParameterSetName -eq "String")
        {
        $Guid = (New-Guid).Guid
        $String | Set-Content "$env:TEMP\Mime$Guid.eml" -Force
        $results += [MimeKit.MimeMessage]::Load("$env:TEMP\Mime$Guid.eml")
        do 
            {
            try
                {
                Remove-Item "$env:TEMP\Mime$Guid.eml" -Force
                }
            catch
                {}
            }
        until
            (!(Test-Path "$env:TEMP\Mime$Guid.eml"))
        }
    else
        {
        $results += [MimeKit.MimeMessage]::Load($EmlFile)
        }
    }
End
    {
    return $results
    }
}
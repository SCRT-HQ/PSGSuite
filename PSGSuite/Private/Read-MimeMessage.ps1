function Read-MimeMessage {
    [cmdletbinding(DefaultParameterSetName = "String")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ParameterSetName = "String")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $String,
        [parameter(Mandatory = $true,ValueFromPipeline = $true,ParameterSetName = "EmlFile")]
        [ValidateScript( {Test-Path $_})]
        [string[]]
        $EmlFile
    )
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            String {
                foreach ($str in $String) {
                    $stream = [System.IO.MemoryStream]::new([Text.Encoding]::UTF8.GetBytes($str))
                    [MimeKit.MimeMessage]::Load($stream)
                    $stream.Dispose()
                }
            }
            EmlFile {
                foreach ($str in $EmlFile) {
                    [MimeKit.MimeMessage]::Load($str)
                }
            }
        }
    }
}
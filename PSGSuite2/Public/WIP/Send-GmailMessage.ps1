function Send-GmailMessage {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $From = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true)]
        [string]
        $Subject,
        [parameter(Mandatory = $true)]
        [string]
        $Body,
        [parameter(Mandatory = $true)]
        [string[]]
        $To,
        [parameter(Mandatory = $false)]
        [string[]]
        $CC,
        [parameter(Mandatory = $false)]
        [string[]]
        $BCC,
        [parameter(Mandatory = $false)]
        [ValidateScript( {Test-Path $_})]
        [string[]]
        $Attachments,
        [parameter(Mandatory = $false)]
        [switch]
        $BodyAsHtml
    )
    Process {
        if ($From -ceq 'me') {
            $From = $Script:PSGSuite.AdminEmail
        }
        elseif ($From -notlike "*@*.*") {
            $From = "$($From)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://mail.google.com'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $From
        }
        $service = New-GoogleService @serviceParams
        $messageParams = @{
            From                     = $From
            Subject                  = $Subject
            Body                     = $Body
            ReturnConstructedMessage = $true
        }
        if ($To) {
            $messageParams.Add("To",@($To))
        }
        if ($CC) {
            $messageParams.Add("CC",@($CC))
        }
        if ($BCC) {
            $messageParams.Add("BCC",@($BCC))
        }
        if ($Attachments) {
            $messageParams.Add("Attachment",@($Attachments)) 
        }
        if ($BodyAsHtml) {
            $messageParams.Add("BodyAsHtml",$true)
        }
        $raw = New-MimeMessage @messageParams | Convert-Base64 -From NormalString -To WebSafeBase64String
        try {
            $body = New-Object 'Google.Apis.Gmail.v1.Data.Message' -Property @{
                Raw = $raw
            }
            $request = $service.Users.Messages.Send($body,"$From")
            Write-Verbose "Sending Message '$Subject' from user '$From'"
            $request.Execute() | Select-Object @{N = 'User';E = {$From}},*
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}
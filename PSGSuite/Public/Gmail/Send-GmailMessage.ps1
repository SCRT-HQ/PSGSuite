function Send-GmailMessage {
    <#
    .SYNOPSIS
    Sends a Gmail message
    
    .DESCRIPTION
    Sends a Gmail message. Designed for parity with Send-GmailMessage
    
    .PARAMETER From
    The primary email of the user that is sending the message. This MUST be a user account owned by the customer, as the Gmail Service must be built under this user's context and will fail if a group or alias is passed instead

    Defaults to the AdminEmail user
    
    .PARAMETER Subject
    The subject of the email
    
    .PARAMETER Body
    The email body. Supports HTML when used in conjunction with the -BodyAsHtml parameter
    
    .PARAMETER To
    The To recipient(s) of the email
    
    .PARAMETER CC
    The Cc recipient(s) of the email
    
    .PARAMETER BCC
    The Bcc recipient(s) of the email
    
    .PARAMETER Attachments
    The attachment(s) of the email
    
    .PARAMETER BodyAsHtml
    If passed, renders the HTML content of the body on send
    
    .EXAMPLE
    Send-GmailMessage -From Joe -To john.doe@domain.com -Subject "New Pricing Models" -Body $body -BodyAsHtml -Attachments 'C:\Reports\PricingModel_2018.xlsx'

    Sends a message from Joe to john.doe@domain.com with HTML body and an Excel spreadsheet attached
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String]
        $From = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true)]
        [string]
        $Subject,
        [parameter(Mandatory = $false)]
        [string]
        $Body,
        [parameter(Mandatory = $false)]
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
        $User = $From -replace ".*<","" -replace ">",""
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
            $From = $User
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
            $From = $User
        }
        $serviceParams = @{
            Scope       = 'https://mail.google.com'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        $messageParams = @{
            From                     = $From
            Subject                  = $Subject
            ReturnConstructedMessage = $true
        }
        if ($To) {
            $messageParams.Add("To",@($To))
        }
        if ($Body) {
            $messageParams.Add("Body",$Body)
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
            $bodySend = New-Object 'Google.Apis.Gmail.v1.Data.Message' -Property @{
                Raw = $raw
            }
            $request = $service.Users.Messages.Send($bodySend,$User)
            Write-Verbose "Sending Message '$Subject' from user '$User'"
            $request.Execute() | Select-Object @{N = 'User';E = {$User}},*
        }
        catch {
            if ($ErrorActionPreference -eq 'Stop') {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            else {
                Write-Error $_
            }
        }
    }
}
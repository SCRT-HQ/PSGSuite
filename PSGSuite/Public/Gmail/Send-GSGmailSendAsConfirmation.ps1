function Send-GSGmailSendAsConfirmation {
    <#
    .SYNOPSIS
    Sends a verification email to the specified send-as alias address. The verification status must be pending.

    .DESCRIPTION
    Sends a verification email to the specified send-as alias address. The verification status must be pending.

    .PARAMETER SendAsEmail
    The SendAs alias to be verified.

    .PARAMETER User
    The email of the user you are verifying the SendAs alias for.

    .EXAMPLE
    Send-GSGmailSendAsConfirmation -SendAsEmail joseph.wiggum@work.com -User joe@domain.com

    Sends a verification email to Joe's work address to confirm joe@domain.com as being able to send-as that account.
    #>
    [OutputType()]
    [cmdletbinding()]
    Param (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("SendAs")]
        [string[]]
        $SendAsEmail,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User
    )
    Process {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/gmail.settings.sharing'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
        foreach ($sendAs in $SendAsEmail) {
            try {
                if ($sendAs -notlike "*@*.*") {
                    $sendAs = "$($sendAs)@$($Script:PSGSuite.Domain)"
                }
                Write-Verbose "Sending verification email to SendAs alias '$sendAs' for user '$User'"
                $request = $service.Users.Settings.SendAs.Verify($User,$sendAs)
                $request.Execute()
                Write-Verbose "Verification email for SendAs alias '$sendAs' of user '$User' sent successfully"
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
}

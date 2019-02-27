function Remove-GSGmailSendAsAlias {
    <#
    .SYNOPSIS
    Removes a Gmail SendAs alias.

    .DESCRIPTION
    Removes a Gmail SendAs alias.

    .PARAMETER SendAsEmail
    The SendAs alias to be removed.

    .PARAMETER User
    The email of the user you are removing the SendAs alias from.

    .EXAMPLE
    Remove-GSGmailSendAsAlias -SendAsEmail partyfuntime@domain.com -User joe@domain.com

    Remove Joe's fun custom Sendas alias that he had created in the early days of the company :-(
    #>
    [OutputType()]
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
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
                if ($PSCmdlet.ShouldProcess("Removing SendAs alias '$sendAs' from user '$User'")) {
                    Write-Verbose "Removing SendAs alias '$sendAs' from user '$User'"
                    $request = $service.Users.Settings.SendAs.Delete($User,$sendAs)
                    $request.Execute()
                    Write-Verbose "SendAs alias '$sendAs' successfully removed from user '$User'"
                }
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

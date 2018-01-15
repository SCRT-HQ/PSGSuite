function Remove-GSGmailMessage {
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('MessageID')]
        [String[]]
        $Id,
        [parameter(Mandatory = $false)]
        [ValidateSet('Trash','Delete')]
        [String]
        $Method = 'Trash'
    )
    Begin {
        if ($MyInvocation.InvocationName -eq 'Move-GSGmailMessageToTrash') {
            $Method = 'Trash'
        }
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://mail.google.com'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            foreach ($mId in $Id) {
                $request = switch ($Method) {
                    Trash {
                        $service.Users.Messages.Trash($User,$mId)
                        $message = "moved to TRASH"
                    }
                    Delete {
                        $service.Users.Messages.Delete($User,$mId)
                        $message = "deleted"
                    }
                }
                if ($PSCmdlet.ShouldProcess("Removing Message Id '$mId' for user '$User'")) {
                    Write-Verbose "Removing Message Id '$mId' for user '$User'"
                    $res = $request.Execute()
                    if ($res) {
                        $res | Select-Object @{N = 'User';E = {$U}},*
                    }
                    Write-Verbose "Message ID '$mId' successfully $message for user '$User'"
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}
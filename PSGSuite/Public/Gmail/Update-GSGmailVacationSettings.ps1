function Update-GSGmailVacationSettings {
    <#
    .SYNOPSIS
    Updates vacation responder settings for the specified account.

    .DESCRIPTION
    Updates vacation responder settings for the specified account.

    .PARAMETER User
    The user to update the VacationSettings settings for

    .PARAMETER EnableAutoReply
    Flag that controls whether Gmail automatically replies to messages.

    .PARAMETER EndTime
    An optional end time for sending auto-replies. When this is specified, Gmail will automatically reply only to messages that it receives before the end time. If both startTime and endTime are specified, startTime must precede endTime.

    .PARAMETER ResponseBodyHtml
    Response body in HTML format. Gmail will sanitize the HTML before storing it.

    .PARAMETER ResponseBodyPlainText
    Response body in plain text format.

    .PARAMETER ResponseSubject
    Optional text to prepend to the subject line in vacation responses. In order to enable auto-replies, either the response subject or the response body must be nonempty.

    .PARAMETER RestrictToContacts
    Flag that determines whether responses are sent to recipients who are not in the user's list of contacts.

    .PARAMETER RestrictToDomain
    Flag that determines whether responses are sent to recipients who are outside of the user's domain. This feature is only available for G Suite users.

    .PARAMETER StartTime
    An optional start time for sending auto-replies. When this is specified, Gmail will automatically reply only to messages that it receives after the start time. If both startTime and endTime are specified, startTime must precede endTime.

    .EXAMPLE
    Update-GSGmailVacationSettings -User me -ResponseBodyHtml "I'm on vacation and will reply when I'm back in the office. Thanks!" -RestrictToDomain -EndTime (Get-Date).AddDays(7) -StartTime (Get-Date) -EnableAutoReply

    Enables the vacation auto-reply for the AdminEmail user. Auto-replies will be sent to other users in the same domain only. The vacation response is enabled for 7 days from the time that the command is sent.

    .EXAMPLE
    Update-GSGmailVacationSettings -User me -EnableAutoReply:$false

    Disables the vacaction auto-response for the AdminEmail user immediately.
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.VacationSettings')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User,
        [parameter(Mandatory = $false)]
        [switch]
        $EnableAutoReply,
        [parameter(Mandatory = $false)]
        [datetime]
        $EndTime,
        [parameter(Mandatory = $false)]
        [string]
        $ResponseBodyHtml,
        [parameter(Mandatory = $false)]
        [string]
        $ResponseBodyPlainText,
        [parameter(Mandatory = $false)]
        [string]
        $ResponseSubject,
        [parameter(Mandatory = $false)]
        [switch]
        $RestrictToContacts,
        [parameter(Mandatory = $false)]
        [switch]
        $RestrictToDomain,
        [parameter(Mandatory = $false)]
        [datetime]
        $StartTime
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/gmail.settings.basic'
            ServiceType = 'Google.Apis.Gmail.v1.GmailService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        try {
            $body = New-Object 'Google.Apis.Gmail.v1.Data.VacationSettings'
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                switch ($prop) {
                    StartTime {
                        $epochMs = (Convert-DateToEpoch $StartTime)
                        $body.$prop = [long]$epochMs
                    }
                    EndTime {
                        $epochMs = (Convert-DateToEpoch $EndTime)
                        $body.$prop = [long]$epochMs
                    }
                    Default {
                        $body.$prop = $PSBoundParameters[$prop]
                    }
                }
            }
            $request = $service.Users.Settings.UpdateVacation($body,$User)
            Write-Verbose "Updating Vacation settings for user '$User'"
            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
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

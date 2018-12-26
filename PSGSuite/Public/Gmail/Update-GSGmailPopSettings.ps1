function Update-GSGmailPopSettings {
    <#
    .SYNOPSIS
    Updates POP settings

    .DESCRIPTION
    Updates POP settings

    .PARAMETER User
    The user to update the POP settings for

    .PARAMETER AccessWindow
    The range of messages which are accessible via POP.

    Acceptable values are:
    * "accessWindowUnspecified": Unspecified range.
    * "allMail": Indicates that all unfetched messages are accessible via POP.
    * "disabled": Indicates that no messages are accessible via POP.
    * "fromNowOn": Indicates that unfetched messages received after some past point in time are accessible via POP.

    .PARAMETER Disposition
    The action that will be executed on a message after it has been fetched via POP.

    Acceptable values are:
    * "archive": Archive the message.
    * "dispositionUnspecified": Unspecified disposition.
    * "leaveInInbox": Leave the message in the INBOX.
    * "markRead": Leave the message in the INBOX and mark it as read.
    * "trash": Move the message to the TRASH.

    .EXAMPLE
    Update-GSGmailPopSettings -User me -AccessWindow allMail

    Sets the POP AccessWindow to 'allMail' for the AdminEmail user
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.PopSettings')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User,
        [parameter(Mandatory = $false)]
        [ValidateSet('accessWindowUnspecified','allMail','disabled','fromNowOn')]
        [string]
        $AccessWindow,
        [parameter(Mandatory = $false)]
        [ValidateSet('archive','dispositionUnspecified','leaveInInbox','markRead','trash')]
        [string]
        $Disposition
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
            $body = New-Object 'Google.Apis.Gmail.v1.Data.PopSettings'
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                $body.$prop = $PSBoundParameters[$prop]
            }
            $request = $service.Users.Settings.UpdatePop($body,$User)
            Write-Verbose "Updating POP settings for user '$User'"
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

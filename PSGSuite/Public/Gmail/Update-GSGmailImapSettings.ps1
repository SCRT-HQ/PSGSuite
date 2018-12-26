function Update-GSGmailImapSettings {
    <#
    .SYNOPSIS
    Updates IMAP settings

    .DESCRIPTION
    Updates IMAP settings

    .PARAMETER User
    The user to update the IMAP settings for

    .PARAMETER AutoExpunge
    If this value is true, Gmail will immediately expunge a message when it is marked as deleted in IMAP. Otherwise, Gmail will wait for an update from the client before expunging messages marked as deleted.

    .PARAMETER Enabled
    Whether IMAP is enabled for the account.

    .PARAMETER ExpungeBehavior
    The action that will be executed on a message when it is marked as deleted and expunged from the last visible IMAP folder.

    Acceptable values are:
    * "archive": Archive messages marked as deleted.
    * "deleteForever": Immediately and permanently delete messages marked as deleted. The expunged messages cannot be recovered.
    * "expungeBehaviorUnspecified": Unspecified behavior.
    * "trash": Move messages marked as deleted to the trash.

    .PARAMETER MaxFolderSize
    An optional limit on the number of messages that an IMAP folder may contain. Legal values are 0, 1000, 2000, 5000 or 10000. A value of zero is interpreted to mean that there is no limit.

    .EXAMPLE
    Update-GSGmailImapSettings -Enabled:$false -User me

    Disables IMAP for the AdminEmail user
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.ImapSettings')]
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
        $AutoExpunge,
        [parameter(Mandatory = $false)]
        [switch]
        $Enabled,
        [parameter(Mandatory = $false)]
        [ValidateSet('archive','deleteForever','expungeBehaviorUnspecified','trash')]
        [string]
        $ExpungeBehavior,
        [parameter(Mandatory = $false)]
        [ValidateSet(0,1000,2000,5000,10000)]
        [int]
        $MaxFolderSize
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
            $body = New-Object 'Google.Apis.Gmail.v1.Data.ImapSettings'
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                $body.$prop = $PSBoundParameters[$prop]
            }
            $request = $service.Users.Settings.UpdateImap($body,$User)
            Write-Verbose "Updating IMAP settings for user '$User'"
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

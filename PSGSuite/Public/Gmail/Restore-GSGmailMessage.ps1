function Restore-GSGmailMessage {
    <#
    .SYNOPSIS
    Restores a trashed message to the inbox
    
    .DESCRIPTION
    Restores a trashed message to the inbox
    
    .PARAMETER User
    The primary email of the user to restore the message for

    Defaults to the AdminEmail user
    
    .PARAMETER Id
    The Id of the message to restore
    
    .EXAMPLE
    Restore-GSGmailMessage -User joe -Id 161622d7b76b7e1e,1616227c34d435f2

    Restores the 2 message Id's from Joe's TRASH back to their inbox
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias('MessageID')]
        [String[]]
        $Id
    )
    Begin {
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
                $request = $service.Users.Messages.Untrash($User,$mId)
                Write-Verbose "Removing Message Id '$mId' from TRASH for user '$User'"
                $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
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
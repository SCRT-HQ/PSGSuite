function Remove-GSGmailMessage {
    <#
    .SYNOPSIS
    Removes a Gmail message from the user
    
    .DESCRIPTION
    Removes a Gmail message from the user
    
    .PARAMETER User
    The primary email of the user to remove the message from

    Defaults to the AdminEmail user
    
    .PARAMETER Id
    The Id of the message to remove
    
    .PARAMETER Method
    The method used to delete the message

    Available values are:
    * "Trash": moves the message to the TRASH label (Default - preferred method, as this is recoverable)
    * "Delete": permanently deletes the message (NON-RECOVERABLE!)

    Default value is 'Trash'
    
    .EXAMPLE
    Remove-GSGmailMessage -User joe -Id 161622d7b76b7e1e,1616227c34d435f2

    Moves the 2 message Id's from Joe's inbox into their TRASH after confirmation
    #>
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
                        $res | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
                    }
                    Write-Verbose "Message ID '$mId' successfully $message for user '$User'"
                }
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
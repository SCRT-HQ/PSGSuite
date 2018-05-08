function Update-GSGmailAutoForwardingSettings {
    <#
    .SYNOPSIS
    Updates the auto-forwarding setting for the specified account. A verified forwarding address must be specified when auto-forwarding is enabled. 
    
    .DESCRIPTION
    Updates the auto-forwarding setting for the specified account. A verified forwarding address must be specified when auto-forwarding is enabled.
    
    .PARAMETER User
    The user to update the AutoForwarding settings for
    
    .PARAMETER Disposition
    The state that a message should be left in after it has been forwarded. 

    Acceptable values are:
    * "archive": Archive the message.
    * "dispositionUnspecified": Unspecified disposition.
    * "leaveInInbox": Leave the message in the INBOX.
    * "markRead": Leave the message in the INBOX and mark it as read.
    * "trash": Move the message to the TRASH.
    
    .PARAMETER EmailAddress
    Email address to which all incoming messages are forwarded. This email address must be a verified member of the forwarding addresses.
    
    .PARAMETER Enabled
    Whether all incoming mail is automatically forwarded to another address.
    
    .EXAMPLE
    Update-GSGmailAutoForwardingSettings -User me -Disposition leaveInInbox -EmailAddress joe@domain.com -Enabled

    Enables auto forwarding of all mail for the AdminEmail user. Forwarded mail will be left in their inbox.
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User,
        [parameter(Mandatory = $false)]
        [ValidateSet('archive','dispositionUnspecified','leaveInInbox','markRead','trash')]
        [string]
        $Disposition,
        [parameter(Mandatory = $false)]
        [string]
        $EmailAddress,
        [parameter(Mandatory = $false)]
        [switch]
        $Enabled
    )
    Begin {
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
    }
    Process {
        try {
            $body = New-Object 'Google.Apis.Gmail.v1.Data.AutoForwarding'
            foreach ($prop in $PSBoundParameters.Keys | Where-Object {$body.PSObject.Properties.Name -contains $_}) {
                $body.$prop = $PSBoundParameters[$prop]
            }
            $request = $service.Users.Settings.UpdateAutoForwarding($body,$User)
            Write-Verbose "Updating AutoForwarding settings for user '$User'"
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
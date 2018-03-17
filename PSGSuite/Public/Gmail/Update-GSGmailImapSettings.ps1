function Update-GSGmailImapSettings {
    <#
    .SYNOPSIS
    Updates IMAP settings
    
    .DESCRIPTION
    Updates IMAP settings
    
    .PARAMETER User
    The user to update the IMAP settings for
    
    .EXAMPLE
    Update-GSGmailImapSettings -Enabled:$false -User me

    Disables IMAP for the AdminEmail user
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
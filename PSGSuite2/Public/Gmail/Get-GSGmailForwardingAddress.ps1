function Get-GSGmailForwardingAddress {
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("Id")]
        [string[]]
        $ForwardingAddress
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
            if ($ForwardingAddress) {
                foreach ($fwd in $ForwardingAddress) {
                    $request = $service.Users.Settings.ForwardingAddresses.Get($User,$fwd)
                    Write-Verbose "Getting Forwarding Address '$fwd' for user '$User'"
                    $request.Execute() | Select-Object @{N = 'User';E = {$User}},*
                }
            }
            else {
                $request = $service.Users.Settings.ForwardingAddresses.List($User)
                Write-Verbose "Getting Forwarding Address List for user '$User'"
                $request.Execute() | Select-Object -ExpandProperty ForwardingAddresses | Select-Object @{N = 'User';E = {$User}},*
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}
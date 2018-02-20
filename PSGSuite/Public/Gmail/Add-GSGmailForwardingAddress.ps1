function Add-GSGmailForwardingAddress {
    <#
    .SYNOPSIS
    Creates a forwarding address.
    
    .DESCRIPTION
    Creates a forwarding address. If ownership verification is required, a message will be sent to the recipient and the resource's verification status will be set to pending; otherwise, the resource will be created with verification status set to accepted.
    
    .PARAMETER ForwardingAddress
    An email address to which messages can be forwarded. 
    
    .PARAMETER User
    The user to create the forwarding addresses for

    Defaults to the AdminEmail user
    
    .EXAMPLE
    Add-GSGmailForwardingAddress "joe@domain.com"

    Adds joe@domain.com as a forwarding address for the AdminEmail user
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("Id")]
        [string[]]
        $ForwardingAddress,
        [parameter(Mandatory = $false,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $Script:PSGSuite.AdminEmail
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
            foreach ($fwd in $ForwardingAddress) {
                $body = New-Object 'Google.Apis.Gmail.v1.Data.ForwardingAddress' -Property @{
                    ForwardingEmail = $fwd
                }
                $request = $service.Users.Settings.ForwardingAddresses.Create($body,$User)
                Write-Verbose "Creating Forwarding Address '$fwd' for user '$User'"
                $request.Execute() | Select-Object @{N = 'User';E = {$User}},*
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
function Add-GSGmailDelegate {
    <#
    .SYNOPSIS
    Adds a delegate with its verification status set directly to accepted, without sending any verification email. The delegate user must be a member of the same G Suite organization as the delegator user.

    .DESCRIPTION
    Adds a delegate with its verification status set directly to accepted, without sending any verification email. The delegate user must be a member of the same G Suite organization as the delegator user.

    Gmail imposes limtations on the number of delegates and delegators each user in a G Suite organization can have. These limits depend on your organization, but in general each user can have up to 25 delegates and up to 10 delegators.

    Note that a delegate user must be referred to by their primary email address, and not an email alias.

    Also note that when a new delegate is created, there may be up to a one minute delay before the new delegate is available for use.

    .PARAMETER User
    User's email address to delegate access to.

    .PARAMETER Delegate
    Delegate's email address to receive delegate access.

    .EXAMPLE
    Add-GSGmailDelegate -User tony@domain.com -Delegate peter@domain.com

    Provide Peter delegate access to Tony's inbox.
    #>
    [OutputType('Google.Apis.Gmail.v1.Data.Delegate')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [Alias("From","Delegator")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User,
        [parameter(Mandatory = $true,Position = 1)]
        [Alias("To")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Delegate
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        if ($Delegate -notlike "*@*.*") {
            $Delegate = "$($Delegate)@$($Script:PSGSuite.Domain)"
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
            Write-Verbose "Adding delegate access to user '$User's inbox for delegate '$Delegate'"
            $body = New-Object 'Google.Apis.Gmail.v1.Data.Delegate' -Property @{
                DelegateEmail = $Delegate
            }
            $request = $service.Users.Settings.Delegates.Create($body,$User)
            $request.Execute()
        }
        catch {
            $origError = $_
            if ($group = Get-GSGroup -Group $User -Verbose:$false -ErrorAction SilentlyContinue) {
                Write-Warning "$User is a group email, not a user account. You can only manage delegate access for a user's inbox. Please add $Delegate to the group $User instead."
            }
            elseif ($group = Get-GSGroup -Group $Delegate -Verbose:$false -ErrorAction SilentlyContinue) {
                Write-Warning "$Delegate is a group email, not a user account. You can only delegate access to other users."
            }
            else {
                $dele = Get-GSGmailDelegates -User $User -NoGroupCheck -ErrorAction SilentlyContinue -Verbose:$false
                if ($dele.DelegateEmail -contains $Delegate -and $dele.VerificationStatus -eq 'accepted') {
                    Write-Warning "'$Delegate' already has delegate access to user '$User's inbox. No action needed."
                }
                elseif ($dele.DelegateEmail -contains $Delegate -and $dele.VerificationStatus -ne 'accepted') {
                    Write-Warning "$Delegate was already invited for delegated access to user '$User's inbox, but VerificationStatus is currently '$($dele.VerificationStatus)'"
                }
                else {
                    if ($ErrorActionPreference -eq 'Stop') {
                        $PSCmdlet.ThrowTerminatingError($origError)
                    }
                    else {
                        Write-Error $origError
                    }
                }
            }
        }
    }
}

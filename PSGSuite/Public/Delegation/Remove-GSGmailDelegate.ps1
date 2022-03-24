function Remove-GSGmailDelegate {
    <#
    .SYNOPSIS
    Removes the specified delegate (which can be of any verification status), and revokes any verification that may have been required for using it.

    .DESCRIPTION
    Removes the specified delegate (which can be of any verification status), and revokes any verification that may have been required for using it.

    Note that a delegate user must be referred to by their primary email address, and not an email alias.

    .PARAMETER User
    User's email address to remove delegate access to

    .PARAMETER Delegate
    Delegate's email address to remove

    .EXAMPLE
    Remove-GSGmailDelegate -User tony@domain.com -Delegate peter@domain.com

    Removes Peter's access to Tony's inbox.
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
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
    Process {
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
        if ($PSCmdlet.ShouldProcess("Removing delegate access for '$Delegate' from user '$User's inbox")) {
            try {
                Write-Verbose "Removing delegate access for '$Delegate' from user '$User's inbox"
                $request = $service.Users.Settings.Delegates.Delete($User,$Delegate)
                $request.Execute()
                Write-Verbose "Successfully removed delegate access for user '$User's inbox for delegate '$Delegate'"
            }
            catch {
                $origError = $_
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

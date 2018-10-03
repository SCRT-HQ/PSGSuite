function Get-GSGmailDelegate {
    <#
    .SYNOPSIS
    Gets delegates for the specified account.

    .DESCRIPTION
    Gets delegates for the specified account.

    .PARAMETER User
    User's email to get delegates for.

    .PARAMETER Delegate
    The specific delegate to get. If excluded returns the list of delegates for the user.

    .PARAMETER NoGroupCheck
    By default, this will check if the User email is a group email which cannot be delegated if the attempt to delegate access fails.

    Include this switch to prevent the group check and return the original error.

    .EXAMPLE
    Get-GSGmailDelegate -User tony@domain.com

    Gets the list of users who have delegate access to Tony's inbox.
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0)]
        [Alias("From","Delegator")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,Position = 1)]
        [Alias("To")]
        [ValidateNotNullOrEmpty()]
        [String]
        $Delegate,
        [parameter(Mandatory = $false)]
        [switch]
        $NoGroupCheck
    )
    Process {
        foreach ($U in $User) {
            if ($U -ceq 'me') {
                $U = $Script:PSGSuite.AdminEmail
            }
            elseif ($U -notlike "*@*.*") {
                $U = "$($U)@$($Script:PSGSuite.Domain)"
            }
            $serviceParams = @{
                Scope       = 'https://www.googleapis.com/auth/gmail.settings.basic'
                ServiceType = 'Google.Apis.Gmail.v1.GmailService'
                User        = $U
            }
            $service = New-GoogleService @serviceParams
            if ($PSBoundParameters.Keys -contains 'Delegate') {
                try {
                    Write-Verbose "Getting Gmail Delegate '$Delegate' for user '$U'"
                    $request = $service.Users.Settings.Delegates.Get($U,$Delegate)
                    $request.Execute()
                }
                catch {
                    $origError = $_
                    if (!$NoGroupCheck -and ($group = Get-GSGroup -Group $U -Verbose:$false -ErrorAction SilentlyContinue)) {
                        Write-Warning "$U is a group, not a user. You can only manage delegates for a user."
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
            else {
                try {
                    Write-Verbose "Getting Gmail Delegate list for user '$U'"
                    $request = $service.Users.Settings.Delegates.List($U)
                    $res = $request.Execute()
                    if ($res.Delegates) {
                        $res.Delegates | Add-Member -MemberType NoteProperty -Name Delegator -Value $U -Force -PassThru
                    }
                    else {
                        Write-Warning "No delegates found for user '$U'"
                    }
                }
                catch {
                    $origError = $_
                    if (!$NoGroupCheck -and ($group = Get-GSGroup -Group $U -Verbose:$false -ErrorAction SilentlyContinue)) {
                        Write-Warning "$U is a group, not a user. You can only manage delegates for a user."
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
}

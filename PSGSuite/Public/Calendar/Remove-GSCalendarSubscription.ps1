function Remove-GSCalendarSubscription {
    <#
    .SYNOPSIS
    Removes a calendar from a users calendar list (aka unsubscribes from the specified calendar)

    .DESCRIPTION
    Removes a calendar from a users calendar list (aka unsubscribes from the specified calendar)

    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    .PARAMETER CalendarID
    The calendar ID of the calendar you would like to unsubscribe the user from

    .EXAMPLE
    Remove-GSCalendarSubscription -User me -CalendarId john.smith@domain.com

    Removes the calendar 'john.smith@domain.com' from the AdminEmail user's calendar list

    .LINK
    https://psgsuite.io/Function%20Help/Calendar/Remove-GSCalendarSubscription/
    #>
    [cmdletbinding(SupportsShouldProcess = $true,ConfirmImpact = "High")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User,
        [parameter(Mandatory = $true,Position = 1)]
        [String[]]
        $CalendarId
    )
    Begin {
        if ($User -ceq 'me') {
            $User = $Script:PSGSuite.AdminEmail
        }
        elseif ($User -notlike "*@*.*") {
            $User = "$($User)@$($Script:PSGSuite.Domain)"
        }
        $serviceParams = @{
            Scope       = 'https://www.googleapis.com/auth/calendar'
            ServiceType = 'Google.Apis.Calendar.v3.CalendarService'
            User        = $User
        }
        $service = New-GoogleService @serviceParams
    }
    Process {
        foreach ($calId in $CalendarID) {
            try {
                if ($PSCmdlet.ShouldProcess("Unsubscribing user '$User' from Calendar '$($calId)'")) {
                    Write-Verbose "Unsubscribing user '$User' from Calendar '$($calId)'"
                    $request = $service.CalendarList.Delete($calId)
                    $request.Execute()
                    Write-Verbose "User '$User' has been successfully unsubscribed from calendar '$calId'"
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
}

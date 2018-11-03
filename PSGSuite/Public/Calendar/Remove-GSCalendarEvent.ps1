function Remove-GSCalendarEvent {
    <#
    .SYNOPSIS
    Removes a calendar event
    
    .DESCRIPTION
    Removes a calendar event

    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config. 

    Defaults to the AdminEmail in the config.
    
    .PARAMETER CalendarID
    The calendar ID of the calendar you would like to list events from.

    Defaults to the user's primary calendar.

    .PARAMETER EventID
    The EventID to remove

    .EXAMPLE
    Remove-GSCalendarEvent -User user@domain.com -EventID _60q30c1g60o30e1i60o4ac1g60rj8gpl88rj2c1h84s34h9g60s30c1g60o30c1g84o3eg9n8gq32d246gq48d1g64o30c1g60o30c1g60o30c1g60o32c1g60o30c1g8csjihhi6oq3igi28h248ghk6ks4agq161144ga46gr4aci488p0

    Removes the specified event from user@domain.com's calendar.
    #>
    Param
    (
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $CalendarID = "primary",
        [parameter(Mandatory = $true,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $EventID
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
        try {
            foreach ($E in $EventId) {
                Write-Verbose "Deleting Event Id '$E' from user '$User'"
                $request = $service.Events.Delete($CalendarID, $E)
                $request.Execute()
                Write-Verbose "Label Id '$E' deleted successfully from user '$User'"
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
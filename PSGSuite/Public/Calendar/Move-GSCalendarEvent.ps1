function Move-GSCalendarEvent {
    <#
    .SYNOPSIS
    Moves an event to a new calendar (updates the Organizer).

    .DESCRIPTION
    Moves an event to a new calendar (updates the Organizer).

    .PARAMETER CalendarID
    The Id of the source calendar.

    Defaults to the user's primary calendar.

    .PARAMETER EventID
    The unique Id of the event to update

    .PARAMETER DestinationCalendarId
    The Id of the destination calendar.

    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config.

    User must have access to both calendars.  Recommend using admin.

    .PARAMETER SendUpdates
    Whether to send update notifications to the attendees.

    Possible values are:
    * "none" - No notifications are sent.
    * "externalOnly" - Notifications are sent to non-Google Calendar guests only.
    * "all" - Notifications are sent to all guests.

    .EXAMPLE
    Move-GSCalendarEvent -CalendarId source.calendar@domain.com -EventId bcfgr7j83oqpv8174bnamv63pj -DestinationCalendarId target.calendar@domain.com

    Moves the event with eventId "bcfgr7j83oqpv8174bnamv63pj" from calendar "source.calendar@domain.com" to calendar "target.calendar@domain.com"
    #>
    [OutputType('Google.Apis.Calendar.v3.Data.Event')]
    [cmdletbinding(DefaultParameterSetName = "AttendeeEmails")]
    Param
    (
        [parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [String]
        $EventId,
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [String]
        $CalendarId = "primary",
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail", "UserKey", "Mail")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $false)]
        [String]
        $DestinationCalendarId,
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $false)]
        [ValidateSet("none", "all", "externalOnly")]
        [String]
        $SendUpdates = "none"
    )
    Process {
        try {
            if ($Uuser -ceq 'me') {
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
            Write-Verbose "Moving Calendar Event '$EventId' on calendar '$CalendarId' for user '$User' to calendar '$DestinationCalendarId'"
            $request = $service.Events.Move($CalendarId, $EventId, $DestinationCalendarId)
            $request.SendUpdates = $SendUpdates
            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru | Add-Member -MemberType NoteProperty -Name 'CalendarId' -Value $DestinationCalendarId -PassThru
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

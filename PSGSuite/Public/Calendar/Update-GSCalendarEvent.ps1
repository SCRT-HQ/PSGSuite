function Update-GSCalendarEvent {
    <#
    .SYNOPSIS
    Updates an event
    
    .DESCRIPTION
    Updates an event
    
    .PARAMETER EventID
    The unique Id of the event to update
    
    .PARAMETER CalendarID
    The Id of the calendar

    Defaults to the user's primary calendar.

    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config. 

    Defaults to the AdminEmail in the config.
    
    .PARAMETER Summary
    Event summary
    
    .PARAMETER Description
    Event description
    
    .PARAMETER AttendeeEmails
    The email addresses of the attendees to add. 
    
    NOTE: This performs simple adds without additional attendee options. If additional options are needed, use the Attendees parameter instead.
    
    .PARAMETER Attendees
    The EventAttendee object(s) to add. Use Add-GSEventAttendee with this parameter for best results.
    
    .PARAMETER Location
    Event location
    
    .PARAMETER EventColor
    Color of the event as seen in Calendar
    
    .PARAMETER LocalStartDateTime
    Start date and time of the event. Lowest precendence of the three StartDate parameters.

    Defaults to the time the function is ran.
    
    .PARAMETER LocalEndDateTime
    End date and time of the event. Lowest precendence of the three EndDate parameters.

    Defaults to 30 minutes after the time the function is ran.
    
    .PARAMETER StartDate
    String representation of the start date. Middle precendence of the three StartDate parameters.
    
    .PARAMETER EndDate
    String representation of the end date. Middle precendence of the three EndDate parameters.
    
    .PARAMETER UTCStartDateTime
    String representation of the start date in UTC. Highest precendence of the three StartDate parameters.
    
    .PARAMETER UTCEndDateTime
    String representation of the end date in UTC. Highest precendence of the three EndDate parameters.
    
    .EXAMPLE
    New-GSCalendarEvent "Go to the gym" -StartDate (Get-Date "21:00:00") -EndDate (Get-Date "22:00:00")

    Creates an event titled "Go to the gym" for 9-10PM the day the function is ran.
    #>
    [cmdletbinding(DefaultParameterSetName = "AttendeeEmails")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $EventId,
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [String[]]
        $CalendarId = "primary",
        [parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [String]
        $Summary,
        [parameter(Mandatory = $false)]
        [String]
        $Description,
        [parameter(Mandatory = $false,ParameterSetName = "AttendeeEmails")]
        [String[]]
        $AttendeeEmails,
        [parameter(Mandatory = $false,ParameterSetName = "AttendeeObjects")]
        [Google.Apis.Calendar.v3.Data.EventAttendee[]]
        $Attendees,
        [parameter(Mandatory = $false)]
        [String]
        $Location,
        [parameter(Mandatory = $false)]
        [ValidateSet("Periwinkle","Seafoam","Lavender","Coral","Goldenrod","Beige","Cyan","Grey","Blue","Green","Red")]
        [String]
        $EventColor,
        [parameter(Mandatory = $false)]
        [DateTime]
        $LocalStartDateTime,
        [parameter(Mandatory = $false)]
        [DateTime]
        $LocalEndDateTime,
        [parameter(Mandatory = $false)]
        [String]
        $StartDate,
        [parameter(Mandatory = $false)]
        [String]
        $EndDate,
        [parameter(Mandatory = $false)]
        [String]
        $UTCStartDateTime,
        [parameter(Mandatory = $false)]
        [String]
        $UTCEndDateTime
    )
    Begin {
        $colorHash = @{
            Periwinkle = 1
            Seafoam    = 2
            Lavender   = 3
            Coral      = 4
            Goldenrod  = 5
            Beige      = 6
            Cyan       = 7
            Grey       = 8
            Blue       = 9
            Green      = 10
            Red        = 11
        }
    }
    Process {
        try {
            foreach ($U in $User) {
                if ($U -ceq 'me') {
                    $U = $Script:PSGSuite.AdminEmail
                }
                elseif ($U -notlike "*@*.*") {
                    $U = "$($U)@$($Script:PSGSuite.Domain)"
                }
                $serviceParams = @{
                    Scope       = 'https://www.googleapis.com/auth/calendar'
                    ServiceType = 'Google.Apis.Calendar.v3.CalendarService'
                    User        = $U
                }
                $service = New-GoogleService @serviceParams
                if ($PSCmdlet.ParameterSetName -eq 'AttendeeEmails' -and $PSBoundParameters.Keys -contains 'AttendeeEmails') {
                    [Google.Apis.Calendar.v3.Data.EventAttendee[]]$Attendees = $AttendeeEmails | ForEach-Object {
                        Add-GSEventAttendee -Email $_
                    }
                }
                foreach ($calId in $CalendarID) {
                    $body = New-Object 'Google.Apis.Calendar.v3.Data.Event'
                    if ($Attendees) {
                        $body.Attendees = [Google.Apis.Calendar.v3.Data.EventAttendee[]]$Attendees
                    }
                    foreach ($key in $PSBoundParameters.Keys) {
                        switch ($key) {
                            EventColor {
                                $body.ColorId = $colorHash[$EventColor]
                            }
                            Default {
                                if ($body.PSObject.Properties.Name -contains $key) {
                                    $body.$key = $PSBoundParameters[$key]
                                }
                            }
                        }
                    }
                    $body.Start = if ($UTCStartDateTime) {
                        New-Object 'Google.Apis.Calendar.v3.Data.EventDateTime' -Property @{
                            DateTime = $UTCStartDateTime
                        }
                    }
                    elseif ($StartDate) {
                        New-Object 'Google.Apis.Calendar.v3.Data.EventDateTime' -Property @{
                            Date = (Get-Date $StartDate -Format "yyyy-MM-dd")
                        }
                    }
                    else {
                        New-Object 'Google.Apis.Calendar.v3.Data.EventDateTime' -Property @{
                            DateTime = $LocalStartDateTime
                        }
                    }
                    $body.End = if ($UTCEndDateTime) {
                        New-Object 'Google.Apis.Calendar.v3.Data.EventDateTime' -Property @{
                            DateTime = $UTCEndDateTime
                        }
                    }
                    elseif ($EndDate) {
                        New-Object 'Google.Apis.Calendar.v3.Data.EventDateTime' -Property @{
                            Date = (Get-Date $EndDate -Format "yyyy-MM-dd")
                        }
                    }
                    else {
                        New-Object 'Google.Apis.Calendar.v3.Data.EventDateTime' -Property @{
                            DateTime = $LocalEndDateTime
                        }
                    }
                    foreach ($evId in $EventId) {
                        Write-Verbose "Updating Calendar Event '$evId' on calendar '$calId' for user '$U'"
                        $request = $service.Events.Patch($body,$calId,$evId)
                        $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru | Add-Member -MemberType NoteProperty -Name 'CalendarId' -Value $calId -PassThru | Add-Member -MemberType NoteProperty -Name 'EventId' -Value $evId -PassThru
                    }
                }
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
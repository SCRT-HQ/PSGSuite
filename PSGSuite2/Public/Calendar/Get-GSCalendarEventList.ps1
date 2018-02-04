function Get-GSCalendarEventList {
    <#
    .SYNOPSIS
    Gets the calendar events for a user
    
    .DESCRIPTION
    Gets the calendar events for a user
    
    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config.
    
    .PARAMETER CalendarID
    The calendar ID of the calendar you would like to list events from.

    Defaults to the user's primary calendar.
    
    .PARAMETER Filter
    Free text search terms to find events that match these terms in any field, except for extended properties. 
    
    .PARAMETER OrderBy
    The order of the events returned in the result.

    Acceptable values are:
    * "startTime": Order by the start date/time (ascending). This is only available when querying single events (i.e. the parameter singleEvents is True)
    * "updated": Order by last modification time (ascending).
    
    .PARAMETER MaxAttendees
    The maximum number of attendees to include in the response. If there are more than the specified number of attendees, only the participant is returned.
    
    .PARAMETER PageSize
    Maximum number of events returned on one result page.
    
    .PARAMETER ShowDeleted
    Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events (but not the underlying recurring event) will still be included if showDeleted and singleEvents are both False. If showDeleted and singleEvents are both True, only single instances of deleted events (but not the underlying recurring events) are returned.
    
    .PARAMETER ShowHiddenInvitations
    Whether to include hidden invitations in the result.
    
    .PARAMETER SingleEvents
    Whether to expand recurring events into instances and only return single one-off events and instances of recurring events, but not the underlying recurring events themselves.
    
    .PARAMETER TimeMin
    Lower bound (inclusive) for an event's end time to filter by. If TimeMax is set, TimeMin must be smaller than timeMax.
    
    .PARAMETER TimeMax
    Upper bound (exclusive) for an event's start time to filter by. If TimeMin is set, TimeMax must be greater than timeMin.
    
    .EXAMPLE
    Get-GSCalendarEventList -TimeMin (Get-Date "01-21-2018 00:00:00") -TimeMax (Get-Date "01-28-2018 23:59:59") -SingleEvents
    
    This gets the single events on the primary calendar of the Admin for the week of Jan 21-28, 2018.
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false)]
        [String]
        $CalendarID = "primary",
        [parameter(Mandatory = $false)]
        [Alias('Q','Query')]
        [String]
        $Filter,
        [parameter(Mandatory = $false)]
        [ValidateSet("StartTime","Updated")]
        [String]
        $OrderBy,
        [parameter(Mandatory = $false)]
        [Int]
        $MaxAttendees,
        [parameter(Mandatory = $false)]
        [ValidateRange(1,2500)]
        [Int]
        $PageSize = 2500,
        [parameter(Mandatory = $false)]
        [switch]
        $ShowDeleted,
        [parameter(Mandatory = $false)]
        [switch]
        $ShowHiddenInvitations,
        [parameter(Mandatory = $false)]
        [switch]
        $SingleEvents,
        [parameter(Mandatory = $false)]
        [DateTime]
        $TimeMin,
        [parameter(Mandatory = $false)]
        [DateTime]
        $TimeMax
    )
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
                foreach ($calId in $CalendarID) {
                    $request = $service.Events.List($calId)
                    foreach ($key in $PSBoundParameters.Keys) {
                        switch ($key) {
                            Filter {
                                $request.Q = $Filter
                            }
                            Default {
                                if ($request.PSObject.Properties.Name -contains $key) {
                                    $request.$key = $PSBoundParameters[$key]
                                }
                            }
                        }
                    }
                    if ($PageSize) {
                        $request.MaxResults = $PageSize
                    }
                    if ($Filter) {
                        Write-Verbose "Getting all Calendar Events matching filter '$Filter' on calendar '$calId' for user '$U'"
                    }
                    else {
                        Write-Verbose "Getting all Calendar Events on calendar '$calId' for user '$U'"
                    }
                    $response = @()
                    [int]$i = 1
                    do {
                        $result = $request.Execute()
                        $response += $result.Items | Select-Object @{N = 'User';E = {$U}},@{N = 'CalendarId';E = {$calId}},*
                        if ($result.NextPageToken) {
                            $request.PageToken = $result.NextPageToken
                        }
                        [int]$retrieved = ($i + $result.Items.Count) - 1
                        Write-Verbose "Retrieved $retrieved Calendar Events..."
                        [int]$i = $i + $result.Items.Count
                    }
                    until (!$result.NextPageToken)
                    $response
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}
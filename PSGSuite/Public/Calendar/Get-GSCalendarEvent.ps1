function Get-GSCalendarEvent {
    <#
    .SYNOPSIS
    Gets the calendar events for a user

    .DESCRIPTION
    Gets the calendar events for a user

    .PARAMETER EventId
    The Id of the event to get info for

    .PARAMETER CalendarId
    The calendar ID of the calendar you would like to list events from.

    Defaults to the user's primary calendar

    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config

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

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .PARAMETER ShowDeleted
    Whether to include deleted events (with status equals "cancelled") in the result. Cancelled instances of recurring events (but not the underlying recurring event) will still be included if showDeleted and singleEvents are both False. If showDeleted and singleEvents are both True, only single instances of deleted events (but not the underlying recurring events) are returned.

    .PARAMETER ShowHiddenInvitations
    Whether to include hidden invitations in the result.

    .PARAMETER SingleEvents
    Whether to expand recurring events into instances and only return single one-off events and instances of recurring events, but not the underlying recurring events themselves.

    .PARAMETER PrivateExtendedProperty
    Extended properties constraint specified as a hashtable where propertyName=value. Matches only private properties.

    .PARAMETER SharedExtendedProperty
    Extended properties constraint specified as a hashtable where propertyName=value. Matches only shared properties.

    .PARAMETER TimeMin
    Lower bound (inclusive) for an event's end time to filter by. If TimeMax is set, TimeMin must be smaller than timeMax.

    .PARAMETER TimeMax
    Upper bound (exclusive) for an event's start time to filter by. If TimeMin is set, TimeMax must be greater than timeMin.

    .EXAMPLE
    Get-GSCalendarEventList -TimeMin (Get-Date "01-21-2018 00:00:00") -TimeMax (Get-Date "01-28-2018 23:59:59") -SingleEvents

    This gets the single events on the primary calendar of the Admin for the week of Jan 21-28, 2018.
    #>
    [OutputType('Google.Apis.Calendar.v3.Data.Event')]
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ParameterSetName = "Get")]
        [String[]]
        $EventId,
        [parameter(Mandatory = $false)]
        [String]
        $CalendarId = "primary",
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('Q','Query')]
        [String]
        $Filter,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateSet("StartTime","Updated")]
        [String]
        $OrderBy,
        [parameter(Mandatory = $false)]
        [Int]
        $MaxAttendees,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [ValidateRange(1,2500)]
        [Int]
        $PageSize = 2500,
        [parameter(Mandatory = $false,ParameterSetName = 'List')]
        [Alias('First')]
        [Int]
        $Limit = 0,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [switch]
        $ShowDeleted,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [switch]
        $ShowHiddenInvitations,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [switch]
        $SingleEvents,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Hashtable]
        $PrivateExtendedProperty,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Hashtable]
        $SharedExtendedProperty,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [DateTime]
        $TimeMin,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [DateTime]
        $TimeMax
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
                Scope       = 'https://www.googleapis.com/auth/calendar'
                ServiceType = 'Google.Apis.Calendar.v3.CalendarService'
                User        = $U
            }
            $service = New-GoogleService @serviceParams
            foreach ($calId in $CalendarId) {
                switch ($PSCmdlet.ParameterSetName) {
                    Get {
                        foreach ($evId in $EventId) {
                            try {
                                $request = $service.Events.Get($calId,$evId)
                                if ($PSBoundParameters.Keys -contains 'MaxAttendees') {
                                    $request.MaxAttendees = $MaxAttendees
                                }
                                Write-Verbose "Getting Event ID '$evId' from Calendar '$calId' for User '$U'"
                                $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru | Add-Member -MemberType NoteProperty -Name 'CalendarId' -Value $calId -PassThru
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
                    List {
                        try {
                            $request = $service.Events.List($calId)
                            foreach ($key in $PSBoundParameters.Keys | Where-Object {$_ -ne 'CalendarId'}) {
                                switch ($key) {
                                    Filter {
                                        $request.Q = $Filter
                                    }
                                    PrivateExtendedProperty {
                                        $converted = $PrivateExtendedProperty.Keys | Foreach-Object {
                                            "$($_)=$($PrivateExtendedProperty[$_])"
                                        }
                                        $repeatable = [Google.Apis.Util.Repeatable[String]]::new([String[]]$converted)
                                        $request.PrivateExtendedProperty = $repeatable
                                    }
                                    SharedExtendedProperty {
                                        $converted = $SharedExtendedProperty.Keys | Foreach-Object {
                                            "$($_)=$($SharedExtendedProperty[$_])"
                                        }
                                        $repeatable = [Google.Apis.Util.Repeatable[String]]::new([String[]]$converted)
                                        $request.SharedExtendedProperty = $repeatable
                                    }
                                    Default {
                                        if ($request.PSObject.Properties.Name -contains $key) {
                                            $request.$key = $PSBoundParameters[$key]
                                        }
                                    }
                                }
                            }
                            if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                                Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                                $PageSize = $Limit
                            }
                            $request.MaxResults = $PageSize
                            if ($Filter) {
                                Write-Verbose "Getting all Calendar Events matching filter '$Filter' on calendar '$calId' for user '$U'"
                            }
                            else {
                                Write-Verbose "Getting all Calendar Events on calendar '$calId' for user '$U'"
                            }
                            [int]$i = 1
                            $overLimit = $false
                            do {
                                $result = $request.Execute()
                                $result.Items | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru | Add-Member -MemberType NoteProperty -Name 'CalendarId' -Value $calId -PassThru
                                if ($result.NextPageToken) {
                                    $request.PageToken = $result.NextPageToken
                                }
                                [int]$retrieved = ($i + $result.Items.Count) - 1
                                Write-Verbose "Retrieved $retrieved Calendar Events..."
                                if ($Limit -gt 0 -and $retrieved -eq $Limit) {
                                    Write-Verbose "Limit reached: $Limit"
                                    $overLimit = $true
                                }
                                elseif ($Limit -gt 0 -and ($retrieved + $PageSize) -gt $Limit) {
                                    $newPS = $Limit - $retrieved
                                    Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with next page" -f $PageSize,$newPS)
                                    $request.MaxResults = $newPS
                                }
                                [int]$i = $i + $result.Items.Count
                            }
                            until ($overLimit -or !$result.NextPageToken)
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
        }
    }
}

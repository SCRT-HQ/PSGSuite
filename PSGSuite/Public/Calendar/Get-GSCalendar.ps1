function Get-GSCalendar {
    <#
    .SYNOPSIS
    Gets the calendars for a user

    .DESCRIPTION
    Gets the calendars for a user

    .PARAMETER CalendarId
    The Id of the calendar you would like to get.

    If excluded, returns the list of calendars for the user.

    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config

    .PARAMETER MinAccessRole
    The minimum access role for the user in the returned entries. Optional. The default is no restriction.

    .PARAMETER PageSize
    Maximum number of entries returned on one result page. The page size can never be larger than 250 entries.

    .PARAMETER Limit
    The maximum amount of results you want returned. Exclude or set to 0 to return all results

    .PARAMETER ShowDeleted
    Whether to include deleted calendar list entries in the result. Optional. The default is False.

    .PARAMETER ShowHidden
    Whether to show hidden entries. Optional. The default is False.

    .PARAMETER SyncToken
    Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then.

    If only read-only fields such as calendar properties or ACLs have changed, the entry won't be returned. All entries deleted and hidden since the previous list request will always be in the result set and it is not allowed to set showDeleted neither showHidden to False.

    To ensure client state consistency minAccessRole query parameter cannot be specified together with nextSyncToken. If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken. Learn more about incremental synchronization.

    Optional. The default is to return all entries.

    .EXAMPLE
    Get-GSCalendar

    Gets the list of calendar subscriptions for the AdminEmail user.

    .LINK
    https://psgsuite.io/Function%20Help/Calendar/Get-GSCalendar/

    .LINK
    https://developers.google.com/calendar/v3/reference/calendarList/get

    .LINK
    https://developers.google.com/calendar/v3/reference/calendarList/list
    #>
    [OutputType('Google.Apis.Calendar.v3.Data.CalendarListEntry')]
    [cmdletbinding(DefaultParameterSetName = "List")]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ParameterSetName = "Get")]
        [String[]]
        $CalendarId,
        [parameter(Mandatory = $false,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Google.Apis.Calendar.v3.CalendarListResource+ListRequest+MinAccessRoleEnum]
        $MinAccessRole,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('MaxResults')]
        [ValidateRange(1,250)]
        [Int]
        $PageSize = 250,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [Alias('First')]
        [Int]
        $Limit = 0,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [switch]
        $ShowDeleted,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [switch]
        $ShowHidden,
        [parameter(Mandatory = $false,ParameterSetName = "List")]
        [String]
        $SyncToken
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
            switch ($PSCmdlet.ParameterSetName) {
                Get {
                    foreach ($calId in $CalendarId) {
                        try {
                            $request = $service.Calendars.Get($calId)
                            Write-Verbose "Getting Calendar Id '$calId' for User '$U'"
                            $request.Execute() | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
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
                        $request = $service.Calendars.List()
                        foreach ($key in $PSBoundParameters.Keys | Where-Object {$_ -ne 'CalendarId'}) {
                            if ($request.PSObject.Properties.Name -contains $key) {
                                $request.$key = $PSBoundParameters[$key]
                            }
                        }
                        if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                            Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                            $PageSize = $Limit
                        }
                        $request.MaxResults = $PageSize
                        Write-Verbose "Getting Calendars for user '$U'"
                        [int]$i = 1
                        $overLimit = $false
                        do {
                            $result = $request.Execute()
                            $result.Items | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
                            if ($result.NextPageToken) {
                                $request.PageToken = $result.NextPageToken
                            }
                            [int]$retrieved = ($i + $result.Items.Count) - 1
                            Write-Verbose "Retrieved $retrieved Calendars..."
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

function Get-GSCalendarSubscription {
    <#
    .SYNOPSIS
    Gets a subscribed calendar from a users calendar list. Returns the full calendar list if no CalendarId is specified.

    .DESCRIPTION
    Gets a subscribed calendar from a users calendar list. Returns the full calendar list if no CalendarId is specified.

    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    Defaults to the AdminEmail in the config

    .PARAMETER CalendarID
    The calendar ID of the calendar you would like to get info for. If left blank, returns the list of calendars the user is subscribed to.

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
    Get-GSCalendarSubscription

    Gets the AdminEmail user's calendar list

    .LINK
    https://psgsuite.io/Function%20Help/Calendar/Get-GSCalendarSubscription/

    .LINK
    https://developers.google.com/calendar/v3/reference/calendarList/get

    .LINK
    https://developers.google.com/calendar/v3/reference/calendarList/list
    #>
    [OutputType('Google.Apis.Calendar.v3.Data.CalendarListEntry')]
    [cmdletbinding(DefaultParameterSetName = 'List')]
    Param (
        [parameter(Mandatory,Position = 0,ValueFromPipelineByPropertyName,ParameterSetName = "Get")]
        [Alias('Id')]
        [String[]]
        $CalendarId,
        [parameter(ValueFromPipelineByPropertyName)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(ParameterSetName = "List")]
        [Google.Apis.Calendar.v3.CalendarListResource+ListRequest+MinAccessRoleEnum]
        $MinAccessRole,
        [parameter(ParameterSetName = "List")]
        [Alias('MaxResults')]
        [ValidateRange(1,250)]
        [Int]
        $PageSize = 250,
        [parameter(ParameterSetName = "List")]
        [Alias('First')]
        [Int]
        $Limit = 0,
        [parameter(ParameterSetName = "List")]
        [switch]
        $ShowDeleted,
        [parameter(ParameterSetName = "List")]
        [switch]
        $ShowHidden,
        [parameter(ParameterSetName = "List")]
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
            if ($PSCmdlet.ParameterSetName -eq 'Get') {
                foreach ($calId in $CalendarID) {
                    try {
                        Write-Verbose "Getting subscribed calendar '$($calId)' for user '$U'"
                        $request = $service.CalendarList.Get($calId)
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
            else {
                try {
                    $request = $service.CalendarList.List()
                    foreach ($key in $PSBoundParameters.Keys | Where-Object {$request.PSObject.Properties.Name -contains $_}) {
                        $request.$key = $PSBoundParameters[$key]
                    }
                    if ($Limit -gt 0 -and $PageSize -gt $Limit) {
                        Write-Verbose ("Reducing PageSize from {0} to {1} to meet limit with first page" -f $PageSize,$Limit)
                        $PageSize = $Limit
                    }
                    $request.MaxResults = $PageSize
                    Write-Verbose "Getting CalendarList for user '$U'"
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

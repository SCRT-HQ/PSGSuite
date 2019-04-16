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

    .PARAMETER ShowDeleted
    Whether to include deleted calendar list entries in the result. Optional. The default is False.

    .PARAMETER ShowHidden
    Whether to show hidden entries. Optional. The default is False.

    .PARAMETER SyncToken
    Token obtained from the nextSyncToken field returned on the last page of results from the previous list request. It makes the result of this list request contain only entries that have changed since then.

    If only read-only fields such as calendar properties or ACLs have changed, the entry won't be returned. All entries deleted and hidden since the previous list request will always be in the result set and it is not allowed to set showDeleted neither showHidden to False.

    To ensure client state consistency minAccessRole query parameter cannot be specified together with nextSyncToken. If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken. Learn more about incremental synchronization.

    Optional. The default is to return all entries.
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
                            $request = $service.CalendarList.Get($calId)
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
                        $request = $service.CalendarList.List()
                        foreach ($key in $PSBoundParameters.Keys | Where-Object {$_ -ne 'CalendarId'}) {
                            if ($request.PSObject.Properties.Name -contains $key) {
                                $request.$key = $PSBoundParameters[$key]
                            }
                        }
                        if ($PageSize) {
                            $request.MaxResults = $PageSize
                        }
                        Write-Verbose "Getting Calendar List for user '$U'"
                        [int]$i = 1
                        do {
                            $result = $request.Execute()
                            $result.Items | Add-Member -MemberType NoteProperty -Name 'User' -Value $U -PassThru
                            if ($result.NextPageToken) {
                                $request.PageToken = $result.NextPageToken
                            }
                            [int]$retrieved = ($i + $result.Items.Count) - 1
                            Write-Verbose "Retrieved $retrieved Calendars..."
                            [int]$i = $i + $result.Items.Count
                        }
                        until (!$result.NextPageToken)
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

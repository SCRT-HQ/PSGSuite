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

    .PARAMETER ShowDeleted
    Whether to include deleted calendar list entries in the result. Optional. The default is False.

    .PARAMETER ShowHidden
    Whether to show hidden entries. Optional. The default is False.

    .EXAMPLE
    Get-GSCalendarSubscription

    Gets the AdminEmail user's calendar list

    .LINK
    https://psgsuite.io/Function%20Help/Calendar/Get-GSCalendarSubscription/
    #>
    [OutputType('Google.Apis.Calendar.v3.Data.CalendarListEntry')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $false,Position = 0)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User = $Script:PSGSuite.AdminEmail,
        [parameter(Mandatory = $false,Position = 1)]
        [String[]]
        $CalendarId,
        [Parameter(Mandatory = $false)]
        [Switch]
        $ShowDeleted,
        [Parameter(Mandatory = $false)]
        [Switch]
        $ShowHidden
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
        if ($PSBoundParameters.Keys -contains 'CalendarId') {
            foreach ($calId in $CalendarID) {
                try {
                    Write-Verbose "Getting subscribed calendar '$($calId)' for user '$User'"
                    $request = $service.CalendarList.Get($calId)
                    $request.Execute()
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
                Write-Verbose "Getting subscribed calendar list for user '$User'"
                $request = $service.CalendarList.List()
                foreach ($key in $PSBoundParameters.Keys | Where-Object {$request.PSObject.Properties.Name -contains $_}) {
                    $request.$key = $PSBoundParameters[$key]
                }
                [int]$i = 1
                do {
                    $result = $request.Execute()
                    $result.Items | Add-Member -MemberType NoteProperty -Name 'User' -Value $User -PassThru
                    $request.PageToken = $result.NextPageToken
                    [int]$retrieved = ($i + $result.Items.Count) - 1
                    Write-Verbose "Retrieved $retrieved Calendar Subscriptions..."
                    [int]$i = $i + $result.Items.Count
                }
                until (-not $result.NextPageToken)
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

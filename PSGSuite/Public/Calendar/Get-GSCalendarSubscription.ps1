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
        [Parameter(Mandatory = $false, Position = 2)]
        [bool]
        $ShowDeleted = $false,
        [Parameter(Mandatory = $false, Position = 3)]
        [bool]
        $ShowHidden = $false
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
                If ($ShowDeleted -eq $true){
                    $request.$ShowDeleted = $true
                }
                If ($ShowHidden -eq $true){
                    $request.$ShowHidden = $true
                }
                $raw = $request.Execute()
                $ItemList = [object[]]($raw | Select-Object -ExpandProperty Items)
                While ($Null -ne $raw.NextPageToken){
                    $request.SetPageToken($raw.NextPageToken)
                    $raw = $request.Execute()
                    $ItemList += $raw | Select-Object -ExpandProperty Items
                }
                $ItemList
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

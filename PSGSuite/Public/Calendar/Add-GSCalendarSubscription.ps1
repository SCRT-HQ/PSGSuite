function Add-GSCalendarSubscription {
    <#
    .SYNOPSIS
    Adds a calendar to a users calendar list (aka subscribes to the specified calendar)

    .DESCRIPTION
    Adds a calendar to a users calendar list (aka subscribes to the specified calendar)

    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    .PARAMETER CalendarID
    The calendar ID of the calendar you would like to subscribe the user to

    .PARAMETER ColorRgbFormat
    Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically.

    .PARAMETER Selected
    Whether the calendar content shows up in the calendar UI. Optional. The default is False.

    .PARAMETER Hidden
    Whether the calendar has been hidden from the list. Optional. The default is False.

    .PARAMETER Reminders
    A list of reminders to add to this calendar.

    This parameter expects a 'Google.Apis.Calendar.v3.Data.EventReminder[]' object type. You can create objects of this type easily by using the function 'Add-GSCalendarEventReminder'

    .PARAMETER DefaultReminderMethod
    The method used by this reminder. Defaults to email.

    Possible values are:
    * "email" - Reminders are sent via email.
    * "sms" - Reminders are sent via SMS. These are only available for G Suite customers. Requests to set SMS reminders for other account types are ignored.
    * "popup" - Reminders are sent via a UI popup.

    .PARAMETER DefaultReminderMinutes
    Number of minutes before the start of the event when the reminder should trigger. Defaults to 30 minutes.

    Valid values are between 0 and 40320 (4 weeks in minutes).

    .PARAMETER Notifications
    A list of notifications to add to this calendar.

    This parameter expects a 'Google.Apis.Calendar.v3.Data.CalendarNotification[]' object type. You can create objects of this type easily by using the function 'Add-GSCalendarNotification'

    .PARAMETER DefaultNotificationMethod
    The method used to deliver the notification.

    Possible values are:
    * "email" - Reminders are sent via email.
    * "sms" - Reminders are sent via SMS. This value is read-only and is ignored on inserts and updates. SMS reminders are only available for G Suite customers.

    .PARAMETER DefaultNotificationType
    The type of notification.

    Possible values are:
    * "eventCreation" - Notification sent when a new event is put on the calendar.
    * "eventChange" - Notification sent when an event is changed.
    * "eventCancellation" - Notification sent when an event is cancelled.
    * "eventResponse" - Notification sent when an event is changed.
    * "agenda" - An agenda with the events of the day (sent out in the morning).

    .PARAMETER Color
    The color of the calendar.

    .PARAMETER SummaryOverride
    The summary that the authenticated user has set for this calendar.

    .EXAMPLE
    Add-GSCalendarSubscription -User me -CalendarId john.smith@domain.com -Selected -Color Cyan

    Adds the calendar 'john.smith@domain.com' to the AdminEmail user's calendar list

    .LINK
    https://psgsuite.io/Function%20Help/Calendar/Add-GSCalendarSubscription/

    .LINK
    https://developers.google.com/calendar/v3/reference/calendarList/insert
    #>
    [OutputType('Google.Apis.Calendar.v3.Data.CalendarListEntry')]
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory,Position = 0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User,
        [parameter(Mandatory,Position = 1)]
        [String[]]
        $CalendarId,
        [parameter(Mandatory = $false)]
        [Switch]
        $ColorRgbFormat,
        [parameter()]
        [Switch]
        $Selected,
        [parameter()]
        [Switch]
        $Hidden,
        [parameter()]
        [Google.Apis.Calendar.v3.Data.EventReminder[]]
        $Reminders,
        [parameter()]
        [ValidateSet('email','sms','popup')]
        [String]
        $DefaultReminderMethod,
        [parameter()]
        [ValidateRange(0,40320)]
        [Int]
        $DefaultReminderMinutes = 30,
        [parameter()]
        [Google.Apis.Calendar.v3.Data.CalendarNotification[]]
        $Notifications,
        [parameter()]
        [ValidateSet('email','sms')]
        [String]
        $DefaultNotificationMethod,
        [parameter()]
        [ValidateSet('eventCreation','eventChange','eventCancellation','eventResponse','agenda')]
        [String]
        $DefaultNotificationType,
        [parameter()]
        [ValidateSet("Periwinkle","Seafoam","Lavender","Coral","Goldenrod","Beige","Cyan","Grey","Blue","Green","Red")]
        [String]
        $Color,
        [parameter()]
        [String]
        $SummaryOverride
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
            foreach ($calId in $CalendarID) {
                $body = New-Object 'Google.Apis.Calendar.v3.Data.CalendarListEntry' -Property @{
                    Id = $calId
                    Selected = $Selected
                    Hidden = $Hidden
                }
                if ($PSBoundParameters.ContainsKey('Reminders')) {
                    $body.DefaultReminders = $Reminders
                }
                elseif ($PSBoundParameters.ContainsKey('DefaultReminderMethod')) {
                    $DefaultReminders = New-Object 'Google.Apis.Calendar.v3.Data.EventReminder' -Property @{
                        Method = $DefaultReminderMethod
                        Minutes = $DefaultReminderMinutes
                    }
                    $body.DefaultReminders = [Google.Apis.Calendar.v3.Data.EventReminder[]]$DefaultReminders
                }
                if ($PSBoundParameters.ContainsKey('Notifications')) {
                    $body.NotificationSettings = New-Object 'Google.Apis.Calendar.v3.Data.CalendarListEntry+NotificationSettingsData' -Property @{
                        Notifications = [Google.Apis.Calendar.v3.Data.CalendarNotification[]]$Notifications
                    }
                }
                elseif ($PSBoundParameters.ContainsKey('DefaultNotificationMethod') -or $PSBoundParameters.ContainsKey('DefaultNotificationType')) {
                    $DefaultNotification = New-Object 'Google.Apis.Calendar.v3.Data.CalendarNotification'
                    if ($PSBoundParameters.ContainsKey('DefaultNotificationMethod')) {
                        $DefaultNotification.Method = $DefaultNotificationMethod
                    }
                    if ($PSBoundParameters.ContainsKey('DefaultNotificationType')) {
                        $DefaultNotification.Type = $DefaultNotificationType
                    }
                    $body.NotificationSettings = New-Object 'Google.Apis.Calendar.v3.Data.CalendarListEntry+NotificationSettingsData' -Property @{
                        Notifications = [Google.Apis.Calendar.v3.Data.CalendarNotification[]]$DefaultNotification
                    }
                }
                foreach ($key in $PSBoundParameters.Keys) {
                    switch ($key) {
                        Color {
                            $body.ColorId = $colorHash[$Color]
                        }
                        Default {
                            if ($body.PSObject.Properties.Name -contains $key) {
                                $body.$key = $PSBoundParameters[$key]
                            }
                        }
                    }
                }
                Write-Verbose "Subscribing user '$User' to Calendar '$($calId)'"
                $request = $service.CalendarList.Insert($body)
                if ($PSBoundParameters.ContainsKey('ColorRgbFormat')) {
                    $request.ColorRgbFormat = $ColorRgbFormat
                }
                $request.Execute()
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

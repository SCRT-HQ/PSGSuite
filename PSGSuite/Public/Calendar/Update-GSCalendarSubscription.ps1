function Update-GSCalendarSubscription {
    <#
    .SYNOPSIS
    Updates a calendar in a users calendar list (aka subscription)

    .DESCRIPTION
    Updates a calendar in a users calendar list (aka subscription)

    .PARAMETER User
    The primary email or UserID of the user. You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

    .PARAMETER CalendarID
    The calendar ID of the calendar subscription you would like to update.

    .PARAMETER ColorRgbFormat
    Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB). If this feature is used, the index-based colorId field will be set to the best matching option automatically.

    .PARAMETER Selected
    Whether the calendar content shows up in the calendar UI. Optional. The default is False.

    .PARAMETER Hidden
    Whether the calendar has been hidden from the list. Optional. The default is False.

    .PARAMETER Reminders
    A list of reminders to add to this calendar.

    This parameter expects a 'Google.Apis.Calendar.v3.Data.EventReminder[]' object type. You can create objects of this type easily by using the function 'Add-GSCalendarEventReminder'

    .PARAMETER RemoveReminders
    If $true, removes reminders from this CalendarSubscription.

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

    .PARAMETER RemoveNotifications
    If $true, removes notifications from this CalendarSubscription.

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
    Update-GSCalendarSubscription -User me -CalendarId john.smith@domain.com -Selected -Color Cyan

    Updates the calendar 'john.smith@domain.com' on the AdminEmail user's calendar list by marking it as selected and setting the color to Cyan
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
        [parameter(Mandatory,Position = 1,ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [String[]]
        $CalendarId,
        [parameter(Mandatory = $false)]
        [Switch]
        $ColorRgbFormat,
        [parameter(Mandatory = $false)]
        [Switch]
        $Selected,
        [parameter(Mandatory = $false)]
        [Switch]
        $Hidden,
        [parameter()]
        [Google.Apis.Calendar.v3.Data.EventReminder[]]
        $Reminders,
        [parameter()]
        [switch]
        $RemoveReminders,
        [parameter(Mandatory = $false)]
        [ValidateSet('email','sms','popup')]
        [String]
        $DefaultReminderMethod,
        [parameter(Mandatory = $false)]
        [ValidateRange(0,40320)]
        [Int]
        $DefaultReminderMinutes = 10,
        [parameter()]
        [Google.Apis.Calendar.v3.Data.CalendarNotification[]]
        $Notifications,
        [parameter()]
        [switch]
        $RemoveNotifications,
        [parameter(Mandatory = $false)]
        [ValidateSet('email','sms')]
        [String]
        $DefaultNotificationMethod,
        [parameter(Mandatory = $false)]
        [ValidateSet('eventCreation','eventChange','eventCancellation','eventResponse','agenda')]
        [String]
        $DefaultNotificationType,
        [parameter(Mandatory = $false)]
        [ValidateSet("Periwinkle","Seafoam","Lavender","Coral","Goldenrod","Beige","Cyan","Grey","Blue","Green","Red")]
        [String]
        $Color,
        [parameter(Mandatory = $false)]
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
                $body = Get-GSCalendarSubscription -User $User -CalendarId $calId -Verbose:$false
                if ($RemoveReminders) {
                    $body.DefaultReminders = New-Object 'System.Collections.Generic.List[Google.Apis.Calendar.v3.Data.EventReminder]'
                }
                elseif ($PSBoundParameters.ContainsKey('Reminders')) {
                    if ($null -eq $body.DefaultReminders) {
                        $body.DefaultReminders = $Reminders
                    }
                    else {
                        $Reminders | ForEach-Object {
                            $body.DefaultReminders.Add($_) | Out-Null
                        }
                    }
                }
                elseif ($PSBoundParameters.ContainsKey('DefaultReminderMethod')) {
                    $defReminder = New-Object 'Google.Apis.Calendar.v3.Data.EventReminder' -Property @{
                        Method = $DefaultReminderMethod
                        Minutes = $DefaultReminderMinutes
                    }
                    if ($null -eq $body.DefaultReminders) {
                        $body.DefaultReminders = [Google.Apis.Calendar.v3.Data.EventReminder[]]$defReminder
                    }
                    else {
                        $body.DefaultReminders.Add($defReminder)
                    }
                }
                if ($RemoveNotifications) {
                    $body.NotificationSettings = New-Object 'Google.Apis.Calendar.v3.Data.CalendarListEntry+NotificationSettingsData' -Property @{
                        Notifications = New-Object 'System.Collections.Generic.List[Google.Apis.Calendar.v3.Data.CalendarNotification]'
                    }
                }
                elseif ($PSBoundParameters.ContainsKey('Notifications')) {
                    if ($null -eq $body.NotificationSettings) {
                        $body.NotificationSettings = New-Object 'Google.Apis.Calendar.v3.Data.CalendarListEntry+NotificationSettingsData' -Property @{
                            Notifications = [Google.Apis.Calendar.v3.Data.CalendarNotification[]]$Notifications
                        }
                    }
                    else {
                        $Notifications | ForEach-Object {
                            $body.NotificationSettings.Notifications.Add($_) | Out-Null
                        }
                    }
                }
                elseif ($PSBoundParameters.ContainsKey('DefaultNotificationMethod') -and $PSBoundParameters.ContainsKey('DefaultNotificationType')) {
                    if ($null -eq $body.NotificationSettings) {
                        $DefaultNotification = New-Object 'Google.Apis.Calendar.v3.Data.CalendarNotification' -Property @{
                            Method = $DefaultNotificationMethod
                            Type = $DefaultNotificationType
                        }
                        $body.NotificationSettings = New-Object 'Google.Apis.Calendar.v3.Data.CalendarListEntry+NotificationSettingsData' -Property @{
                            Notifications = [Google.Apis.Calendar.v3.Data.CalendarNotification[]]$DefaultNotification
                        }
                    }
                    else {
                        $DefaultNotification = New-Object 'Google.Apis.Calendar.v3.Data.CalendarNotification' -Property @{
                            Method = $DefaultNotificationMethod
                            Type = $DefaultNotificationType
                        }
                        $body.NotificationSettings.Notifications.Add($DefaultNotification) | Out-Null
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
                Write-Verbose "Updating Calendar '$($calId) for user '$User'"
                $request = $service.CalendarList.Patch($body,$calId)
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

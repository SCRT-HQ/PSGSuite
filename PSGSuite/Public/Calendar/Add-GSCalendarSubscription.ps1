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
    
    .PARAMETER Selected
    Whether the calendar content shows up in the calendar UI. Optional. The default is False.
    
    .PARAMETER Hidden
    Whether the calendar has been hidden from the list. Optional. The default is False.
    
    .PARAMETER DefaultReminderMethod
    The method used by this reminder. Defaults to email.
    
    Possible values are:
    * "email" - Reminders are sent via email.
    * "sms" - Reminders are sent via SMS. These are only available for G Suite customers. Requests to set SMS reminders for other account types are ignored.
    * "popup" - Reminders are sent via a UI popup.
    
    .PARAMETER DefaultReminderMinutes
    Number of minutes before the start of the event when the reminder should trigger. Defaults to 30 minutes.
    
    Valid values are between 0 and 40320 (4 weeks in minutes).
    
    .PARAMETER DefaultNotificationMethod
    The method used to deliver the notification. Defaults to email.
    
    Possible values are:
    * "email" - Reminders are sent via email.
    * "sms" - Reminders are sent via SMS. This value is read-only and is ignored on inserts and updates. SMS reminders are only available for G Suite customers.
    
    .PARAMETER DefaultNotificationType
    The type of notification. Defaults to eventChange.
    
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
    #>
    [cmdletbinding()]
    Param
    (
        [parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
        [Alias("PrimaryEmail","UserKey","Mail")]
        [ValidateNotNullOrEmpty()]
        [String]
        $User,
        [parameter(Mandatory = $true)]
        [String[]]
        $CalendarId,
        [parameter(Mandatory = $false)]
        [Switch]
        $Selected,
        [parameter(Mandatory = $false)]
        [Switch]
        $Hidden,
        [parameter(Mandatory = $false)]
        [ValidateSet('email','sms','popup')]
        [String]
        $DefaultReminderMethod = 'email',
        [parameter(Mandatory = $false)]
        [ValidateRange(0,40320)]
        [Int]
        $DefaultReminderMinutes = 30,
        [parameter(Mandatory = $false)]
        [ValidateSet('email','sms')]
        [String]
        $DefaultNotificationMethod = 'email',
        [parameter(Mandatory = $false)]
        [ValidateSet('eventCreation','eventChange','eventCancellation','eventResponse','agenda')]
        [String]
        $DefaultNotificationType = 'eventChange',
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
                $body = New-Object 'Google.Apis.Calendar.v3.Data.CalendarListEntry' -Property @{
                    Id = $calId
                    Selected = $Selected
                    Hidden = $Hidden
                }
                $DefaultReminders = New-Object 'Google.Apis.Calendar.v3.Data.EventReminder' -Property @{
                    Method = $DefaultReminderMethod
                    Minutes = $DefaultReminderMinutes
                }
                $body.DefaultReminders = [Google.Apis.Calendar.v3.Data.EventReminder[]]$DefaultReminders
                $DefaultNotification = New-Object 'Google.Apis.Calendar.v3.Data.CalendarNotification'
                $DefaultNotification.Method = $DefaultNotificationMethod
                $DefaultNotification.Type = $DefaultNotificationType
                $body.NotificationSettings = New-Object 'Google.Apis.Calendar.v3.Data.CalendarListEntry+NotificationSettingsData' -Property @{
                    Notifications = [Google.Apis.Calendar.v3.Data.CalendarNotification[]]$DefaultNotification
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
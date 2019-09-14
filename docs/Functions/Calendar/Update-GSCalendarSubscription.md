# Update-GSCalendarSubscription

## SYNOPSIS
Updates a calendar in a users calendar list (aka subscription)

## SYNTAX

```
Update-GSCalendarSubscription [-User] <String> [-CalendarId] <String[]> [-ColorRgbFormat] [-Selected] [-Hidden]
 [-Reminders <EventReminder[]>] [-RemoveReminders] [-DefaultReminderMethod <String>]
 [-DefaultReminderMinutes <Int32>] [-Notifications <CalendarNotification[]>] [-RemoveNotifications]
 [-DefaultNotificationMethod <String>] [-DefaultNotificationType <String>] [-Color <String>]
 [-SummaryOverride <String>] [<CommonParameters>]
```

## DESCRIPTION
Updates a calendar in a users calendar list (aka subscription)

## EXAMPLES

### EXAMPLE 1
```
Update-GSCalendarSubscription -User me -CalendarId john.smith@domain.com -Selected -Color Cyan
```

Updates the calendar 'john.smith@domain.com' on the AdminEmail user's calendar list by marking it as selected and setting the color to Cyan

## PARAMETERS

### -CalendarId
The calendar ID of the calendar subscription you would like to update.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Color
The color of the calendar.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColorRgbFormat
Whether to use the foregroundColor and backgroundColor fields to write the calendar colors (RGB).
If this feature is used, the index-based colorId field will be set to the best matching option automatically.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultNotificationMethod
The method used to deliver the notification.

Possible values are:
* "email" - Reminders are sent via email.
* "sms" - Reminders are sent via SMS.
This value is read-only and is ignored on inserts and updates.
SMS reminders are only available for G Suite customers.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultNotificationType
The type of notification.

Possible values are:
* "eventCreation" - Notification sent when a new event is put on the calendar.
* "eventChange" - Notification sent when an event is changed.
* "eventCancellation" - Notification sent when an event is cancelled.
* "eventResponse" - Notification sent when an event is changed.
* "agenda" - An agenda with the events of the day (sent out in the morning).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultReminderMethod
The method used by this reminder.
Defaults to email.

Possible values are:
* "email" - Reminders are sent via email.
* "sms" - Reminders are sent via SMS.
These are only available for G Suite customers.
Requests to set SMS reminders for other account types are ignored.
* "popup" - Reminders are sent via a UI popup.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultReminderMinutes
Number of minutes before the start of the event when the reminder should trigger.
Defaults to 30 minutes.

Valid values are between 0 and 40320 (4 weeks in minutes).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hidden
Whether the calendar has been hidden from the list.
Optional.
The default is False.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notifications
A list of notifications to add to this calendar.

This parameter expects a 'Google.Apis.Calendar.v3.Data.CalendarNotification\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSCalendarNotification'

```yaml
Type: CalendarNotification[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reminders
A list of reminders to add to this calendar.

This parameter expects a 'Google.Apis.Calendar.v3.Data.EventReminder\[\]' object type.
You can create objects of this type easily by using the function 'Add-GSCalendarEventReminder'

```yaml
Type: EventReminder[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveNotifications
If $true, removes notifications from this CalendarSubscription.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveReminders
If $true, removes reminders from this CalendarSubscription.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Selected
Whether the calendar content shows up in the calendar UI.
Optional.
The default is False.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SummaryOverride
The summary that the authenticated user has set for this calendar.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The primary email or UserID of the user.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Calendar.v3.Data.CalendarListEntry
## NOTES

## RELATED LINKS

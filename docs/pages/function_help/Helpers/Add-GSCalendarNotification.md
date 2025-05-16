# Add-GSCalendarNotification

## SYNOPSIS
Builds an CalendarNotification object to use when creating or updating a CalendarSubscription

## SYNTAX

### Fields
```
Add-GSCalendarNotification -Method <String> -Type <String> [<CommonParameters>]
```

### InputObject
```
Add-GSCalendarNotification [-InputObject <CalendarNotification[]>] [<CommonParameters>]
```

## DESCRIPTION
Builds an CalendarNotification object to use when creating or updating a CalendarSubscription

## EXAMPLES

### EXAMPLE 1
```

```

## PARAMETERS

### -InputObject
Used for pipeline input of an existing IM object to strip the extra attributes and prevent errors

```yaml
Type: CalendarNotification[]
Parameter Sets: InputObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Method
The method used to deliver the notification.

Possible values are:
* "email" - Reminders are sent via email.
* "sms" - Reminders are sent via SMS.
This value is read-only and is ignored on inserts and updates.
SMS reminders are only available for G Suite customers.

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of notification.

Possible values are:
* "eventCreation" - Notification sent when a new event is put on the calendar.
* "eventChange" - Notification sent when an event is changed.
* "eventCancellation" - Notification sent when an event is cancelled.
* "eventResponse" - Notification sent when an event is changed.
* "agenda" - An agenda with the events of the day (sent out in the morning).

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Calendar.v3.Data.CalendarNotification
## NOTES

## RELATED LINKS

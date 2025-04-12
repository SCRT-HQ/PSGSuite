# Add-GSCalendarEventReminder

## SYNOPSIS
Builds an EventReminder object to use when creating or updating a CalendarSubscription or CalendarEvent

## SYNTAX

### Fields
```
Add-GSCalendarEventReminder -Method <String> -Minutes <Int32> [<CommonParameters>]
```

### InputObject
```
Add-GSCalendarEventReminder [-InputObject <EventReminder[]>] [<CommonParameters>]
```

## DESCRIPTION
Builds an EventReminder object to use when creating or updating a CalendarSubscription or CalendarEvent

## EXAMPLES

### EXAMPLE 1
```

```

## PARAMETERS

### -InputObject
Used for pipeline input of an existing IM object to strip the extra attributes and prevent errors

```yaml
Type: EventReminder[]
Parameter Sets: InputObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Method
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
Parameter Sets: Fields
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Minutes
Number of minutes before the start of the event when the reminder should trigger.
Defaults to 30 minutes.

Valid values are between 0 and 40320 (4 weeks in minutes).

```yaml
Type: Int32
Parameter Sets: Fields
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Calendar.v3.Data.EventReminder
## NOTES

## RELATED LINKS

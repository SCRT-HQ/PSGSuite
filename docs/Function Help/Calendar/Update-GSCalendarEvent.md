# Update-GSCalendarEvent

## SYNOPSIS
Updates an event

## SYNTAX

### AttendeeEmails (Default)
```
Update-GSCalendarEvent [-EventId] <String[]> [-CalendarId <String[]>] [-User <String[]>] [-Summary <String>]
 [-Description <String>] [-AttendeeEmails <String[]>] [-Location <String>] [-Visibility <String>]
 [-EventColor <String>] [-Reminders <EventReminder[]>] [-RemoveAllReminders] [-DisableDefaultReminder]
 [-LocalStartDateTime <DateTime>] [-LocalEndDateTime <DateTime>] [-StartDate <String>] [-EndDate <String>]
 [-UTCStartDateTime <String>] [-UTCEndDateTime <String>] [-PrivateExtendedProperties <Hashtable>]
 [-SharedExtendedProperties <Hashtable>] [-ExtendedProperties <ExtendedPropertiesData>] [<CommonParameters>]
```

### AttendeeObjects
```
Update-GSCalendarEvent [-EventId] <String[]> [-CalendarId <String[]>] [-User <String[]>] [-Summary <String>]
 [-Description <String>] [-Attendees <EventAttendee[]>] [-Location <String>] [-Visibility <String>]
 [-EventColor <String>] [-Reminders <EventReminder[]>] [-RemoveAllReminders] [-DisableDefaultReminder]
 [-LocalStartDateTime <DateTime>] [-LocalEndDateTime <DateTime>] [-StartDate <String>] [-EndDate <String>]
 [-UTCStartDateTime <String>] [-UTCEndDateTime <String>] [-PrivateExtendedProperties <Hashtable>]
 [-SharedExtendedProperties <Hashtable>] [-ExtendedProperties <ExtendedPropertiesData>] [<CommonParameters>]
```

## DESCRIPTION
Updates an event

## EXAMPLES

### EXAMPLE 1
```
New-GSCalendarEvent "Go to the gym" -StartDate (Get-Date "21:00:00") -EndDate (Get-Date "22:00:00")
```

Creates an event titled "Go to the gym" for 9-10PM the day the function is ran.

## PARAMETERS

### -AttendeeEmails
The email addresses of the attendees to add.

NOTE: This performs simple adds without additional attendee options.
If additional options are needed, use the Attendees parameter instead.

```yaml
Type: String[]
Parameter Sets: AttendeeEmails
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Attendees
The EventAttendee object(s) to add.
Use Add-GSEventAttendee with this parameter for best results.

```yaml
Type: EventAttendee[]
Parameter Sets: AttendeeObjects
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CalendarId
The Id of the calendar

Defaults to the user's primary calendar.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Primary
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
Event description

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

### -DisableDefaultReminder
When $true, disables inheritance of the default Reminders from the Calendar the event was created on.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: DisableReminder

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
String representation of the end date.
Middle precendence of the three EndDate parameters.

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

### -EventColor
Color of the event as seen in Calendar

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

### -EventId
The unique Id of the event to update

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ExtendedProperties
Extended properties of the event.
This must be of the type 'Google.Apis.Calendar.v3.Data.Event+ExtendedPropertiesData'.

This is useful for copying another events ExtendedProperties over when updating an existing event.

```yaml
Type: ExtendedPropertiesData
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LocalEndDateTime
End date and time of the event.
Lowest precendence of the three EndDate parameters.

Defaults to 30 minutes after the time the function is ran.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LocalStartDateTime
Start date and time of the event.
Lowest precendence of the three StartDate parameters.

Defaults to the time the function is ran.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
Event location

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

### -PrivateExtendedProperties
A hashtable of properties that are private to the copy of the event that appears on this calendar.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reminders
A list of reminders to add to this calendar event.

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

### -RemoveAllReminders
If $true, removes all reminder overrides and disables the default reminder inheritance from the calendar that the event is on.

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

### -SharedExtendedProperties
A hashtable of properties that are shared between copies of the event on other attendees' calendars.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
String representation of the start date.
Middle precendence of the three StartDate parameters.

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

### -Summary
Event summary

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

Defaults to the AdminEmail in the config.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: Named
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UTCEndDateTime
String representation of the end date in UTC.
Highest precendence of the three EndDate parameters.

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

### -UTCStartDateTime
String representation of the start date in UTC.
Highest precendence of the three StartDate parameters.

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

### -Visibility
Visibility of the event.

Possible values are:
* "default" - Uses the default visibility for events on the calendar.
This is the default value.
* "public" - The event is public and event details are visible to all readers of the calendar.
* "private" - The event is private and only event attendees may view event details.
* "confidential" - The event is private.
This value is provided for compatibility reasons.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Calendar.v3.Data.Event
## NOTES

## RELATED LINKS

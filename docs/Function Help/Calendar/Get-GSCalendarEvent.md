# Get-GSCalendarEvent

## SYNOPSIS
Gets the calendar events for a user

## SYNTAX

### List (Default)
```
Get-GSCalendarEvent [-CalendarId <String>] [-User <String[]>] [-Filter <String>] [-OrderBy <String>]
 [-MaxAttendees <Int32>] [-PageSize <Int32>] [-Limit <Int32>] [-ShowDeleted] [-ShowHiddenInvitations]
 [-SingleEvents] [-PrivateExtendedProperty <Hashtable>] [-SharedExtendedProperty <Hashtable>]
 [-TimeMin <DateTime>] [-TimeMax <DateTime>] [<CommonParameters>]
```

### Get
```
Get-GSCalendarEvent [-EventId] <String[]> [-CalendarId <String>] [-User <String[]>] [-MaxAttendees <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets the calendar events for a user

## EXAMPLES

### EXAMPLE 1
```
Get-GSCalendarEventList -TimeMin (Get-Date "01-21-2018 00:00:00") -TimeMax (Get-Date "01-28-2018 23:59:59") -SingleEvents
```

This gets the single events on the primary calendar of the Admin for the week of Jan 21-28, 2018.

## PARAMETERS

### -CalendarId
The calendar ID of the calendar you would like to list events from.

Defaults to the user's primary calendar

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Primary
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventId
The Id of the event to get info for

```yaml
Type: String[]
Parameter Sets: Get
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Free text search terms to find events that match these terms in any field, except for extended properties.

```yaml
Type: String
Parameter Sets: List
Aliases: Q, Query

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The maximum amount of results you want returned.
Exclude or set to 0 to return all results

```yaml
Type: Int32
Parameter Sets: List
Aliases: First

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxAttendees
The maximum number of attendees to include in the response.
If there are more than the specified number of attendees, only the participant is returned.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderBy
The order of the events returned in the result.

Acceptable values are:
* "startTime": Order by the start date/time (ascending).
This is only available when querying single events (i.e.
the parameter singleEvents is True)
* "updated": Order by last modification time (ascending).

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Maximum number of events returned on one result page.

```yaml
Type: Int32
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: 2500
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateExtendedProperty
Extended properties constraint specified as a hashtable where propertyName=value.
Matches only private properties.

```yaml
Type: Hashtable
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SharedExtendedProperty
Extended properties constraint specified as a hashtable where propertyName=value.
Matches only shared properties.

```yaml
Type: Hashtable
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowDeleted
Whether to include deleted events (with status equals "cancelled") in the result.
Cancelled instances of recurring events (but not the underlying recurring event) will still be included if showDeleted and singleEvents are both False.
If showDeleted and singleEvents are both True, only single instances of deleted events (but not the underlying recurring events) are returned.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowHiddenInvitations
Whether to include hidden invitations in the result.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SingleEvents
Whether to expand recurring events into instances and only return single one-off events and instances of recurring events, but not the underlying recurring events themselves.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeMax
Upper bound (exclusive) for an event's start time to filter by.
If TimeMin is set, TimeMax must be greater than timeMin.

```yaml
Type: DateTime
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeMin
Lower bound (inclusive) for an event's end time to filter by.
If TimeMax is set, TimeMin must be smaller than timeMax.

```yaml
Type: DateTime
Parameter Sets: List
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

Defaults to the AdminEmail in the config

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: Named
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Calendar.v3.Data.Event
## NOTES

## RELATED LINKS

[https://psgsuite.io/Function%20Help/Calendar/Get-GSCalendarEvent/](https://psgsuite.io/Function%20Help/Calendar/Get-GSCalendarEvent/)

[https://developers.google.com/calendar/v3/reference/events/get](https://developers.google.com/calendar/v3/reference/events/get)

[https://developers.google.com/calendar/v3/reference/events/list](https://developers.google.com/calendar/v3/reference/events/list)


# Add-GSEventAttendee

## SYNOPSIS
Adds an event attendee to a calendar event

## SYNTAX

### InputObject (Default)
```
Add-GSEventAttendee [-InputObject <EventAttendee[]>] [<CommonParameters>]
```

### Fields
```
Add-GSEventAttendee -Email <String> [-AdditionalGuests <Int32>] [-Comment <String>] [-DisplayName <String>]
 [-Optional] [-Organizer] [-Resource] [-ResponseStatus <String>] [<CommonParameters>]
```

## DESCRIPTION
Adds an event attendee to a calendar event

## EXAMPLES

### EXAMPLE 1
```
Add-GSEventAttendee -Email 'joe@domain.com'
```

## PARAMETERS

### -AdditionalGuests
How many additional guests, if any

```yaml
Type: Int32
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comment
Attendee comment

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisplayName
The attendee's name, if available

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
The email address of the attendee

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

### -InputObject
Used for pipeline input of an existing UserAddress object to strip the extra attributes and prevent errors

```yaml
Type: EventAttendee[]
Parameter Sets: InputObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Optional
Whether this is an optional attendee

```yaml
Type: SwitchParameter
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organizer
Whether the attendee is the organizer of the event

```yaml
Type: SwitchParameter
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Resource
Whether the attendee is a resource

```yaml
Type: SwitchParameter
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResponseStatus
The attendee's response status.

Possible values are:
* "NeedsAction": The attendee has not responded to the invitation.
* "Declined": The attendee has declined the invitation.
* "Tentative": The attendee has tentatively accepted the invitation.
* "Accepted": The attendee has accepted the invitation

```yaml
Type: String
Parameter Sets: Fields
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

### Google.Apis.Calendar.v3.Data.EventAttendee
## NOTES

## RELATED LINKS

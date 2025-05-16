# Get-GSCalendarSubscription

## SYNOPSIS
Gets a subscribed calendar from a users calendar list.
Returns the full calendar list if no CalendarId is specified.

## SYNTAX

```
Get-GSCalendarSubscription [[-User] <String>] [[-CalendarId] <String[]>] [-ShowDeleted] [-ShowHidden]
 [<CommonParameters>]
```

## DESCRIPTION
Gets a subscribed calendar from a users calendar list.
Returns the full calendar list if no CalendarId is specified.

## EXAMPLES

### EXAMPLE 1
```
Get-GSCalendarSubscription
```

Gets the AdminEmail user's calendar list

## PARAMETERS

### -CalendarId
The calendar ID of the calendar you would like to get info for.
If left blank, returns the list of calendars the user is subscribed to.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowDeleted
Whether to include deleted calendar list entries in the result.
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

### -ShowHidden
Whether to show hidden entries.
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

### -User
The primary email or UserID of the user.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

Defaults to the AdminEmail in the config

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: 1
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Calendar.v3.Data.CalendarListEntry
## NOTES

## RELATED LINKS

[https://psgsuite.io/Function%20Help/Calendar/Get-GSCalendarSubscription/](https://psgsuite.io/Function%20Help/Calendar/Get-GSCalendarSubscription/)


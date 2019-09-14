# Get-GSCalendar

## SYNOPSIS
Gets the calendars for a user

## SYNTAX

### List (Default)
```
Get-GSCalendar [-User <String[]>] [-MinAccessRole <MinAccessRoleEnum>] [-PageSize <Int32>] [-Limit <Int32>]
 [-ShowDeleted] [-ShowHidden] [-SyncToken <String>] [<CommonParameters>]
```

### Get
```
Get-GSCalendar [-CalendarId] <String[]> [-User <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets the calendars for a user

## EXAMPLES

### EXAMPLE 1
```
Get-GSCalendar
```

Gets the list of calendar subscriptions for the AdminEmail user.

## PARAMETERS

### -CalendarId
The Id of the calendar you would like to get.

If excluded, returns the list of calendars for the user.

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

### -MinAccessRole
The minimum access role for the user in the returned entries.
Optional.
The default is no restriction.

```yaml
Type: MinAccessRoleEnum
Parameter Sets: List
Aliases:
Accepted values: FreeBusyReader, Owner, Reader, Writer

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Maximum number of entries returned on one result page.
The page size can never be larger than 250 entries.

```yaml
Type: Int32
Parameter Sets: List
Aliases: MaxResults

Required: False
Position: Named
Default value: 250
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowDeleted
Whether to include deleted calendar list entries in the result.
Optional.
The default is False.

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

### -ShowHidden
Whether to show hidden entries.
Optional.
The default is False.

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

### -SyncToken
Token obtained from the nextSyncToken field returned on the last page of results from the previous list request.
It makes the result of this list request contain only entries that have changed since then.

If only read-only fields such as calendar properties or ACLs have changed, the entry won't be returned.
All entries deleted and hidden since the previous list request will always be in the result set and it is not allowed to set showDeleted neither showHidden to False.

To ensure client state consistency minAccessRole query parameter cannot be specified together with nextSyncToken.
If the syncToken expires, the server will respond with a 410 GONE response code and the client should clear its storage and perform a full synchronization without any syncToken.
Learn more about incremental synchronization.

Optional.
The default is to return all entries.

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

### Google.Apis.Calendar.v3.Data.CalendarListEntry
## NOTES

## RELATED LINKS

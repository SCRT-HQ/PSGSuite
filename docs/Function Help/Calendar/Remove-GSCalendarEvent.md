# Remove-GSCalendarEvent

## SYNOPSIS
Removes a calendar event

## SYNTAX

```
Remove-GSCalendarEvent [[-User] <String>] [[-CalendarID] <String>] [-EventID] <String[]> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Removes a calendar event

## EXAMPLES

### EXAMPLE 1
```
Remove-GSCalendarEvent -User user@domain.com -EventID _60q30c1g60o30e1i60o4ac1g60rj8gpl88rj2c1h84s34h9g60s30c1g60o30c1g84o3eg9n8gq32d246gq48d1g64o30c1g60o30c1g60o30c1g60o32c1g60o30c1g8csjihhi6oq3igi28h248ghk6ks4agq161144ga46gr4aci488p0
```

Removes the specified event from user@domain.com's calendar.

## PARAMETERS

### -CalendarID
The calendar ID of the calendar you would like to remove events from.

Defaults to the user's primary calendar.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Primary
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EventID
The EventID to remove

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The primary email or UserID of the user.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

Defaults to the AdminEmail in the config.

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: 1
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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

## NOTES

## RELATED LINKS

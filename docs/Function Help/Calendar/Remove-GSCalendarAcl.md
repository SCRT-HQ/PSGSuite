# Remove-GSCalendarAcl

## SYNOPSIS
Removes an Access Control List rule from a calendar.

## SYNTAX

```
Remove-GSCalendarAcl [-User] <String> [-CalendarID] <String> [-RuleId] <String[]> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Removes an Access Control List rule from a calendar.

## EXAMPLES

### EXAMPLE 1
```
Get-GSCalendar -User joe@domain.com |
```

Get-GSCalendarAcl |
    Where-Object {$_.Role -eq 'Owner'} |
    Remove-GSCalendarAcl

Gets all the calendars for Joe and finds all ACL rules where

## PARAMETERS

### -CalendarID
The calendar ID of the calendar you would like to remove the ACL from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RuleId
The ACL rule Id to remove.

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
The primary email or UserID of the user who owns the calendar.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: True
Position: 1
Default value: None
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

[https://psgsuite.io/Function%20Help/Calendar/Remove-GSCalendarAcl/](https://psgsuite.io/Function%20Help/Calendar/Remove-GSCalendarAcl/)


# Remove-GSTask

## SYNOPSIS
Deletes the authenticated user's specified task

## SYNTAX

```
Remove-GSTask [-Task] <String[]> [-Tasklist] <String> [[-User] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Deletes the authenticated user's specified task

## EXAMPLES

### EXAMPLE 1
```
Remove-GSTask -Task 'MTA3NjIwMjA1NTEzOTk0MjQ0OTk6MDow' -Tasklist 'MTA3NjIwMjA1NTEzOTk0MjQ0OTk6NTMyNDY5NDk1NDM5MzMxO' -Confirm:$false
```

Remove the specified Task owned by the AdminEmail user and skips the confirmation check

## PARAMETERS

### -Task
The unique Id of the Task to delete

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Tasklist
The unique Id of the Tasklist where the Task is

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The User who owns the Tasklist.

Defaults to the AdminUser's email.

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail, Email

Required: False
Position: 2
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

# Move-GSTask

## SYNOPSIS
Moves the specified task to another position in the task list.
This can include putting it as a child task under a new parent and/or move it to a different position among its sibling tasks.

## SYNTAX

```
Move-GSTask [-Tasklist] <String> [-Task] <String[]> [-Parent <String>] [-Previous <String>] [[-User] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Moves the specified task to another position in the task list.
This can include putting it as a child task under a new parent and/or move it to a different position among its sibling tasks.

## EXAMPLES

### EXAMPLE 1
```
Clear-GSTasklist -Tasklist 'MTA3NjIwMjA1NTEzOTk0MjQ0OTk6NTMyNDY5NDk1NDM5MzMxO' -Confirm:$false
```

Clears the specified Tasklist owned by the AdminEmail user and skips the confirmation check

## PARAMETERS

### -Parent
Parent task identifier.
If the task is created at the top level, this parameter is omitted.

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

### -Previous
Previous sibling task identifier.
If the task is created at the first position among its siblings, this parameter is omitted.

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

### -Task
The unique Id of the Task to move

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Tasklist
The unique Id of the Tasklist where the Task currently resides

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Tasks.v1.Data.Task
## NOTES

## RELATED LINKS

# Update-GSTask

## SYNOPSIS
Updates a Task

## SYNTAX

```
Update-GSTask [-Tasklist] <String> [-Task] <String> [[-Title] <String[]>] [[-Completed] <DateTime>]
 [[-Due] <DateTime>] [[-Notes] <String>] [[-Status] <String>] [[-Parent] <String>] [[-Previous] <String>]
 [[-User] <String>] [<CommonParameters>]
```

## DESCRIPTION
Updates a Task

## EXAMPLES

### EXAMPLE 1
```
Update-GSTask -Title 'Return Ben Crawford's call -Tasklist MTA3NjIwMjA1NTEzOTk0MjQ0OTk6ODEzNTI1MjE3ODk0MTY2MDow -Task 'MTA3NjIwMjA1NTEzOTk0MjQ0OTk6MDo4MjM4NDQ2MDA0MzIxMDEx' -Status completed
```

Updates the specified Task's title and marks it as completed

## PARAMETERS

### -Completed
The DateTime of the task completion

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Due
The DateTime of the task due date

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Notes
Notes describing the task

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parent
Parent task identifier.
If the task is created at the top level, this parameter is omitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Status of the task.
This is either "needsAction" or "completed".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Task
The Id of the Task

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

### -Tasklist
The Id of the Tasklist the Task is on

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

### -Title
The title of the Task

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The User who owns the Task

Defaults to the AdminUser's email.

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail, Email

Required: False
Position: 10
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

# Get-GSTask

## SYNOPSIS
Gets a specific Task or the list of Tasks

## SYNTAX

### List (Default)
```
Get-GSTask [-Tasklist] <String> [-User <String>] [-CompletedMax <DateTime>] [-CompletedMin <DateTime>]
 [-DueMax <DateTime>] [-DueMin <DateTime>] [-UpdatedMin <DateTime>] [-ShowCompleted] [-ShowDeleted]
 [-ShowHidden] [-PageSize <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

### Get
```
Get-GSTask [[-Task] <String[]>] [-Tasklist] <String> [-User <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets a specific Task or the list of Tasks

## EXAMPLES

### EXAMPLE 1
```
Get-GSTasklist
```

Gets the list of Tasklists owned by the AdminEmail user

### EXAMPLE 2
```
Get-GSTasklist -Tasklist MTUzNTU0MDYscM0NjKDMTIyNjQ6MDow -User john@domain.com
```

Gets the Tasklist matching the provided Id owned by John

## PARAMETERS

### -CompletedMax
Upper bound for a task's completion date to filter by.

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

### -CompletedMin
Lower bound for a task's completion date to filter by.

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

### -DueMax
Upper bound for a task's due date to filter by.

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

### -DueMin
Lower bound for a task's due date to filter by.

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

### -PageSize
Page size of the result set

```yaml
Type: Int32
Parameter Sets: List
Aliases: MaxResults

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowCompleted
Flag indicating whether completed tasks are returned in the result.

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

### -ShowDeleted
Flag indicating whether deleted tasks are returned in the result.

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
Flag indicating whether hidden tasks are returned in the result.

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

### -Task
The unique Id of the Task.

If left blank, returns the list of Tasks on the Tasklist

```yaml
Type: String[]
Parameter Sets: Get
Aliases: Id

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Tasklist
The unique Id of the Tasklist the Task is on.

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

### -UpdatedMin
Lower bound for a task's last modification time to filter by.

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
The User who owns the Task.

Defaults to the AdminUser's email.

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail, Email

Required: False
Position: Named
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

# Get-GSTasklist

## SYNOPSIS
Gets a specific Tasklist or the list of Tasklists

## SYNTAX

### List (Default)
```
Get-GSTasklist [[-User] <String>] [-PageSize <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

### Get
```
Get-GSTasklist [[-Tasklist] <String[]>] [[-User] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets a specific Tasklist or the list of Tasklists

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

### -Tasklist
The unique Id of the Tasklist.

If left blank, gets the full list of Tasklists

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

### Google.Apis.Tasks.v1.Data.TaskList
## NOTES

## RELATED LINKS

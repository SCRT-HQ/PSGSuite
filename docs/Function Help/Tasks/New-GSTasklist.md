# New-GSTasklist

## SYNOPSIS
Creates a new Tasklist

## SYNTAX

```
New-GSTasklist [-Title] <String[]> [[-User] <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new Tasklist

## EXAMPLES

### EXAMPLE 1
```
New-GSTasklist -Title 'Chores','Projects'
```

Creates 2 new Tasklists titled 'Chores' and 'Projects' for the AdminEmail user

## PARAMETERS

### -Title
The title of the new Tasklist

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The User to create the Tasklist for.

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

# Remove-GSCourseParticipant

## SYNOPSIS
Removes students and/or teachers from a course

## SYNTAX

```
Remove-GSCourseParticipant [-CourseId] <String> [-Student <String[]>] [-Teacher <String[]>] [-User <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes students and/or teachers from a course

## EXAMPLES

### EXAMPLE 1
```
Remove-GSCourseParticipant -CourseId 'architecture-101' -Student plato@athens.edu,aristotle@athens.edu -Teacher zeus@athens.edu
```

## PARAMETERS

### -CourseId
Identifier of the course to remove participants from.
This identifier can be either the Classroom-assigned identifier or an alias.

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

### -Student
Identifier of the user.

This identifier can be one of the following:

* the numeric identifier for the user
* the email address of the user
* the string literal "me", indicating the requesting user

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrimaryEmail, Email, Mail

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Teacher
Identifier of the user.

This identifier can be one of the following:

* the numeric identifier for the user
* the email address of the user
* the string literal "me", indicating the requesting user

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to authenticate the request as

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

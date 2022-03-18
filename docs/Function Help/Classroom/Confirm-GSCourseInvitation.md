# Confirm-GSCourseInvitation

## SYNOPSIS
Accepts an invitation, removing it and adding the invited user to the teachers or students (as appropriate) of the specified course.
Only the invited user may accept an invitation.

## SYNTAX

```
Confirm-GSCourseInvitation [-Id] <String> [-User] <String> [<CommonParameters>]
```

## DESCRIPTION
Accepts an invitation, removing it and adding the invited user to the teachers or students (as appropriate) of the specified course.
Only the invited user may accept an invitation.

## EXAMPLES

### EXAMPLE 1
```
Confirm-GSCourseInvitation -Id $inviteId -User aristotle@athens.edu
```

## PARAMETERS

### -Id
Identifier of the invitation to accept.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
Email or email name part of the invited user.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

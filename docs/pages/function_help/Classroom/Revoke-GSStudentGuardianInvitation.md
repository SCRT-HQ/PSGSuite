# Revoke-GSStudentGuardianInvitation

## SYNOPSIS
Revokes a student guardian invitation.

## SYNTAX

```
Revoke-GSStudentGuardianInvitation [-StudentId] <String> [-InvitationId] <String[]> [[-User] <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Revokes a student guardian invitation.

This method returns the following error codes:

* PERMISSION_DENIED if the current user does not have permission to manage guardians, if guardians are not enabled for the domain in question or for other access errors.
* FAILED_PRECONDITION if the guardian link is not in the PENDING state.
* INVALID_ARGUMENT if the format of the student ID provided cannot be recognized (it is not an email address, nor a user_id from this API), or if the passed GuardianInvitation has a state other than COMPLETE, or if it modifies fields other than state.
* NOT_FOUND if the student ID provided is a valid student ID, but Classroom has no record of that student, or if the id field does not refer to a guardian invitation known to Classroom.

## EXAMPLES

### EXAMPLE 1
```
Revoke-GSStudentGuardianInvitation -StudentId aristotle@athens.edu -InvitationId $invitationId
```

### EXAMPLE 2
```
Import-Csv .\Student_Guardian_List_To_Revoke.csv | Revoke-GSStudentGuardianInvitation
```

Process a CSV with two columns containing headers "Student" and "Guardian" and revokes the invites accordingly, i.e.

|      StudentId       |    InvitationId    |
|:--------------------:|:------------------:|
| aristotle@athens.edu | 198okj4k9827872177 |
| plato@athens.edu     | 09120uuip21ru0ff0u |

## PARAMETERS

### -InvitationId
The id field of the GuardianInvitation to be revoked.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Invitation, InviteId, Invite

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -StudentId
The ID of the student whose guardian invitation is to be revoked.
The identifier can be one of the following:

* the numeric identifier for the user
* the email address of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: Student

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The user to authenticate the request as

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

### Google.Apis.Classroom.v1.Data.GuardianInvitation
## NOTES

## RELATED LINKS

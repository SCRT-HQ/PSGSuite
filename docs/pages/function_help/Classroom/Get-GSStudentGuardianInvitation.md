# Get-GSStudentGuardianInvitation

## SYNOPSIS
Gets a guardian invitation or list of guardian invitations.

## SYNTAX

### List (Default)
```
Get-GSStudentGuardianInvitation [-StudentId <String[]>] [-GuardianEmail <String>] [-States <StatesEnum[]>]
 [-User <String>] [<CommonParameters>]
```

### Get
```
Get-GSStudentGuardianInvitation -InvitationId <String[]> [-StudentId <String[]>] [-User <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets a guardian invitation or list of guardian invitations.

## EXAMPLES

### EXAMPLE 1
```
Get-GSStudentGuardianInvitation -StudentId aristotle@athens.edu
```

Gets the list of guardian invitations for this student.

## PARAMETERS

### -GuardianEmail
If specified, only results with the specified GuardianEmail will be returned.

```yaml
Type: String
Parameter Sets: List
Aliases: Guardian

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -InvitationId
The id field of the GuardianInvitation being requested.

```yaml
Type: String[]
Parameter Sets: Get
Aliases: Id

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -States
If specified, only results with the specified state values will be returned.
Otherwise, results with a state of PENDING will be returned.

The State can be one of the following:

* PENDING
* COMPLETE

```yaml
Type: StatesEnum[]
Parameter Sets: List
Aliases:
Accepted values: GUARDIANINVITATIONSTATEUNSPECIFIED, PENDING, COMPLETE

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StudentId
The identifier of the student whose guardian invitation is being requested.
The identifier can be one of the following:

* the numeric identifier for the user
* the email address of the user
* the string literal "me", indicating the requesting user
* the string literal "-", indicating that results should be returned for all students that the requesting user is permitted to view guardian invitations.
\[Default\]
    * **This is only allowed when excluding the \`InvitationId\` parameter to perform a List request!**

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Student

Required: False
Position: Named
Default value: -
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
Position: Named
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Classroom.v1.Data.GuardianInvitation
## NOTES

## RELATED LINKS

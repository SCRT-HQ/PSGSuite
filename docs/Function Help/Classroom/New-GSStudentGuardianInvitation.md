# New-GSStudentGuardianInvitation

## SYNOPSIS
Creates a guardian invitation, and sends an email to the guardian asking them to confirm that they are the student's guardian.

## SYNTAX

```
New-GSStudentGuardianInvitation [-StudentId] <String> [-GuardianEmail] <String> [[-User] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a guardian invitation, and sends an email to the guardian asking them to confirm that they are the student's guardian.

## EXAMPLES

### EXAMPLE 1
```
New-GSStudentGuardianInvitation -StudentId aristotle@athens.edu -GuardianEmail zeus@olympus.io
```

### EXAMPLE 2
```
Import-Csv .\Student_Guardian_List.csv | New-GSStudentGuardianInvitation
```

Process a CSV with two columns containing headers "Student" and "Guardian" and send the invites accordingly, i.e.

|      StudentId       |  GuardianEmail  |
|:--------------------:|:---------------:|
| aristotle@athens.edu | zeus@olympus.io |
| plato@athens.edu     | hera@olympus.io |

## PARAMETERS

### -GuardianEmail
The email address of the guardian to invite.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Guardian

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -StudentId
Identifier of the user to invite.
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Classroom.v1.Data.GuardianInvitation
## NOTES

## RELATED LINKS

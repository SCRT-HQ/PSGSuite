# Get-GSStudentGuardian

## SYNOPSIS
Gets a guardian or list of guardians for a student.

## SYNTAX

```
Get-GSStudentGuardian [[-StudentId] <String[]>] [[-GuardianId] <String[]>] [[-User] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets a guardian or list of guardians for a student.

## EXAMPLES

### EXAMPLE 1
```
Get-GSStudentGuardian
```

Gets the list of guardians for all students.

## PARAMETERS

### -GuardianId
The id field from a Guardian.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Guardian

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -StudentId
The identifier of the student to get guardian info for.
The identifier can be one of the following:

* the numeric identifier for the user
* the email address of the user
* the string literal "me", indicating the requesting user
* the string literal "-", indicating that results should be returned for all students that the requesting user is permitted to view guardians for.
\[Default\]
    * **This is only allowed when excluding the \`GuardianId\` parameter to perform a List request!**

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Student

Required: False
Position: 1
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
Position: 3
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Classroom.v1.Data.Guardian
## NOTES

## RELATED LINKS

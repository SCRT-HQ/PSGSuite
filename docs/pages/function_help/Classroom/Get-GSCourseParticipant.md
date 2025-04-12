# Get-GSCourseParticipant

## SYNOPSIS
Gets a course participant or list of participants (teachers/students)

## SYNTAX

### List (Default)
```
Get-GSCourseParticipant [-CourseId] <String> [-Role <String[]>] [-User <String>] [-Fields <String[]>]
 [<CommonParameters>]
```

### Get
```
Get-GSCourseParticipant [-CourseId] <String> [-Teacher <String[]>] [-Student <String[]>] [-User <String>]
 [-Fields <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets a course participant or list of participants (teachers/students)

## EXAMPLES

### EXAMPLE 1
```
Get-GSCourseParticipant -Teacher aristotle@athens.edu
```

## PARAMETERS

### -CourseId
Identifier of the course to get participants of.
This identifier can be either the Classroom-assigned identifier or an alias.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Fields
The specific fields to fetch

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Role
The Role for which you would like to list participants for.

Available values are:

* Student
* Teacher

The default value for this parameter is @('Teacher','Student')

```yaml
Type: String[]
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: @('Teacher','Student')
Accept pipeline input: False
Accept wildcard characters: False
```

### -Student
Restricts returned courses to those having a student with the specified identifier.
The identifier can be one of the following:

* the numeric identifier for the user
* the email address of the user
* the string literal "me", indicating the requesting user

```yaml
Type: String[]
Parameter Sets: Get
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Teacher
Restricts returned courses to those having a teacher with the specified identifier.
The identifier can be one of the following:

* the numeric identifier for the user
* the email address of the user
* the string literal "me", indicating the requesting user

```yaml
Type: String[]
Parameter Sets: Get
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Classroom.v1.Data.Student
## NOTES

## RELATED LINKS

# Get-GSCourse

## SYNOPSIS
Gets a classroom course or list of courses

## SYNTAX

### List (Default)
```
Get-GSCourse [-Teacher <String>] [-Student <String>] [-CourseStates <CourseStatesEnum[]>] [-User <String>]
 [<CommonParameters>]
```

### Get
```
Get-GSCourse [[-Id] <String[]>] [-User <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets a classroom course or list of courses

## EXAMPLES

### EXAMPLE 1
```
Get-GSCourse -Teacher aristotle@athens.edu
```

## PARAMETERS

### -CourseStates
Restricts returned courses to those in one of the specified states.

```yaml
Type: CourseStatesEnum[]
Parameter Sets: List
Aliases:
Accepted values: COURSESTATEUNSPECIFIED, ACTIVE, ARCHIVED, PROVISIONED, DECLINED, SUSPENDED

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Identifier of the course to return.
This identifier can be either the Classroom-assigned identifier or an alias.

If excluded, returns the list of courses.

```yaml
Type: String[]
Parameter Sets: Get
Aliases:

Required: False
Position: 1
Default value: None
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
Type: String
Parameter Sets: List
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
Type: String
Parameter Sets: List
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
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Classroom.v1.Data.Course
## NOTES

## RELATED LINKS

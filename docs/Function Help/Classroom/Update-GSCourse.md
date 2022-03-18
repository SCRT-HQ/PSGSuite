# Update-GSCourse

## SYNOPSIS
Updates an existing course.

## SYNTAX

```
Update-GSCourse [-Id] <String> [-Name <String>] [-OwnerId <String>] [-Section <String>]
 [-DescriptionHeading <String>] [-Description <String>] [-Room <String>] [-CourseState <String>]
 [-User <String>] [<CommonParameters>]
```

## DESCRIPTION
Updates an existing course.

## EXAMPLES

### EXAMPLE 1
```
Update-GSCourse -Id the-republic-s01 -Name "The Rebublic 101"
```

## PARAMETERS

### -CourseState
State of the course.
If unspecified, the default state is PROVISIONED

Available values are:
* ACTIVE - The course is active.
* ARCHIVED - The course has been archived.
You cannot modify it except to change it to a different state.
* PROVISIONED - The course has been created, but not yet activated.
It is accessible by the primary teacher and domain administrators, who may modify it or change it to the ACTIVE or DECLINED states.
A course may only be changed to PROVISIONED if it is in the DECLINED state.
* DECLINED - The course has been created, but declined.
It is accessible by the course owner and domain administrators, though it will not be displayed in the web UI.
You cannot modify the course except to change it to the PROVISIONED state.
A course may only be changed to DECLINED if it is in the PROVISIONED state.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Status

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Optional description.
For example, "We'll be learning about the structure of living creatures from a combination of textbooks, guest lectures, and lab work.
Expect to be excited!" If set, this field must be a valid UTF-8 string and no longer than 30,000 characters.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DescriptionHeading
Optional heading for the description.
For example, "Welcome to 10th Grade Biology." If set, this field must be a valid UTF-8 string and no longer than 3600 characters.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Heading

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Identifier for this course assigned by Classroom.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Alias

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the course.
For example, "10th Grade Biology".
The name is required.
It must be between 1 and 750 characters and a valid UTF-8 string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OwnerId
The identifier of the owner of a course.

When specified as a parameter of a create course request, this field is required.
The identifier can be one of the following:

* the numeric identifier for the user
* the email address of the user
* the string literal "me", indicating the requesting user

```yaml
Type: String
Parameter Sets: (All)
Aliases: Teacher

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Room
Optional room location.
For example, "301".
If set, this field must be a valid UTF-8 string and no longer than 650 characters.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Section
Section of the course.
For example, "Period 2".
If set, this field must be a valid UTF-8 string and no longer than 2800 characters.

```yaml
Type: String
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Classroom.v1.Data.Course
## NOTES

## RELATED LINKS

# Get-GSCourseAlias

## SYNOPSIS
Gets the list of aliases for a course.

## SYNTAX

```
Get-GSCourseAlias [-CourseId] <String> [-User <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets the list of aliases for a course.

## EXAMPLES

### EXAMPLE 1
```
Get-GSCourseAlias -CourseId 'architecture-101'
```

## PARAMETERS

### -CourseId
Identifier of the course to alias.
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

### Google.Apis.Classroom.v1.Data.CourseAlias
## NOTES

## RELATED LINKS

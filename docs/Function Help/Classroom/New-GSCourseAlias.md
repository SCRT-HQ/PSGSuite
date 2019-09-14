# New-GSCourseAlias

## SYNOPSIS
Creates a course alias.

## SYNTAX

```
New-GSCourseAlias [-Alias] <String> [-CourseId] <String> [-Scope <String>] [-User <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a course alias.

## EXAMPLES

### EXAMPLE 1
```
New-GSCourseAlias -Alias "abc123" -CourseId 'architecture-101' -Scope Domain
```

### EXAMPLE 2
```
New-GSCourseAlias -Alias "d:abc123" -CourseId 'architecture-101'
```

## PARAMETERS

### -Alias
Alias string

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

### -CourseId
Identifier of the course to alias.
This identifier can be either the Classroom-assigned identifier or an alias.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope
An alias uniquely identifies a course.
It must be unique within one of the following scopes:

* Domain - A domain-scoped alias is visible to all users within the alias creator's domain and can be created only by a domain admin.
A domain-scoped alias is often used when a course has an identifier external to Classroom.
* Project - A project-scoped alias is visible to any request from an application using the Developer Console project ID that created the alias and can be created by any project.
A project-scoped alias is often used when an application has alternative identifiers.
A random value can also be used to avoid duplicate courses in the event of transmission failures, as retrying a request will return ALREADY_EXISTS if a previous one has succeeded.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $(if($Alias -match "^p\:"){'Project'}else{'Domain'})
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

### Google.Apis.Classroom.v1.Data.CourseAlias
## NOTES

## RELATED LINKS

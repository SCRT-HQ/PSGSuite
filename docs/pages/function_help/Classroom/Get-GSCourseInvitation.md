# Get-GSCourseInvitation

## SYNOPSIS
Gets a course invitation or list of invitations

## SYNTAX

### List (Default)
```
Get-GSCourseInvitation [-CourseId <String>] [-UserId <String>] [-User <String>] [<CommonParameters>]
```

### Get
```
Get-GSCourseInvitation -Id <String[]> [-User <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets a course invitation or list of invitations

## EXAMPLES

### EXAMPLE 1
```
Get-GSCourseInvitation -CourseId philosophy-101
```

## PARAMETERS

### -CourseId
Restricts returned invitations to those for a course with the specified identifier.
This identifier can be either the Classroom-assigned identifier or an alias.

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

### -Id
Identifier of the invitation to return.

```yaml
Type: String[]
Parameter Sets: Get
Aliases:

Required: True
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

### -UserId
Restricts returned invitations to those for a specific user.
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Classroom.v1.Data.Invitation
## NOTES

## RELATED LINKS

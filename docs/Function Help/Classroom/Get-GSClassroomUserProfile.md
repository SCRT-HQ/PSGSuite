# Get-GSClassroomUserProfile

## SYNOPSIS
Gets a classroom user profile

## SYNTAX

```
Get-GSClassroomUserProfile [-UserId] <String[]> [-Fields <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets a classroom user profile

## EXAMPLES

### EXAMPLE 1
```
Get-GSClassroomUserProfile -UserId aristotle@athens.edu
```

## PARAMETERS

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

### -UserId
Identifier of the profile to return.
The identifier can be one of the following:

* the numeric identifier for the user
* the email address of the user
* the string literal "me", indicating the requesting user

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id, PrimaryEmail, Mail, UserKey

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Classroom.v1.Data.UserProfile
## NOTES

## RELATED LINKS

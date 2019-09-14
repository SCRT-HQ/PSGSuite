# New-GSCalendarAcl

## SYNOPSIS
Adds a new Access Control Rule to a calendar.

## SYNTAX

```
New-GSCalendarAcl [[-User] <String[]>] [[-CalendarId] <String[]>] [-Role] <String> [-Value] <String>
 [[-Type] <String>] [<CommonParameters>]
```

## DESCRIPTION
Adds a new Access Control Rule to a calendar.

## EXAMPLES

### EXAMPLE 1
```
New-GSCalendarACL -CalendarID jennyappleseed@domain.com -Role reader -Value Jonnyappleseed@domain.com -Type user
```

Gives Jonnyappleseed@domain.com reader access to jennyappleseed's calendar.

## PARAMETERS

### -CalendarId
The Id of the calendar you would like to share

Defaults to the user's primary calendar.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Primary
Accept pipeline input: False
Accept wildcard characters: False
```

### -Role
The role assigned to the scope.

Available values are:
* "none" - Provides no access.
* "freeBusyReader" - Provides read access to free/busy information.
* "reader" - Provides read access to the calendar.
Private events will appear to users with reader access, but event details will be hidden.
* "writer" - Provides read and write access to the calendar.
Private events will appear to users with writer access, and event details will be visible.
* "owner" - Provides ownership of the calendar.
This role has all of the permissions of the writer role with the additional ability to see and manipulate ACLs.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of the scope.

Available values are:
* "default" - The public scope.
This is the default value.
* "user" - Limits the scope to a single user.
* "group" - Limits the scope to a group.
* "domain" - Limits the scope to a domain.

Note: The permissions granted to the "default", or public, scope apply to any user, authenticated or not.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: User
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The primary email or UserID of the user.
You can exclude the '@domain.com' to insert the Domain in the config or use the special 'me' to indicate the AdminEmail in the config.

Defaults to the AdminEmail in the config.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: 1
Default value: Me
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Value
The email address of a user or group, or the name of a domain, depending on the scope type.
Omitted for type "default".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Calendar.v3.Data.AclRule
## NOTES

## RELATED LINKS

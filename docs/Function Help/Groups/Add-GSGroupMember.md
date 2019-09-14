# Add-GSGroupMember

## SYNOPSIS
Adds a list of emails to a target group

## SYNTAX

```
Add-GSGroupMember [-Identity] <String> [-Member] <String[]> [-Role <String>] [<CommonParameters>]
```

## DESCRIPTION
Adds a list of emails to a target group.
Designed for parity with Add-ADGroupMember

## EXAMPLES

### EXAMPLE 1
```
Add-GSGroupMember "admins@domain.com" -Member "joe-admin@domain.com","sally.admin@domain.com"
```

Adds 2 users to the group "admins@domain.com"

## PARAMETERS

### -Identity
The email or GroupID of the target group to add members to

```yaml
Type: String
Parameter Sets: (All)
Aliases: GroupEmail, Group, Email

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Member
The list of user and/or group emails that you would like to add to the target group

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail, User, UserEmail, Members

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Role
The role that you would like to add the members as

Defaults to "MEMBER"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: MEMBER
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.Member
## NOTES

## RELATED LINKS

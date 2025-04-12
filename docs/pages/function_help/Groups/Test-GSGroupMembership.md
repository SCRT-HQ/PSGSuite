# Test-GSGroupMembership

## SYNOPSIS
Checks if a Group has a specific member

## SYNTAX

```
Test-GSGroupMembership [-Identity] <String> [-Member] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Checks if a Group has a specific member

## EXAMPLES

### EXAMPLE 1
```
Test-GSGroupMembership -Identity admins@domain.com -Member john@domain.com
```

Tests if john@domain.com is a member of admins@domain.com

## PARAMETERS

### -Identity
The email of the group

If only the email name-part is passed, the full email will be contstructed using the Domain from the active config

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
The user to confirm as a member of the Group

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.MembersHasMember
## NOTES

## RELATED LINKS

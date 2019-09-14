# Add-GSPrincipalGroupMembership

## SYNOPSIS
Adds the target email to a list of groups

## SYNTAX

```
Add-GSPrincipalGroupMembership [-Identity] <String> [-MemberOf] <String[]> [-Role <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Adds the target email to a list of groups.
Designed for parity with Add-ADPrincipalGroupMembership

## EXAMPLES

### EXAMPLE 1
```
Add-GSPrincipalGroupMembership "joe@domain.com" -MemberOf "admins@domain.com","users@domain.com"
```

Adds the email "joe@domain.com" to the admins@ and users@ groups

## PARAMETERS

### -Identity
The user or group email that you would like to add to the list of groups

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail, User, Email, UserEmail

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -MemberOf
The list of groups to add the target email to

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: GroupEmail, Group

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

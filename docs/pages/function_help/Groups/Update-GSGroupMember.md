# Update-GSGroupMember

## SYNOPSIS
Updates a group member's role and/or delivery preference

## SYNTAX

```
Update-GSGroupMember [-GroupEmail] <String> [-Member] <String[]> [-Role <String>] [-DeliverySettings <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Updates a group member's role and/or delivery preference

## EXAMPLES

### EXAMPLE 1
```
Get-GSGroupMember myGroup | Update-GSGroupMember -DeliverySettings ALL_MAIL
```

Updates the delivery preference for all members of group 'myGroup@domain.com' to 'ALL_MAIL'

## PARAMETERS

### -DeliverySettings
Defines mail delivery preferences of member

Acceptable values are:
* "ALL_MAIL": All messages, delivered as soon as they arrive.
* "DAILY": No more than one message a day.
* "DIGEST": Up to 25 messages bundled into a single message.
* "DISABLED": Remove subscription.
* "NONE": No messages.

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

### -GroupEmail
The email or GroupID of the group to update members of

```yaml
Type: String
Parameter Sets: (All)
Aliases: Group

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Member
The member email or list of member emails that you would like to update

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail, User, UserEmail, Email, Members

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Role
The role that you would like to update the members to

Acceptable values are:
* MEMBER
* MANAGER
* OWNER

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Admin.Directory.directory_v1.Data.Member
## NOTES

## RELATED LINKS

# Add-GSGmailDelegate

## SYNOPSIS
Adds a delegate with its verification status set directly to accepted, without sending any verification email.
The delegate user must be a member of the same G Suite organization as the delegator user.

## SYNTAX

```
Add-GSGmailDelegate [-User] <String> [-Delegate] <String> [<CommonParameters>]
```

## DESCRIPTION
Adds a delegate with its verification status set directly to accepted, without sending any verification email.
The delegate user must be a member of the same G Suite organization as the delegator user.

Gmail imposes limtations on the number of delegates and delegators each user in a G Suite organization can have.
These limits depend on your organization, but in general each user can have up to 25 delegates and up to 10 delegators.

Note that a delegate user must be referred to by their primary email address, and not an email alias.

Also note that when a new delegate is created, there may be up to a one minute delay before the new delegate is available for use.

## EXAMPLES

### EXAMPLE 1
```
Add-GSGmailDelegate -User tony@domain.com -Delegate peter@domain.com
```

Provide Peter delegate access to Tony's inbox.

## PARAMETERS

### -Delegate
Delegate's email address to receive delegate access.

```yaml
Type: String
Parameter Sets: (All)
Aliases: To

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
User's email address to delegate access to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: From, Delegator

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Gmail.v1.Data.Delegate
## NOTES

## RELATED LINKS

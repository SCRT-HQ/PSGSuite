# Update-GSGmailAutoForwardingSettings

## SYNOPSIS
Updates the auto-forwarding setting for the specified account.
A verified forwarding address must be specified when auto-forwarding is enabled.

## SYNTAX

```
Update-GSGmailAutoForwardingSettings [-User] <String> [-Disposition <String>] [-EmailAddress <String>]
 [-Enabled] [<CommonParameters>]
```

## DESCRIPTION
Updates the auto-forwarding setting for the specified account.
A verified forwarding address must be specified when auto-forwarding is enabled.

## EXAMPLES

### EXAMPLE 1
```
Update-GSGmailAutoForwardingSettings -User me -Disposition leaveInInbox -EmailAddress joe@domain.com -Enabled
```

Enables auto forwarding of all mail for the AdminEmail user.
Forwarded mail will be left in their inbox.

## PARAMETERS

### -Disposition
The state that a message should be left in after it has been forwarded.

Acceptable values are:
* "archive": Archive the message.
* "dispositionUnspecified": Unspecified disposition.
* "leaveInInbox": Leave the message in the INBOX.
* "markRead": Leave the message in the INBOX and mark it as read.
* "trash": Move the message to the TRASH.

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

### -EmailAddress
Email address to which all incoming messages are forwarded.
This email address must be a verified member of the forwarding addresses.

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

### -Enabled
Whether all incoming mail is automatically forwarded to another address.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to update the AutoForwarding settings for

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

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

### Google.Apis.Gmail.v1.Data.AutoForwarding
## NOTES

## RELATED LINKS

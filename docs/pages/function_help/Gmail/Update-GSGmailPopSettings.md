# Update-GSGmailPopSettings

## SYNOPSIS
Updates POP settings

## SYNTAX

```
Update-GSGmailPopSettings [-User] <String> [-AccessWindow <String>] [-Disposition <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Updates POP settings

## EXAMPLES

### EXAMPLE 1
```
Update-GSGmailPopSettings -User me -AccessWindow allMail
```

Sets the POP AccessWindow to 'allMail' for the AdminEmail user

## PARAMETERS

### -AccessWindow
The range of messages which are accessible via POP.

Acceptable values are:
* "accessWindowUnspecified": Unspecified range.
* "allMail": Indicates that all unfetched messages are accessible via POP.
* "disabled": Indicates that no messages are accessible via POP.
* "fromNowOn": Indicates that unfetched messages received after some past point in time are accessible via POP.

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

### -Disposition
The action that will be executed on a message after it has been fetched via POP.

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

### -User
The user to update the POP settings for

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

### Google.Apis.Gmail.v1.Data.PopSettings
## NOTES

## RELATED LINKS

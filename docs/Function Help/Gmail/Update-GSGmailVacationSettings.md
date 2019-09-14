# Update-GSGmailVacationSettings

## SYNOPSIS
Updates vacation responder settings for the specified account.

## SYNTAX

```
Update-GSGmailVacationSettings [-User] <String> [-EnableAutoReply] [-EndTime <DateTime>]
 [-ResponseBodyHtml <String>] [-ResponseBodyPlainText <String>] [-ResponseSubject <String>]
 [-RestrictToContacts] [-RestrictToDomain] [-StartTime <DateTime>] [<CommonParameters>]
```

## DESCRIPTION
Updates vacation responder settings for the specified account.

## EXAMPLES

### EXAMPLE 1
```
Update-GSGmailVacationSettings -User me -ResponseBodyHtml "I'm on vacation and will reply when I'm back in the office. Thanks!" -RestrictToDomain -EndTime (Get-Date).AddDays(7) -StartTime (Get-Date) -EnableAutoReply
```

Enables the vacation auto-reply for the AdminEmail user.
Auto-replies will be sent to other users in the same domain only.
The vacation response is enabled for 7 days from the time that the command is sent.

### EXAMPLE 2
```
Update-GSGmailVacationSettings -User me -EnableAutoReply:$false
```

Disables the vacaction auto-response for the AdminEmail user immediately.

## PARAMETERS

### -EnableAutoReply
Flag that controls whether Gmail automatically replies to messages.

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

### -EndTime
An optional end time for sending auto-replies.
When this is specified, Gmail will automatically reply only to messages that it receives before the end time.
If both startTime and endTime are specified, startTime must precede endTime.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResponseBodyHtml
Response body in HTML format.
Gmail will sanitize the HTML before storing it.

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

### -ResponseBodyPlainText
Response body in plain text format.

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

### -ResponseSubject
Optional text to prepend to the subject line in vacation responses.
In order to enable auto-replies, either the response subject or the response body must be nonempty.

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

### -RestrictToContacts
Flag that determines whether responses are sent to recipients who are not in the user's list of contacts.

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

### -RestrictToDomain
Flag that determines whether responses are sent to recipients who are outside of the user's domain.
This feature is only available for G Suite users.

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

### -StartTime
An optional start time for sending auto-replies.
When this is specified, Gmail will automatically reply only to messages that it receives after the start time.
If both startTime and endTime are specified, startTime must precede endTime.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to update the VacationSettings settings for

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

### Google.Apis.Gmail.v1.Data.VacationSettings
## NOTES

## RELATED LINKS

# Get-GSGmailMessageList

## SYNOPSIS
Gets a list of messages

## SYNTAX

### Filter (Default)
```
Get-GSGmailMessageList [-User <String>] [-Filter <String[]>] [-LabelIds <String[]>] [-ExcludeChats]
 [-IncludeSpamTrash] [-PageSize <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

### Rfc822MsgId
```
Get-GSGmailMessageList [-User <String>] [-Rfc822MsgId <String>] [-LabelIds <String[]>] [-ExcludeChats]
 [-IncludeSpamTrash] [-PageSize <Int32>] [-Limit <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets a list of messages

## EXAMPLES

### EXAMPLE 1
```
Get-GSGmailMessageList -Filter "to:me","after:2017/12/25" -ExcludeChats
```

Gets the list of messages sent directly to the user after 2017/12/25 excluding chats

## PARAMETERS

### -ExcludeChats
Exclude chats from the message list

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

### -Filter
Only return messages matching the specified query.
Supports the same query format as the Gmail search box.
For example, "from:someuser@example.com rfc822msgid:\<lkj123l4jj1lj@gmail.com\> is:unread"

More info on Gmail search operators here: https://support.google.com/mail/answer/7190?hl=en

```yaml
Type: String[]
Parameter Sets: Filter
Aliases: Query

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeSpamTrash
Include messages from SPAM and TRASH in the results

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

### -LabelIds
Only return messages with labels that match all of the specified label IDs

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: LabelId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
The maximum amount of results you want returned.
Exclude or set to 0 to return all results

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: First

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
The page size of the result set

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 500
Accept pipeline input: False
Accept wildcard characters: False
```

### -Rfc822MsgId
The RFC822 Message ID to add to your filter.

```yaml
Type: String
Parameter Sets: Rfc822MsgId
Aliases: MessageId, MsgId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The primary email of the user to list messages for

Defaults to the AdminEmail user

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: Named
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Gmail.v1.Data.Message
## NOTES

## RELATED LINKS

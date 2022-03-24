# Add-GSGmailFilter

## SYNOPSIS
Adds a new Gmail filter

## SYNTAX

```
Add-GSGmailFilter [[-User] <String>] [-From <String>] [-To <String>] [-Subject <String>] [-Query <String>]
 [-NegatedQuery <String>] [-HasAttachment] [-ExcludeChats] [-AddLabelIDs <String[]>]
 [-RemoveLabelIDs <String[]>] [-Forward <String>] [-Size <Int32>] [-SizeComparison <String>] [-Raw]
 [<CommonParameters>]
```

## DESCRIPTION
Adds a new Gmail filter

## EXAMPLES

### EXAMPLE 1
```
Add-GSGmailFilter -To admin@domain.com -ExcludeChats -Forward "admin_directMail@domain.com"
```

Adds a filter for the AdminEmail user to forward all mail sent directly to the to "admin_directMail@domain.com"

## PARAMETERS

### -AddLabelIDs
List of labels to add to the message

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ExcludeChats
Whether the response should exclude chats

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Forward
Email address that the message should be forwarded to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -From
The sender's display name or email address.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -HasAttachment
Whether the message has any attachment

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NegatedQuery
Only return messages not matching the specified query.
Supports the same query format as the Gmail search box.
For example, "from:someuser@example.com rfc822msgid: is:unread"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Query
Only return messages matching the specified query.
Supports the same query format as the Gmail search box.
For example, "from:someuser@example.com rfc822msgid: is:unread"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Raw
If $true, returns the raw response.
If not passed or -Raw:$false, response is formatted as a flat object for readability

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

### -RemoveLabelIDs
List of labels to remove from the message

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Size
The size of the entire RFC822 message in bytes, including all headers and attachments

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SizeComparison
How the message size in bytes should be in relation to the size field.

Acceptable values are:
* "larger"
* "smaller"
* "unspecified"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Subject
Case-insensitive phrase found in the message's subject.
Trailing and leading whitespace are be trimmed and adjacent spaces are collapsed

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -To
The recipient's display name or email address.
Includes recipients in the "to", "cc", and "bcc" header fields.
You can use simply the local part of the email address.
For example, "example" and "example@" both match "example@gmail.com".
This field is case-insensitive

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The email of the user you are adding the filter for

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: False
Position: 1
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Gmail.v1.Data.Filter
## NOTES

## RELATED LINKS

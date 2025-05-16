# Update-GSGmailMessageLabels

## SYNOPSIS
Updates Gmail label information for the specified message

## SYNTAX

### MessageId (Default)
```
Update-GSGmailMessageLabels -MessageId <String[]> [-AddLabel <String[]>] [-RemoveLabel <String[]>]
 [-User <String>] [<CommonParameters>]
```

### Filter
```
Update-GSGmailMessageLabels -Filter <String> [-MaxToModify <Int32>] [-AddLabel <String[]>]
 [-RemoveLabel <String[]>] [-User <String>] [<CommonParameters>]
```

## DESCRIPTION
Updates Gmail label information for the specified message

## EXAMPLES

### EXAMPLE 1
```
Set-GSGmailLabel -user user@domain.com -LabelId Label_798170282134616520 -
```

Gets the Gmail labels of the AdminEmail user

## PARAMETERS

### -AddLabel
The label(s) to add to the message.
This supports either the unique LabelId or the Display Name for the label

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
The Gmail query to pull the list of messages to update instead of passing the MessageId directly.

```yaml
Type: String
Parameter Sets: Filter
Aliases: Query

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxToModify
The maximum amount of emails you would like to remove.
Use this with the \`Filter\` parameter as a safeguard.

```yaml
Type: Int32
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -MessageId
The unique Id of the message to update.

```yaml
Type: String[]
Parameter Sets: MessageId
Aliases: Id

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RemoveLabel
The label(s) to remove from the message.
This supports either the unique LabelId or the Display Name for the label

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to update message labels for

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

## NOTES

## RELATED LINKS

# Remove-GSGmailMessage

## SYNOPSIS
Removes a Gmail message from the user

## SYNTAX

### MessageId (Default)
```
Remove-GSGmailMessage -Id <String[]> [-Method <String>] [-User <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Filter
```
Remove-GSGmailMessage -Filter <String> [-MaxToModify <Int32>] [-Method <String>] [-User <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a Gmail message from the user

## EXAMPLES

### EXAMPLE 1
```
Remove-GSGmailMessage -User joe -Id 161622d7b76b7e1e,1616227c34d435f2
```

Moves the 2 message Id's from Joe's inbox into their TRASH after confirmation

## PARAMETERS

### -Filter
The Gmail query to pull the list of messages to remove instead of passing the MessageId directly

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

### -Id
The Id of the message to remove

```yaml
Type: String[]
Parameter Sets: MessageId
Aliases: MessageId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### -Method
The method used to delete the message

Available values are:
* "Trash": moves the message to the TRASH label (Default - preferred method, as this is recoverable)
* "Delete": permanently deletes the message (NON-RECOVERABLE!)

Default value is 'Trash'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Trash
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The primary email of the user to remove the message from

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

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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

## NOTES

## RELATED LINKS

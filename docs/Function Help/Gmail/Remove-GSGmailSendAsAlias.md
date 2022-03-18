# Remove-GSGmailSendAsAlias

## SYNOPSIS
Removes a Gmail SendAs alias.

## SYNTAX

```
Remove-GSGmailSendAsAlias [-SendAsEmail] <String[]> -User <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes a Gmail SendAs alias.

## EXAMPLES

### EXAMPLE 1
```
Remove-GSGmailSendAsAlias -SendAsEmail partyfuntime@domain.com -User joe@domain.com
```

Remove Joe's fun custom Sendas alias that he had created in the early days of the company :-(

## PARAMETERS

### -SendAsEmail
The SendAs alias to be removed.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: SendAs

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The email of the user you are removing the SendAs alias from.

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: True
Position: Named
Default value: None
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

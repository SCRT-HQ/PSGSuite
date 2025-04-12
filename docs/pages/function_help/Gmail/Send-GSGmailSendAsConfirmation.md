# Send-GSGmailSendAsConfirmation

## SYNOPSIS
Sends a verification email to the specified send-as alias address.
The verification status must be pending.

## SYNTAX

```
Send-GSGmailSendAsConfirmation [-SendAsEmail] <String[]> -User <String> [<CommonParameters>]
```

## DESCRIPTION
Sends a verification email to the specified send-as alias address.
The verification status must be pending.

## EXAMPLES

### EXAMPLE 1
```
Send-GSGmailSendAsConfirmation -SendAsEmail joseph.wiggum@work.com -User joe@domain.com
```

Sends a verification email to Joe's work address to confirm joe@domain.com as being able to send-as that account.

## PARAMETERS

### -SendAsEmail
The SendAs alias to be verified.

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
The email of the user you are verifying the SendAs alias for.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

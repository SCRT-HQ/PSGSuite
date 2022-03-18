# New-GSGmailSendAsAlias

## SYNOPSIS
Creates a new SendAs alias for a user.

## SYNTAX

```
New-GSGmailSendAsAlias [-User] <String> [-SendAsEmail] <String> [[-DisplayName] <String>] [-IsDefault]
 [[-ReplyToAddress] <String>] [[-Signature] <String>] [[-SmtpMsa] <SmtpMsa>] [-TreatAsAlias]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a new SendAs alias for a user.

## EXAMPLES

### EXAMPLE 1
```
$smtpMsa = Add-GSGmailSmtpMsa -Host 10.0.30.18 -Port 3770 -SecurityMode none -Username mailadmin -Password $(ConvertTo-SecureString $password -AsPlainText -Force)
```

New-GSGmailSendAsAlias -SendAsEmail joseph.wiggum@business.com -User joe@domain.com -Signature "\<div\>Thank you for your time,\</br\>Joseph Wiggum\</div\>" -SmtpMsa $smtpMsa

Creates a new SendAs alias for Joe's formal/work address including signature and SmtpMsa settings.

## PARAMETERS

### -DisplayName
A name that appears in the "From:" header for mail sent using this alias.

For custom "from" addresses, when this is empty, Gmail will populate the "From:" header with the name that is used for the primary address associated with the account.

If the admin has disabled the ability for users to update their name format, requests to update this field for the primary login will silently fail.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsDefault
Whether this address is selected as the default "From:" address in situations such as composing a new message or sending a vacation auto-reply.

Every Gmail account has exactly one default send-as address, so the only legal value that clients may write to this field is true.

Changing this from false to true for an address will result in this field becoming false for the other previous default address.

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

### -ReplyToAddress
An optional email address that is included in a "Reply-To:" header for mail sent using this alias.

If this is empty, Gmail will not generate a "Reply-To:" header.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SendAsEmail
The email address that appears in the "From:" header for mail sent using this alias.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Signature
An optional HTML signature that is included in messages composed with this alias in the Gmail web UI.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpMsa
An optional SMTP service that will be used as an outbound relay for mail sent using this alias.

If this is empty, outbound mail will be sent directly from Gmail's servers to the destination SMTP service.
This setting only applies to custom "from" aliases.

Use the helper function Add-GmailSmtpMsa to create the correct object for this parameter.

```yaml
Type: SmtpMsa
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TreatAsAlias
Whether Gmail should treat this address as an alias for the user's primary email address.

This setting only applies to custom "from" aliases.

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
The user to create the SendAs alias for.

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

### Google.Apis.Gmail.v1.Data.SendAs
## NOTES

## RELATED LINKS

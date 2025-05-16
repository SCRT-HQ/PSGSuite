# Add-GSGmailSmtpMsa

## SYNOPSIS
Builds a SmtpMsa object to use when creating or updating SmtpMsa settings withing the Gmail SendAs settings.

## SYNTAX

### InputObject (Default)
```
Add-GSGmailSmtpMsa [-InputObject <SmtpMsa[]>] [<CommonParameters>]
```

### Fields
```
Add-GSGmailSmtpMsa -HostName <String> -Port <Int32> -SecurityMode <String> [-Username <String>]
 [-Password <SecureString>] [<CommonParameters>]
```

## DESCRIPTION
Builds a SmtpMsa object to use when creating or updating SmtpMsa settings withing the Gmail SendAs settings.

## EXAMPLES

### EXAMPLE 1
```
$smtpMsa = Add-GSGmailSmtpMsa -Host 10.0.30.18 -Port 3770 -SecurityMode none -Username mailadmin -Password $(ConvertTo-SecureString $password -AsPlainText -Force)
```

Update-GSGmailSendAsSettings -SendAsEmail joseph.wiggum@business.com -User joe@domain.com -Signature "\<div\>Thank you for your time,\</br\>Joseph Wiggum\</div\>" -SmtpMsa $smtpMsa

Updates Joe's SendAs settings for his work SendAs alias, including signature and SmtpMsa settings.

## PARAMETERS

### -HostName
The hostname of the SMTP service.

```yaml
Type: String
Parameter Sets: Fields
Aliases: Host

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
Used for pipeline input of an existing UserAddress object to strip the extra attributes and prevent errors

```yaml
Type: SmtpMsa[]
Parameter Sets: InputObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Password
The password that will be used for authentication with the SMTP service.

This is a write-only field that can be specified in requests to create or update SendAs settings; it is never populated in responses.

```yaml
Type: SecureString
Parameter Sets: Fields
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
The port of the SMTP service.

```yaml
Type: Int32
Parameter Sets: Fields
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecurityMode
The protocol that will be used to secure communication with the SMTP service.

Acceptable values are:
* "none"
* "securityModeUnspecified"
* "ssl"
* "starttls"

```yaml
Type: String
Parameter Sets: Fields
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
The username that will be used for authentication with the SMTP service.

This is a write-only field that can be specified in requests to create or update SendAs settings; it is never populated in responses.

```yaml
Type: String
Parameter Sets: Fields
Aliases:

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

### Google.Apis.Gmail.v1.Data.SmtpMsa
## NOTES

## RELATED LINKS

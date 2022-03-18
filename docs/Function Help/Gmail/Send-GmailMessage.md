# Send-GmailMessage

## SYNOPSIS
Sends a Gmail message

## SYNTAX

```
Send-GmailMessage [[-From] <String>] [-Subject] <String> [[-Body] <String>] [[-To] <String[]>]
 [[-CC] <String[]>] [[-BCC] <String[]>] [[-Attachments] <String[]>] [-BodyAsHtml] [<CommonParameters>]
```

## DESCRIPTION
Sends a Gmail message.
Designed for parity with Send-GmailMessage

## EXAMPLES

### EXAMPLE 1
```
Send-GmailMessage -From Joe -To john.doe@domain.com -Subject "New Pricing Models" -Body $body -BodyAsHtml -Attachments 'C:\Reports\PricingModel_2018.xlsx'
```

Sends a message from Joe to john.doe@domain.com with HTML body and an Excel spreadsheet attached

## PARAMETERS

### -Attachments
The attachment(s) of the email

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BCC
The Bcc recipient(s) of the email

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
The email body.
Supports HTML when used in conjunction with the -BodyAsHtml parameter

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

### -BodyAsHtml
If passed, renders the HTML content of the body on send

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

### -CC
The Cc recipient(s) of the email

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -From
The primary email of the user that is sending the message.
This MUST be a user account owned by the customer, as the Gmail Service must be built under this user's context and will fail if a group or alias is passed instead

Defaults to the AdminEmail user

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail, User

Required: False
Position: 1
Default value: $Script:PSGSuite.AdminEmail
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subject
The subject of the email

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

### -To
The To recipient(s) of the email

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

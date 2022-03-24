# New-GSGmailSMIMEInfo

## SYNOPSIS
Adds Gmail S/MIME info

## SYNTAX

```
New-GSGmailSMIMEInfo [-SendAsEmail] <String> [-Pkcs12] <String> [[-EncryptedKeyPassword] <SecureString>]
 [-IsDefault] [-User] <String> [<CommonParameters>]
```

## DESCRIPTION
Adds Gmail S/MIME info

## EXAMPLES

### EXAMPLE 1
```
New-GSGmailSMIMEInfo -SendAsEmail 'joe@otherdomain.com' -Pkcs12 .\MyCert.pfx -User joe@domain.com
```

Creates a specified S/MIME for Joe's SendAsEmail 'joe@otherdomain.com' using the provided PKCS12 certificate

## PARAMETERS

### -EncryptedKeyPassword
Encrypted key password, when key is encrypted.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsDefault
Whether this SmimeInfo is the default one for this user's send-as address.

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

### -Pkcs12
PKCS#12 format containing a single private/public key pair and certificate chain.
This format is only accepted from client for creating a new SmimeInfo and is never returned, because the private key is not intended to be exported.
PKCS#12 may be encrypted, in which case encryptedKeyPassword should be set appropriately.

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

### -SendAsEmail
The email address that appears in the "From:" header for mail sent using this alias.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -User
The user's email address

```yaml
Type: String
Parameter Sets: (All)
Aliases: PrimaryEmail, UserKey, Mail

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Google.Apis.Gmail.v1.Data.SmimeInfo
## NOTES

## RELATED LINKS

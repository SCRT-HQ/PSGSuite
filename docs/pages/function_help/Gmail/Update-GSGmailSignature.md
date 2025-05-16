# Update-GSGmailSignature

## SYNOPSIS
Updates the Gmail signature for a user's SendAs alias.

## SYNTAX

### Signature
```
Update-GSGmailSignature -User <String> [-SendAsEmail <String>] -Signature <String> [-AsPlainText]
 [<CommonParameters>]
```

### SignatureFile
```
Update-GSGmailSignature -User <String> [-SendAsEmail <String>] -SignatureFile <String> [-AsPlainText]
 [<CommonParameters>]
```

## DESCRIPTION
Updates the Gmail signature for a user's SendAs alias.

## EXAMPLES

### EXAMPLE 1
```
Thank you for your time,</br>Joseph Wiggum</div>"
```

Updates Joe's SendAs signature for his formal alias.

## PARAMETERS

### -AsPlainText
If $true, this wraps your Signature or SignatureFile contents in standard HTML that Google would normally add (div wrappers around each line with font-size:small on all and empty lines replaced with \<br\>).

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

### -SendAsEmail
The SendAs alias to be updated.
Defaults to the User specified if this parameter is excluded.

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

### -Signature
An HTML signature that is included in messages composed with this alias in the Gmail web UI.

```yaml
Type: String
Parameter Sets: Signature
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SignatureFile
A file containing the HTML signature that is included in messages composed with this alias in the Gmail web UI.

The file will be read in with Get-Content $SignatureFile -Raw.

```yaml
Type: String
Parameter Sets: SignatureFile
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
The user to update the SendAs signature for.

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

### Google.Apis.Gmail.v1.Data.SendAs
## NOTES

## RELATED LINKS

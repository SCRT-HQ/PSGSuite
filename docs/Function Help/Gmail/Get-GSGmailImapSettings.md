# Get-GSGmailImapSettings

## SYNOPSIS
Gets IMAP settings

## SYNTAX

```
Get-GSGmailImapSettings [[-User] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets IMAP settings

## EXAMPLES

### EXAMPLE 1
```
Get-GSGmailImapSettings
```

Gets the IMAP settings for the AdminEmail user

## PARAMETERS

### -User
The user to get the IMAP settings for

Defaults to the AdminEmail user

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

### Google.Apis.Gmail.v1.Data.ImapSettings
## NOTES

## RELATED LINKS
